Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EMIZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:25:54 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:60908 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3EMIZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:25:52 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 04:25:52 EDT
Message-ID: <5190A140.3020306@ge.com>
Date: Mon, 13 May 2013 09:16:00 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: manohar.vanga@gmail.com, gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        yamanetoshi@gmail.com, gmate.amit@gmail.com, joe@perches.com,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vme: fix error return code in vme_user_probe()
References: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com>
In-Reply-To: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/13 07:05, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the resource alloc error handling
> case instead of 0, as done elsewhere in this function.
> 

Hi Wei,

Thanks for your patch. As this is resource allocation rather than memory
allocation that is failing, would -EAGAIN not make more sense than -ENOMEM?

Martyn

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/vme/devices/vme_user.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index da7f759..5fe224d3 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -734,6 +734,7 @@ static int vme_user_probe(struct vme_dev *vdev)
>  		if (image[i].resource == NULL) {
>  			dev_warn(&vdev->dev,
>  				 "Unable to allocate slave resource\n");
> +			err = -ENOMEM;
>  			goto err_slave;
>  		}
>  		image[i].size_buf = PCI_BUF_SIZE;
> @@ -760,6 +761,7 @@ static int vme_user_probe(struct vme_dev *vdev)
>  		if (image[i].resource == NULL) {
>  			dev_warn(&vdev->dev,
>  				 "Unable to allocate master resource\n");
> +			err = -ENOMEM;
>  			goto err_master;
>  		}
>  		image[i].size_buf = PCI_BUF_SIZE;
> 


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
