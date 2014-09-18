Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaIRTPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:15:05 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63127 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaIRTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:15:03 -0400
Message-ID: <541B2F33.8000002@amacapital.net>
Date: Thu, 18 Sep 2014 12:14:59 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
CC: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
References: <20140918135202.GA26038@khazad-dum.debian.net>
In-Reply-To: <20140918135202.GA26038@khazad-dum.debian.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 06:52 AM, Henrique de Moraes Holschuh wrote:
> The new Haswell microcode update[1] removes the "hle" (hardware lock
> elision) processor capability.  And it is not cosmetic, either: Intel TSX
> opcodes will cause an illegal opcode trap after the microcode update[2].
> 
> This means cpu_info()->x86_capability becomes stale after the microcode
> update.
> 
> We could add logic to compute the new x86_capability after a microcode
> update run, and OOPS the kernel if something too important (i.e. anything
> the kernel uses) went away.  Otherwise, refresh cpu_info()->x86_capability.
> 
> Is that doable?
> 
> 
> [1] sig 0x000306f2, pf mask 0x6f, 2014-09-03, rev 0x0029, size 28672
>     sig 0x000306c3, pf mask 0x32, 2014-07-03, rev 0x001c, size 21504
>     sig 0x00040651, pf mask 0x72, 2014-07-03, rev 0x001c, size 20480
>     sig 0x00040661, pf mask 0x32, 2014-07-03, rev 0x0012, size 23552

This is HSD136, right?  Do you have a link to where that ucode comes
from?  Does it have release notes?

> 
> [2] instantly segfaulting every running process using libpthread-2.19,
>     as well as any other users of Intel TSX.
>     https://bugs.launchpad.net/intel/+bug/1370352
> 
>     And yes, this means we will kill support for microcode updates
>     outside of the initramfs/early-initramfs, at least in Debian,
>     and likely in Ubuntu.
> 

Given that there is exactly one microcode update like this (at least of
the sort that blows up userspace), I think that we should seriously
consider blacklisting just this particular microcode update once
userspace is running.

--Andy
