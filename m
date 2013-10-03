Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3JCQL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:11:29 -0400
Received: from smtp-out-192.synserver.de ([212.40.185.192]:1035 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754992Ab3JCQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:11:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10417
Message-ID: <524D9798.70902@metafoo.de>
Date: Thu, 03 Oct 2013 18:13:12 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio: fix wrong usage of dev_set_name()
References: <1380812241-11589-1-git-send-email-sangjung.woo@samsung.com>
In-Reply-To: <1380812241-11589-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 04:57 PM, Sangjung Woo wrote:
> The second parameter of dev_set_name() is format string. In order to
> avoid any potential accidents such as segmentation fault, basic format
> parameter "%s" should be used in this case.

Since "iio_evgen" is a constant string there is really no need for this.

> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  drivers/staging/iio/iio_dummy_evgen.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/iio_dummy_evgen.c
> index 132d278..2c06d16 100644
> --- a/drivers/staging/iio/iio_dummy_evgen.c
> +++ b/drivers/staging/iio/iio_dummy_evgen.c
> @@ -205,7 +205,7 @@ static __init int iio_dummy_evgen_init(void)
>  	if (ret < 0)
>  		return ret;
>  	device_initialize(&iio_evgen_dev);
> -	dev_set_name(&iio_evgen_dev, "iio_evgen");
> +	dev_set_name(&iio_evgen_dev, "%s", "iio_evgen");
>  	return device_add(&iio_evgen_dev);
>  }
>  module_init(iio_dummy_evgen_init);
> 

