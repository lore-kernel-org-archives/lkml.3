Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaBJV6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:58:43 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65245 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBJV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:58:41 -0500
MIME-Version: 1.0
In-Reply-To: <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org> <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 10 Feb 2014 21:58:20 +0000
X-Google-Sender-Auth: qRJ1YqhQ-AVHjmQTZ0DJsE8zh04
Message-ID: <CACxGe6vyuZTuMx_posAyu335D3FnFRro24bHR-HNKzG2AuOwDQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] arm: Get rid of meminfo
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 12:02 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> memblock is now fully integrated into the kernel and is the prefered
> method for tracking memory. Rather than reinvent the wheel with
> meminfo, migrate to using memblock directly instead of meminfo as
> an intermediate.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index b0df976..b6de661 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -625,15 +625,8 @@ void __init dump_machine_table(void)
>
>  int __init arm_add_memory(u64 start, u64 size)
>  {
> -       struct membank *bank = &meminfo.bank[meminfo.nr_banks];
>         u64 aligned_start;

With the changes to this function, I think you can outright remove
early_init_dt_add_memory_arch() from arch/arm/kernel/devtree.c. The
default implementation (__weak) in drivers/of/fdt.c uses memblock
directly.

g.
