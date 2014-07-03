Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaGCH3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:29:51 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57247 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaGCH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:29:50 -0400
Date: Thu, 3 Jul 2014 08:29:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] mfd: cros_ec: cleanup: remove unused fields
 from struct cros_ec_device
Message-ID: <20140703072943.GD30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-7-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-7-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> struct cros_ec_device has a superfluous "name" field. We can get all the
> debugging info we need from the existing ec_name and phys_name fields, so
> let's take out the extra field.
> 
> The printout also has sufficient info in it without explicitly adding
> the transport.  Before this change:
>   cros-ec-spi spi2.0: Chrome EC (SPI)
> 
> After this change:
>   cros-ec-spi spi2.0: Chrome EC device registered
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> ---
> Changes in v2:
> - Include example printouts before/after in commit message.

Patch applied.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

>  drivers/mfd/cros_ec.c       | 2 +-
>  drivers/mfd/cros_ec_i2c.c   | 1 -
>  drivers/mfd/cros_ec_spi.c   | 1 -
>  include/linux/mfd/cros_ec.h | 2 --
>  4 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 2e86c28..49ed8c3 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -140,7 +140,7 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
>  		goto fail_mfd;
>  	}
>  
> -	dev_info(dev, "Chrome EC (%s)\n", ec_dev->name);
> +	dev_info(dev, "Chrome EC device registered\n");
>  
>  	return 0;
>  
> diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
> index 37ed12f..5bb32f5 100644
> --- a/drivers/mfd/cros_ec_i2c.c
> +++ b/drivers/mfd/cros_ec_i2c.c
> @@ -132,7 +132,6 @@ static int cros_ec_i2c_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	i2c_set_clientdata(client, ec_dev);
> -	ec_dev->name = "I2C";
>  	ec_dev->dev = dev;
>  	ec_dev->priv = client;
>  	ec_dev->irq = client->irq;
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 2d713fe..09ca789 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -374,7 +374,6 @@ static int cros_ec_spi_probe(struct spi_device *spi)
>  	cros_ec_spi_dt_probe(ec_spi, dev);
>  
>  	spi_set_drvdata(spi, ec_dev);
> -	ec_dev->name = "SPI";
>  	ec_dev->dev = dev;
>  	ec_dev->priv = ec_spi;
>  	ec_dev->irq = spi->irq;
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index f27c037..2b0c598 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -67,7 +67,6 @@ struct cros_ec_command {
>   * @command_recv: receive a response
>   * @command_sendrecv: send a command and receive a response
>   *
> - * @name: Name of this EC interface
>   * @priv: Private data
>   * @irq: Interrupt to use
>   * @din: input buffer (for data from EC)
> @@ -104,7 +103,6 @@ struct cros_ec_device {
>  				void *in_buf, int in_len);
>  
>  	/* These are used to implement the platform-specific interface */
> -	const char *name;
>  	void *priv;
>  	int irq;
>  	uint8_t *din;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
