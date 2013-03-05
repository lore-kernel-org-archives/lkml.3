Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3CEHDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:03:41 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38810 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3CEHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:03:40 -0500
Date: Tue, 5 Mar 2013 12:33:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v4 5/6] uretprobes: invoke return probe handlers
Message-ID: <20130305070326.GA5684@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1362407893-32505-1-git-send-email-anton@redhat.com> <1362407893-32505-6-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362407893-32505-6-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030507-7606-0000-0000-0000091615B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 03:38:12PM +0100, Anton Arapov wrote:
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index c353555..fa9d9de 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -56,4 +56,9 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
> +
> +static inline unsigned long arch_uretprobe_get_sp(struct pt_regs *regs)
> +{
> +	return (unsigned long)regs->sp;
> +}

You could use GET_USP() here.

