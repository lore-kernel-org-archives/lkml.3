Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3JGP6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:58:13 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55438 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JGP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:58:12 -0400
Date: Mon, 7 Oct 2013 17:58:05 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: SmartMIPS: Fix build
Message-ID: <20131007155805.GH3098@linux-mips.org>
References: <1381158642-10598-1-git-send-email-treding@nvidia.com>
 <5252D343.6090100@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252D343.6090100@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 04:29:07PM +0100, Markos Chandras wrote:

> On 10/07/13 16:10, Thierry Reding wrote:
> >All CONFIG_CPU_HAS_SMARTMIPS #ifdefs have been removed from code, but
> >the ACX register declaration in struct pt_regs is still protected by it,
> >causing builds to fail. Remove the #ifdef protection and always declare
> >the register.
> >
> >Signed-off-by: Thierry Reding <treding@nvidia.com>
> >---
> >  arch/mips/include/asm/ptrace.h | 2 --
> >  1 file changed, 2 deletions(-)
> >
> >diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
> >index 7bba9da..d47bdce 100644
> >--- a/arch/mips/include/asm/ptrace.h
> >+++ b/arch/mips/include/asm/ptrace.h
> >@@ -33,9 +33,7 @@ struct pt_regs {
> >  	unsigned long cp0_status;
> >  	unsigned long hi;
> >  	unsigned long lo;
> >-#ifdef CONFIG_CPU_HAS_SMARTMIPS
> >  	unsigned long acx;
> >-#endif
> >  	unsigned long cp0_badvaddr;
> >  	unsigned long cp0_cause;
> >  	unsigned long cp0_epc;
> >
> 
> Hi Thierry,
> 
> Looks good to me. Thanks!
> 
> Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>

Looking good - but I've already pulled the offending patch.  Processor
specific registers in the register frame have historically been a PITA -
in particular because much of what's requiring space there is also
requiring space in the signal frame and that's a kernel ABI.

  Ralf
