Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaJPF6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:58:09 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48343 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaJPF6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:58:08 -0400
Date: Thu, 16 Oct 2014 11:27:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 10/10] uprobes: Remove "weak" from function
 declarations
Message-ID: <20141016055758.GA24804@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170650.4063.2816.stgit@bhelgaas-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20141015170650.4063.2816.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101605-4790-0000-0000-0000044D7D74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bjorn Helgaas <bhelgaas@google.com> [2014-10-15 11:06:50]:

> For the following interfaces:
> 
>   set_swbp()
>   set_orig_insn()
>   is_swbp_insn()
>   is_trap_insn()
>   uprobe_get_swbp_addr()
>   arch_uprobe_ignore()
>   arch_uprobe_copy_ixol()
> 
> kernel/events/uprobes.c provides default definitions explicitly marked
> "weak".  Some architectures provide their own definitions intended to
> override the defaults, but the "weak" attribute on the declarations applied
> to the arch definitions as well, so the linker chose one based on link
> order (see 10629d711ed7 ("PCI: Remove __weak annotation from
> pcibios_get_phb_of_node decl")).
> 
> Remove the "weak" attribute from the declarations so we always prefer a
> non-weak definition over the weak one, independent of link order.
> 

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Victor Kamensky <victor.kamensky@linaro.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: David A. Long <dave.long@linaro.org>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  include/linux/uprobes.h |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 4f844c6b03ee..60beb5dc7977 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -98,11 +98,11 @@ struct uprobes_state {
>  	struct xol_area		*xol_area;
>  };
>  
> -extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
> -extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
> -extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
> -extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
> -extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
> +extern int set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
> +extern int set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
> +extern bool is_swbp_insn(uprobe_opcode_t *insn);
> +extern bool is_trap_insn(uprobe_opcode_t *insn);
> +extern unsigned long uprobe_get_swbp_addr(struct pt_regs *regs);
>  extern unsigned long uprobe_get_trap_addr(struct pt_regs *regs);
>  extern int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t);
>  extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
> @@ -128,8 +128,8 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
> -extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern void __weak arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
> +extern bool arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
>  					 void *src, unsigned long len);
>  #else /* !CONFIG_UPROBES */
>  struct uprobes_state {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks and Regards
Srikar Dronamraju

