Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaAGMeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:34:09 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:34145 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaAGMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:34:05 -0500
Subject: Re: [PATCH -next] misc: genwqe: fix return value check in
 genwqe_device_create()
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd9DJxmadJQb_0-J_2DZ1aVpOZ65J4iVCid-tJ=OLmKBNA@mail.gmail.com>
References: <CAPgLHd9DJxmadJQb_0-J_2DZ1aVpOZ65J4iVCid-tJ=OLmKBNA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 07 Jan 2014 13:33:53 +0100
Message-ID: <1389098033.15325.10.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010712-0542-0000-0000-000007956FC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 07.01.2014, 16:56 +0800 schrieb Wei Yongjun:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function device_create_with_groups()
> returns ERR_PTR() and never returns NULL. The NULL test in
> the return value check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/misc/genwqe/card_dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
> index 9b231bb..46fa2ca 100644
> --- a/drivers/misc/genwqe/card_dev.c
> +++ b/drivers/misc/genwqe/card_dev.c
> @@ -1378,8 +1378,8 @@ int genwqe_device_create(struct genwqe_dev *cd)
>  					    genwqe_attribute_groups,
>  					    GENWQE_DEVNAME "%u_card",
>  					    cd->card_idx);
> -	if (cd->dev == NULL) {
> -		rc = -ENODEV;
> +	if (IS_ERR(cd->dev)) {
> +		rc = PTR_ERR(cd->dev);
>  		goto err_cdev;
>  	}
> 
> 

Thanks for finding this potential problem and proposing a fix.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

