Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3ASDYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:24:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47106 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ASDX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:23:59 -0500
Date: Sat, 19 Jan 2013 03:23:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 19/76] ARC: Signal handling
Message-ID: <20130119032357.GB23552@ZenIV.linux.org.uk>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-20-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-20-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:54:33PM +0530, Vineet Gupta wrote:
> +SYSCALL_DEFINE0(rt_sigreturn)
> +{
> +	struct rt_sigframe __user *sf;
> +	unsigned int magic;
> +	int err;
> +	struct pt_regs *regs = task_pt_regs(current);

ITYM current_pt_regs()...

> +	if (unlikely(is_do_ss_needed(magic)))
> +		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
	if (!restore_altstack(&sf->uc.uc_stack))
please...

> +		stk.ss_sp = (void __user *)current->sas_ss_sp;
> +		stk.ss_flags = sas_ss_flags(regs->sp);
> +		stk.ss_size = current->sas_ss_size;
> +		err |= __copy_to_user(&sf->uc.uc_stack, &stk, sizeof(stk));
that would be
                err |= __save_altstack(&frame->uc.uc_stack, regs->sp);

