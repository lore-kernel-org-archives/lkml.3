Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbaLWVCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:02:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52155 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaLWVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:02:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Baruch Siach <baruch@tkos.co.il>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] irqchip: Conexant CX92755 interrupts controller driver
Date: Tue, 23 Dec 2014 22:02:18 +0100
Message-ID: <16151065.LjzHK8TaOo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7997c913e9f6debc09fd62c788b8ac6bd330d4f3.1419318109.git.baruch@tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il> <7997c913e9f6debc09fd62c788b8ac6bd330d4f3.1419318109.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:rN0MR2VOtD/gfu5KjkGd739E0xRhw/29s2xF5H0Lxt0A8th+Bhu
 B/REMw7mYPfjaUT7kfMlnCnFBMr3pLuyY4XUV5B2f9pAStWuPSEdAUMM2NVa7IDCmwa+jv7
 hWvvPP99+Pcl+ft3LQEJQC6T88w0q7pSO5mxIbB+sryj3vaAJHvi/WSFPv6W557ibQu9FcU
 QWIuvAWoBGjJqJkNT8hSA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 09:58:42 Baruch Siach wrote:
> +static void __exception_irq_entry digicolor_handle_irq(struct pt_regs *regs)
> +{
> +       u32 status, hwirq;
> +
> +       do {
> +               status = readl(digicolor_irq_base + IC_INT0STATUS_LO);
> +               if (status) {
> +                       hwirq = ffs(status) - 1;
> +               } else {
> +                       status = readl(digicolor_irq_base + IC_INT0STATUS_XLO);
> +                       if (status)
> +                               hwirq = ffs(status) - 1 + 32;
> +                       else
> +                               return;
> +               }
> +
> +               handle_domain_irq(digicolor_irq_domain, hwirq, regs);
> +       } while (1);
> +}
> 

Have you tried using the generic_irqchip code for this? The hardware
seems simple enough.

	Arnd
