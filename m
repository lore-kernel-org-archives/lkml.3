Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaC0Qwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:52:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59092 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaC0Qwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:52:51 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-c8-5334575b5c6d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] charger-manager: Fix checking of wrong return type
Date: Thu, 27 Mar 2014 17:52:18 +0100
Message-id: <1764333.udFThjx8n5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1395921415-17506-1-git-send-email-cw00.choi@samsung.com>
References: <1395921415-17506-1-git-send-email-cw00.choi@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd3ocJNgg8d/DSyuf3nOajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGW87vvKXDCVp2LCgVVMDYx/OLsYOTkkBEwkrk3dwQhhi0lcuLeerYuRi0NIYDqjxNKm
	A4wQTguTxLSOdWwgVWwCVhIT21eBdYgIaEjM/HsFrIhZoIlR4mD/fLCEsICfxKW7bewgNouA
	qsTLOQ1MIDavgKbEwvu7mUFsUQFPiR3bV4IN5RRwk/iybC2QzQG0zVXiyGktiHJBiR+T77GA
	2MwC8hL79k9lhbB1JPa3TmObwCgwC0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRHNDPpHcwrmqwOMQowMGoxMM7w8okWIg1say4MvcQowQHs5IIr7A3UIg3JbGyKrUo
	P76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjjMua7/j0Y8M/6cWu4XnX
	nrNFwFlOwy6yzW8v5/Vdl5W2Ma4odE+0Vsxcb7BouYbEsZykrTFavKHvhMweWH5YYPZpav9F
	HYaY+uO5PLLfFH4o3f0yuT/96SbepS/u7Q62MvE+rXdh0ufagNQ1fHw+F9kTErwv8kzbda1G
	8oO9wutyUxGLWaxKLMUZiYZazEXFiQBn84rSZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 27, 2014 08:56:55 PM Chanwoo Choi wrote:
> This patch fix minor issue about checking wrong return type.
> 
> The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
> in this function. But, charger_manager_probe() has only checked whether
> desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
> isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
> DT, charger_manager_probe() can't detect error of desc instance.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/power/charger-manager.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index 9e4dab4..a10fb57 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	if (!desc) {
> +	if (IS_ERR(desc)) {
>  		dev_err(&pdev->dev, "No platform data (desc) found\n");
>  		return -ENODEV;

While you are at it you may also fix the code to return the proper error
code.  of_cm_parse_desc() currently returns -ENOMEM not -ENODEV but it
would be even better to decode the actual return code from desc by using
'return PTR_ERR(desc)' instead of 'return -ENODEV'.

>  	}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

