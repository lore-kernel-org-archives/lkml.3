Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3EJQht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:37:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33972 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3EJQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:37:47 -0400
Message-ID: <518D2258.2090403@wwwdotorg.org>
Date: Fri, 10 May 2013 10:37:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Barry Song <baohua.song@csr.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC 23/42] drivers/spi: don't check resource with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 02:17 AM, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c

> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!r) {
> -		dev_err(&pdev->dev, "No IO memory resource\n");
> -		ret = -ENODEV;
> -		goto exit_free_master;
> -	}
>  	tspi->phys = r->start;
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);

The tspi->phy assignment is broken there now.

> diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c

> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!r) {
> -		dev_err(&pdev->dev, "No IO memory resource\n");
> -		ret = -ENODEV;
> -		goto exit_free_master;
> -	}
>  	tspi->phys = r->start;
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);

Same here.

