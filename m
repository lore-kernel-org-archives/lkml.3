Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3DZKjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:39:33 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57126 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760116Ab3DZKj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:39:26 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 12/21] irqchip: s3c24xx: add missing __init annotations
Date: Fri, 26 Apr 2013 12:39:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1366910944-3033663-13-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304261239.38737.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 25. April 2013, 19:28:55 schrieb Arnd Bergmann:
> The s3c24xx_init_intc and s3c2412_init_irq functions are only called
> at init time, and they call functions already marked __init, so they
> should be marked in the same way. This was reported as
> 
> WARNING: vmlinux.o(.text+0x19e0b4): Section mismatch in reference from the
> function s3c2412_init_irq() to the function
> .init.text:s3c24xx_init_intc.constprop.8() The function s3c2412_init_irq()
> references
> the function __init s3c24xx_init_intc.constprop.8().
> This is often because s3c2412_init_irq lacks a __init
> annotation or the annotation of s3c24xx_init_intc.constprop.8 is wrong.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Yeah, it seems "someone" forgot these, thanks for catching this.

Acked-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  drivers/irqchip/irq-s3c24xx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
> index c8afd7b..bbcc944 100644
> --- a/drivers/irqchip/irq-s3c24xx.c
> +++ b/drivers/irqchip/irq-s3c24xx.c
> @@ -535,7 +535,7 @@ static void s3c24xx_clear_intc(struct s3c_irq_intc
> *intc) }
>  }
> 
> -static struct s3c_irq_intc *s3c24xx_init_intc(struct device_node *np,
> +static struct s3c_irq_intc * __init s3c24xx_init_intc(struct device_node
> *np, struct s3c_irq_data *irq_data,
>  				       struct s3c_irq_intc *parent,
>  				       unsigned long address)
> @@ -795,7 +795,7 @@ static struct s3c_irq_data init_s3c2412subint[32] = {
>  	{ .type = S3C_IRQTYPE_LEVEL, .parent_irq = 21 }, /* CF */
>  };
> 
> -void s3c2412_init_irq(void)
> +void __init s3c2412_init_irq(void)
>  {
>  	pr_info("S3C2412: IRQ Support\n");

