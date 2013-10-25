Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3JYPYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:24:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51607 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab3JYPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:24:34 -0400
Date: Fri, 25 Oct 2013 16:24:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Subject: Re: [PATCH RFC 6/6] kprobes: Add cases for arm and arm64 in sample
 module
Message-ID: <20131025152428.GD10673@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1382008671-4515-7-git-send-email-sandeepa.prabhu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382008671-4515-7-git-send-email-sandeepa.prabhu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:17:51PM +0100, Sandeepa Prabhu wrote:
> Add info prints in sample kprobe handlers for ARM and ARM64
> architecture.
> 
> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> ---
>  samples/kprobes/kprobe_example.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
> index 366db1a..0521246 100644
> --- a/samples/kprobes/kprobe_example.c
> +++ b/samples/kprobes/kprobe_example.c
> @@ -42,6 +42,14 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
>  			" ex1 = 0x%lx\n",
>  		p->addr, regs->pc, regs->ex1);
>  #endif
> +#ifdef CONFIG_ARM
> +	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
> +			p->addr, regs->ARM_pc);
> +#endif
> +#ifdef CONFIG_ARM64
> +	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
> +		p->addr, (long)regs->pc);
> +#endif

Huh? Why can't you combine these two together and either unconditionall cast
to long, or use void * and %p?

Will
