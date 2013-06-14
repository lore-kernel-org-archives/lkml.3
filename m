Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3FNLMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:12:36 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37501 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3FNLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:12:34 -0400
Date: Fri, 14 Jun 2013 13:12:23 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
Message-ID: <20130614111223.GB15775@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:04PM -0700, David Daney wrote:

> Subject: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via the
>  MIPS-VZ extensions.
> 
> From: David Daney <david.daney@cavium.com>
> 
> These patches take a somewhat different approach to MIPS
> virtualization via the MIPS-VZ extensions than the patches previously
> sent by Sanjay Lal.
> 
> Several facts about the code:
> 
> o Existing exception handlers are modified to hook in to KVM instead
>   of intercepting all exceptions via the EBase register, and then
>   chaining to real exception handlers.
> 
> o Able to boot 64-bit SMP guests that use the FPU (I have booted 4-way
>   SMP 64-bit MIPS/Linux).
> 
> o Additional overhead on every exception even when *no* vCPU is running.
> 
> o Lower interrupt overhead, than the EBase interception method, when
>   vCPU *is* running.
> 
> o This code is somewhat smaller than the existing trap/emulate
>   implementation (about 2100 lines vs. about 5300 lines)
> 
> o Currently probably only usable on the OCTEON III CPU model, as some
>   MIPS-VZ implementation-defined behaviors were assumed to have the
>   OCTEON III behavior.
> 
> Note: I think Ralf already has the 17/31 (MIPS: Quit exposing Kconfig
> symbols in uapi headers.) queued, but I also include it here.

Yes; as the references to CONFIG_* symbols in UAPI were a bug, I've
already merged this patch for 3.10 as 8f657933a3c2086d4731350c98f91a990783c0d3
[MIPS: Quit exposing Kconfig symbols in uapi headers.]

  Ralf
