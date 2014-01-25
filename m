Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaAYLWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 06:22:33 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50322 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaAYLWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 06:22:32 -0500
Date: Sat, 25 Jan 2014 15:22:24 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, grant.likely@linaro.org,
        robh+dt@kernel.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] isp1704_charger: remove useless check in
 isp1704_charger_probe()
Message-ID: <20140125112224.GB2435@anuminas.rup.mentorg.com>
References: <CAPgLHd_XJqAjhdv=J8d9TwdchS203_GqUTvRYM9SAS12roiYBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_XJqAjhdv=J8d9TwdchS203_GqUTvRYM9SAS12roiYBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 09:12:29PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Neither devm_usb_get_phy_by_phandle() nor devm_usb_get_phy() can
> return a NULL result, so remove the useless !isp->phy check.

Thank you, applying.

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/power/isp1704_charger.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
> index 80edb7d..0b4cf9d 100644
> --- a/drivers/power/isp1704_charger.c
> +++ b/drivers/power/isp1704_charger.c
> @@ -444,8 +444,6 @@ static int isp1704_charger_probe(struct platform_device *pdev)
>  		ret = PTR_ERR(isp->phy);
>  		goto fail0;
>  	}
> -	if (!isp->phy)
> -		goto fail0;
>  
>  	isp->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, isp);
