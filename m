Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaBJMwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:52:54 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:47292 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaBJMwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:52:51 -0500
Message-ID: <52F8CB9A.4010004@mev.co.uk>
Date: Mon, 10 Feb 2014 12:52:42 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] Staging: comedi: fix memory leak in comedi_bond.c
References: <1391835747-3714-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1391835747-3714-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-08 05:02, Chase Southwood wrote:
> We allocate bdev and then krealloc the devs pointer in order to add bdev
> at the end of the devpriv->devs array list.  But if for some reason this
> krealloc fails, we need to free bdev before returning an error otherwise
> this memory is leaked.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   drivers/staging/comedi/drivers/comedi_bond.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
> index 51a59e5..406aedb 100644
> --- a/drivers/staging/comedi/drivers/comedi_bond.c
> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
> @@ -254,6 +254,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
>   			if (!devs) {
>   				dev_err(dev->class_dev,
>   					"Could not allocate memory. Out of memory?\n");
> +				kfree(bdev);
>   				return -ENOMEM;
>   			}
>   			devpriv->devs = devs;
>

Acked-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
