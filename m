Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab3GWVQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:16:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36370 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3GWVQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:16:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <wsa@the-dreams.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 03/27] drivers/cpuidle: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 23:26:55 +0200
Message-ID: <6230864.6pouOSuFTj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374602524-3398-4-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 08:01:36 PM Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Daniel, I'm leaving this one to you.

Thanks,
Rafael


> ---
> Please apply via the subsystem-tree.
> 
>  drivers/cpuidle/cpuidle-kirkwood.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 521b0a7..2237135 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -60,9 +60,6 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
>  	struct resource *res;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL)
> -		return -EINVAL;
> -
>  	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(ddr_operation_base))
>  		return PTR_ERR(ddr_operation_base);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
