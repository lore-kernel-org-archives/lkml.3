Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbaJ2Pll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:41:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbaJ2Plk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:40 -0400
Date: Wed, 29 Oct 2014 16:07:55 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: drivers: comedi_bond.c: Changed from
 using strncat to strlcat
Message-ID: <20141029080755.GA6009@kroah.com>
References: <1413642908-3633-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413642908-3633-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 04:35:08PM +0200, Rickard Strandqvist wrote:
> Changed from using strncat to strlcat to simplify the code
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>  drivers/staging/comedi/drivers/comedi_bond.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
> index 8450c99..85b2f4a 100644
> --- a/drivers/staging/comedi/drivers/comedi_bond.c
> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
> @@ -61,8 +61,7 @@ struct bonded_device {
>  };
>  
>  struct comedi_bond_private {
> -# define MAX_BOARD_NAME 256
> -	char name[MAX_BOARD_NAME];
> +	char name[256];
>  	struct bonded_device **devs;
>  	unsigned ndevs;
>  	unsigned nchans;
> @@ -262,12 +261,10 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
>  			{
>  				/* Append dev:subdev to devpriv->name */
>  				char buf[20];
> -				int left =
> -				    MAX_BOARD_NAME - strlen(devpriv->name) - 1;
>  				snprintf(buf, sizeof(buf), "%u:%u ",
>  					 bdev->minor, bdev->subdev);
> -				buf[sizeof(buf) - 1] = 0;
> -				strncat(devpriv->name, buf, left);
> +				strlcat(devpriv->name, buf,
> +					sizeof(devpriv->name));
>  			}
>  
>  		}

Oops, I applied the first version of this, can you send me an updated
version with just the new changes here?

thanks,

greg k-h
