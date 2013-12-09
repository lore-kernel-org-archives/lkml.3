Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593Ab3LIVRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:17:36 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53963 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761403Ab3LIVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:17:35 -0500
Message-ID: <52A63369.8010000@samsung.com>
Date: Tue, 10 Dec 2013 06:17:29 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][RESEND] ARM: SAMSUNG: remove IRQF_DISABLED
References: <000801cec874$%han@samsung.com> <1386579735-4065-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1386579735-4065-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 18:02, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker<michael.opdenacker@free-electrons.com>
> Reviewed-by: Jingoo Han<jg1.han@samsung.com>
> ---
>   arch/arm/mach-s3c24xx/dma.c         | 2 +-
>   arch/arm/mach-s3c24xx/simtec-usb.c  | 3 +--
>   arch/arm/mach-s3c64xx/mach-smartq.c | 2 +-
>   3 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-s3c24xx/dma.c b/arch/arm/mach-s3c24xx/dma.c
> index 4a65cba3295d..a8dafc174fe3 100644
> --- a/arch/arm/mach-s3c24xx/dma.c
> +++ b/arch/arm/mach-s3c24xx/dma.c
> @@ -742,7 +742,7 @@ int s3c2410_dma_request(enum dma_ch channel,
>   		chan->irq_claimed = 1;
>   		local_irq_restore(flags);
>
> -		err = request_irq(chan->irq, s3c2410_dma_irq, IRQF_DISABLED,
> +		err = request_irq(chan->irq, s3c2410_dma_irq, 0,
>   				  client->name, (void *)chan);
>
>   		local_irq_save(flags);
> diff --git a/arch/arm/mach-s3c24xx/simtec-usb.c b/arch/arm/mach-s3c24xx/simtec-usb.c
> index 2ed2e32430dc..bb3eac6a7697 100644
> --- a/arch/arm/mach-s3c24xx/simtec-usb.c
> +++ b/arch/arm/mach-s3c24xx/simtec-usb.c
> @@ -78,8 +78,7 @@ static void usb_simtec_enableoc(struct s3c2410_hcd_info *info, int on)
>
>   	if (on) {
>   		ret = request_irq(BAST_IRQ_USBOC, usb_simtec_ocirq,
> -				  IRQF_DISABLED | IRQF_TRIGGER_RISING |
> -				   IRQF_TRIGGER_FALLING,
> +				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>   				  "USB Over-current", info);
>   		if (ret != 0) {
>   			printk(KERN_ERR "failed to request usb oc irq\n");
> diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
> index a6b338fd0470..08a889c141da 100644
> --- a/arch/arm/mach-s3c64xx/mach-smartq.c
> +++ b/arch/arm/mach-s3c64xx/mach-smartq.c
> @@ -106,7 +106,7 @@ static void smartq_usb_host_enableoc(struct s3c2410_hcd_info *info, int on)
>
>   	if (on) {
>   		ret = request_irq(gpio_to_irq(S3C64XX_GPL(10)),
> -				  smartq_usb_host_ocirq, IRQF_DISABLED |
> +				  smartq_usb_host_ocirq,
>   				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>   				  "USB host overcurrent", info);
>   		if (ret != 0)

Looks OK to me, applied.

Thanks,
Kukjin
