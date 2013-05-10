Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3EJLB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:01:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42675 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3EJLB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:01:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC 03/42] drivers/cpufreq: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 13:09:53 +0200
Message-ID: <1832747.3cSvLxeIN8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1368173847-5661-4-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 10:16:48 AM Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Queued up for a post-3.10-rc1 push.

Thanks,
Rafael


> ---
>  drivers/cpufreq/kirkwood-cpufreq.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index d36ea8d..b2644af 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -171,10 +171,6 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  	priv.dev = &pdev->dev;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Cannot get memory resource\n");
> -		return -ENODEV;
> -	}
>  	priv.base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv.base))
>  		return PTR_ERR(priv.base);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
