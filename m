Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3AVL6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:58:21 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48114 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3AVL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:58:18 -0500
Message-ID: <50FE7ED6.8070505@kernel.org>
Date: Tue, 22 Jan 2013 11:58:14 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio: Use correct argument for sizeof
References: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 09:14 PM, Peter Huewe wrote:
> found with coccicheck
> sizeof when applied to a pointer typed expression gives the size of
> the pointer
> 
> The semantic patch that makes this output is available
> in scripts/coccinelle/misc/noderef.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Added to togreg branch of iio.git

Thanks,
> ---
>  drivers/staging/iio/iio_hwmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
> index c7a5f97..97ad645 100644
> --- a/drivers/staging/iio/iio_hwmon.c
> +++ b/drivers/staging/iio/iio_hwmon.c
> @@ -93,7 +93,7 @@ static int iio_hwmon_probe(struct platform_device *pdev)
>  	while (st->channels[st->num_channels].indio_dev)
>  		st->num_channels++;
>  
> -	st->attrs = kzalloc(sizeof(st->attrs) * (st->num_channels + 1),
> +	st->attrs = kzalloc(sizeof(*st->attrs) * (st->num_channels + 1),
>  			    GFP_KERNEL);
>  	if (st->attrs == NULL) {
>  		ret = -ENOMEM;
> 
