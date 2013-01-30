Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3A3QrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:47:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58377 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3A3QrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:47:02 -0500
Date: Wed, 30 Jan 2013 17:46:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Madore <michael.madore@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Opteron 6276 Corrected ECC errors
Message-ID: <20130130164657.GA23980@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michael Madore <michael.madore@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAO-9seDOX5wPrjPP0y2cFpqu_Lwo73yyGxfMGjYbBXz7gk24_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO-9seDOX5wPrjPP0y2cFpqu_Lwo73yyGxfMGjYbBXz7gk24_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 11:29:47AM -0500, Michael Madore wrote:
> Supermicro H8QGi-F server board (AMD SR5690/SR5670/SP5100 Chipset)
> 4 X AMD Opteron 6276 processors
> 32 X 8GB (256GB) DDR3-1600 ECC Registered memory
> Debian with kernel 3.2.35-2
> 
> We have received the following two hardware errors:
> 
> 9/10/12
> 
> [591006.120039] [Hardware Error]: CPU:58
> MC2_STATUS[-|CE|MiscV|-|-|-|-|CECC]: 0x9842c000000c0176
> [591006.120048] [Hardware Error]: Combined Unit Error: VB Data/ECC error.
> [591006.120052] [Hardware Error]: cache level: L2, tx: DATA, mem-tx: EV
> 
> 1/21/12
> 
> [549004.336097] [Hardware Error]: CPU:40
> MC4_STATUS[-|CE|MiscV|-|AddrV|-|-|CECC]: 0x9c3444e0001f010b
> [549004.336111] [Hardware Error]:       MC4_ADDR: 0x000000000000e480
> [549004.336117] [Hardware Error]: Northbridge Error (node 5): ECC
> Error in the Probe Filter directory.
> [549004.336125] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: GEN
> 
> If I understand correctly, both of these errors represent single bit
> corrected errors in the CPU cache.

Internal CPU structures, victim buffer the first and the second in the
probe filter which is part of L3.

> On both occasions the system continued to function normally after the
> error was reported.

As expected; both are single-bit ECC errors which were corrected and
system state wasn't influenced.

> Is receiving two such errors (on different CPUs) over such a time span
> cause for concern?

Not really. I'd say, only if the error rate starts increasing over time
and the error types keep repeating.

> The end user is concerned there is a serious hardware problem. I'm
> reluctant to start replacing CPUs, however, without seeing a repeated
> pattern of errors.

Yes, no need to replace, simply watch the error rates. Maybe check the
temperature of the CPUs, possibly improve cooling are some of the things
that come to mind.

> Any advice or pointers to more appropriate resources would be greatly
> appreciated.

Search the net for "x86 RAS" and start reading. :-) This could be a good
start:

http://en.wikipedia.org/wiki/Reliability,_availability_and_serviceability_%28computer_hardware%29

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
