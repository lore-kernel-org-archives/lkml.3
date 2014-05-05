Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaEEPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaEEPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:46:21 -0400
Date: Mon, 5 May 2014 17:45:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] uprobes: fix scratch register selection for
	rip-relative fixups
Message-ID: <20140505154559.GA27072@redhat.com>
References: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02, Denys Vlasenko wrote:
>
> v2: More robust checks of vex.vvvv (32-bit mode safe),
>     simplified scratch reg selection code,
>     moved comments around as requested by Oleg.

OK, thanks. Given that this patch was acked by Jim, I am going to
apply it. I'll try to run a couple of systemtap scripts with this
patch, but unfortunately the "full" testing is simply impossible.

Denys, I'll also include your test-case into the changelog.

And,

>  static inline unsigned long *
>  scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	return (auprobe->def.fixups & UPROBE_FIX_RIP_AX) ? &regs->ax : &regs->cx;
> +	/* Order is important - more than one bit can be set! */

Really?

Should I remove this comment or I misread the change in riprel_analyze?

Oleg.

