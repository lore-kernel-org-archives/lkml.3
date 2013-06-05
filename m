Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3FELPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:15:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38036 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3FELPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:15:40 -0400
Date: Wed, 5 Jun 2013 14:15:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthias Schid <aircrach115@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        cruz@massive-dynamics.biz, jonbrett.dev@gmail.com,
        linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        sjakub@gmail.com, joe@perches.com, steffhip@googlemail.com,
        simon.puels@gmail.com
Subject: Re: [PATCH 2/2] staging/asus_oled fixed linebreak style issue
Message-ID: <20130605111512.GW28112@mwanda>
References: <1370429445-17185-1-git-send-email-aircrach115@gmail.com>
 <1370429445-17185-3-git-send-email-aircrach115@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370429445-17185-3-git-send-email-aircrach115@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:50:45PM +0200, Matthias Schid wrote:
> fixed a linebreak within an error message string coding style
> issue reported by checkpatch.pl
> 
> Signed-off-by: Matthias Schid <aircrach115@gmail.com>
> Signed-off-by: Stefan Huber <steffhip@googlemail.com>
> Signed-off-by: Simon Puels <simon.puels@gmail.com>
> ---
>  drivers/staging/asus_oled/asus_oled.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
> index 173fb9a..a7cd65a 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -383,8 +383,7 @@ static int append_values(struct asus_oled_dev *odev, uint8_t val, size_t count)
>  		}
>  
>  		if (i >= odev->buf_size) {
> -			dev_err(odev->dev, "Buffer overflow! Report a bug:"
> -			       "offs: %d >= %d i: %d (x: %d y: %d)\n",
> +			dev_err(odev->dev, "Buffer overflow! Report a bug: offs: %d >= %d i: %d (x: %d y: %d)\n",
>  			       (int) odev->buf_offs, (int) odev->buf_size,
>  			       (int) i, (int) x, (int) y);

This could be improved:

			dev_err(odev->dev,
				"Buffer overflow! Report a bug: offs: %zu >= %d i: %zu (x: %zu y: %zu)\n",
			     	odev->buf_offs, odev->buf_size, i, x, y);

Printk fromats are documented in Documentation/printk-formats.txt.

regards,
dan carpenter

