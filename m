Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3CRLHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:07:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CRLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <51459188.7000104@opello.org>
References: <51459188.7000104@opello.org>
Date: Mon, 18 Mar 2013 12:07:18 +0100
Message-ID: <CAHTX3dKT5Uvfivy87zcdrCA4Xz2XT5xYK0Ud2bXMgB3DbQnH-w@mail.gmail.com>
Subject: Re: [PATCH] microblaze: intc: set the default irq_domain
From: Michal Simek <monstr@monstr.eu>
To: Dan Christensen <opello@opello.org>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/17 Dan Christensen <opello@opello.org>:
> Register the irq_domain created during initialization as the default so
> that device drivers can pass NULL to irq_create_mapping and get a
> virtual irq to pass to request_irq.
>
> Signed-off-by: Dan Christensen <opello@opello.org>
> ---
>  arch/microblaze/kernel/intc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index 8778adf..d85fa3a 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -172,4 +172,6 @@ void __init init_IRQ(void)
>          * and commits this patch.  ~~gcl */
>         root_domain = irq_domain_add_linear(intc, nr_irq, &xintc_irq_domain_ops,
>                                                         (void *)intr_mask);
> +
> +       irq_set_default_host(root_domain);
>  }
> --
> 1.7.0.4
>

Applied.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
