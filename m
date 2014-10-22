Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaJVWWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:22:21 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:8339 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbaJVWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:22:20 -0400
Date: Wed, 22 Oct 2014 23:22:16 +0100
From: James Hogan <james.hogan@imgtec.com>
To: Eunbong Song <eunb.song@samsung.com>
CC: <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
Message-ID: <20141022222216.GD12296@jhogan-linux.le.imgtec.org>
References: <1669712409.167661413959996217.JavaMail.weblogic@epmlwas02b>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1669712409.167661413959996217.JavaMail.weblogic@epmlwas02b>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 06:39:56AM +0000, Eunbong Song wrote:
> This patch adds arch_trigger_all_cpu_backtrace() for mips architecture.

Don't forget your Signed-off-by

> +static void arch_dump_stack(void *info)
> +{
> +	struct pt_regs *regs;  
> +	
> +	regs = get_irq_regs();
> +
> +	if(regs)
> +		show_regs(regs);
> +
> +	dump_stack();
> +}
> +
> +void arch_trigger_all_cpu_backtrace(bool include_self)
> +{
> +	smp_call_function(arch_dump_stack, NULL, 1);

should this call arch_dump_stack directly too if include_self?

Cheers
James
