Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3ETQi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:38:29 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:63270 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3ETQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:38:27 -0400
Message-ID: <519A517F.5020003@samsung.com>
Date: Tue, 21 May 2013 01:38:23 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 30/33] arch/arm/plat-samsung: don't check resource with
 devm_ioremap_resource
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de> <1368702961-4325-31-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368702961-4325-31-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/13 20:15, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang<wsa@the-dreams.de>

Looks good to me, applied into Samsung tree.

Wolfram, if you want to take this into your tree, let me know.

Thanks.

- Kukjin

> ---
>   arch/arm/plat-samsung/adc.c |    5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
> index ca07cb1..79690f2 100644
> --- a/arch/arm/plat-samsung/adc.c
> +++ b/arch/arm/plat-samsung/adc.c
> @@ -381,11 +381,6 @@ static int s3c_adc_probe(struct platform_device *pdev)
>   	}
>
>   	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!regs) {
> -		dev_err(dev, "failed to find registers\n");
> -		return -ENXIO;
> -	}
> -
>   	adc->regs = devm_ioremap_resource(dev, regs);
>   	if (IS_ERR(adc->regs))
>   		return PTR_ERR(adc->regs);

