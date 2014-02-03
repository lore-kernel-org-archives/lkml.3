Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBCO5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:57:36 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:53795 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaBCO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:57:35 -0500
Message-ID: <1391439425.3509.16.camel@linaro1.home>
Subject: Re: [PATCH v5 07/16] ARM: Remove use of struct kprobe from generic
 probes code
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 03 Feb 2014 14:57:05 +0000
In-Reply-To: <1390507559-4697-8-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
	 <1390507559-4697-8-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Change the generic ARM probes code to pass in the opcode and architecture-specific
> structure separately instead of using struct kprobe, so we do not pollute
> code being used only for uprobes or other non-kprobes instruction
> interpretation.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

One minor nit-pick...

[...]
> diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
> index c7ee290..cea707a 100644
> --- a/arch/arm/kernel/kprobes-thumb.c
> +++ b/arch/arm/kernel/kprobes-thumb.c
[...]
> @@ -593,7 +590,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
>  	bx_write_pc(pc, regs);
>  }
>  
> -static enum kprobe_insn __kprobes
> +enum kprobe_insn __kprobes
>  t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>  		struct decode_header *d)
>  {

The above removal of 'static' appears to be an unneeded accidental
change?

-- 
Tixy

