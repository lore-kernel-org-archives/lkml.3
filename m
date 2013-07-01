Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3GAJ0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:26:38 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:49109 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3GAJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:26:37 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 05:26:37 EDT
Message-ID: <51D148FB.6070506@ge.com>
Date: Mon, 01 Jul 2013 10:16:43 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vme: vme_tsi148.c: fix error return code in tsi148_probe()
References: <CAPgLHd_sYVPQQkx7y4L=i_-GMjSmFGAbgY0bP7M1sr_02WtPvA@mail.gmail.com>
In-Reply-To: <CAPgLHd_sYVPQQkx7y4L=i_-GMjSmFGAbgY0bP7M1sr_02WtPvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/13 03:42, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code in the tsi148_crcsr_init() error
> handling case instead of 0, as done elsewhere in this function.
> 

Hi Wei,

Thanks for your patch looks good.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/vme/bridges/vme_tsi148.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
> index 9c1aa4d..95c9b54 100644
> --- a/drivers/vme/bridges/vme_tsi148.c
> +++ b/drivers/vme/bridges/vme_tsi148.c
> @@ -2582,7 +2582,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	dev_info(&pdev->dev, "VME Write and flush and error check is %s\n",
>  		err_chk ? "enabled" : "disabled");
>  
> -	if (tsi148_crcsr_init(tsi148_bridge, pdev)) {
> +	retval = tsi148_crcsr_init(tsi148_bridge, pdev);
> +	if (retval) {
>  		dev_err(&pdev->dev, "CR/CSR configuration failed.\n");
>  		goto err_crcsr;
>  	}
> 


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
