Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3EJQJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:09:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:50029 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab3EJQJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:09:07 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+v9WxwtOyv7XEBDXV8Vw86BwynfRr8jAvW/84PfF
	XxbHzc/KBMWhzV
From: Marc Dietrich <marvin24@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>, linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [RFC 25/42] drivers/staging/nvec: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 18:07:55 +0200
Message-ID: <1443414.E0YPMv5nyg@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-27-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1368173847-5661-26-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-26-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 May 2013 10:17:10 Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Marc Dietrich <marvin24@gmx.de>

> ---
>  drivers/staging/nvec/nvec.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index a88959f..863b22e 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -800,11 +800,6 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) }
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "no mem resource?\n");
> -		return -ENODEV;
> -	}
> -
>  	base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);
