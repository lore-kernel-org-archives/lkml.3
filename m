Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936677Ab3DJUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:22:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56319 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764955Ab3DJUWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:22:25 -0400
Date: Wed, 10 Apr 2013 22:22:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH UPDATED 1/7] x86: don't show trace into stacktrace
 machinery
Message-ID: <20130410202220.GB6854@pd.tnic>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
 <20130410201020.GF17641@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130410201020.GF17641@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 01:10:20PM -0700, Tejun Heo wrote:
> +/* sanity check helper for dump_trace(), see dump_trace_current_frame() */
> +static inline void
> +dump_trace_warn_current_frame(struct task_struct *task, struct pt_regs *regs,
> +			      unsigned long bp)
> +{
> +	if ((!task || task == current) && !regs && !bp)
> +		printk(KERN_WARNING "dump_trace: %pf didn't specify neither frame nor regs for %%current\n",

This is double negation and is generally wrong in English. I think you
want to say:

"%pf specified neither frame nor regs for ..."

or

"%pf didn't specify either frame or regs for ..."

Or maybe even passive and shorter:

"%pf: No frame or regs specified for %%current."

and so on.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
