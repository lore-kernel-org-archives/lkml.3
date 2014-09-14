Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaINRbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:31:32 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55695 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaINRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:31:30 -0400
Message-ID: <5415D0F0.9080001@kernel.org>
Date: Sun, 14 Sep 2014 18:31:28 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH v2] iio: magn: ak8975: fix unnecessary casting between
 char* and const char*
References: <1410185888-18622-1-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1410185888-18622-1-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 15:18, Irina Tirdea wrote:
> Use const char* instead of casting const char* to char*.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Applied to the togreg branch of iio.git - initially pushed out as testing.

Thanks,

Jonathan
> ---
> 
> Changes in v2:
>  - fixed identation as Hartmut Knaack suggested
> 
>  drivers/iio/magnetometer/ak8975.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
> index a235792..bf5ef07 100644
> --- a/drivers/iio/magnetometer/ak8975.c
> +++ b/drivers/iio/magnetometer/ak8975.c
> @@ -477,8 +477,8 @@ static const struct acpi_device_id ak_acpi_match[] = {
>  };
>  MODULE_DEVICE_TABLE(acpi, ak_acpi_match);
>  
> -static char *ak8975_match_acpi_device(struct device *dev,
> -				enum asahi_compass_chipset *chipset)
> +static const char *ak8975_match_acpi_device(struct device *dev,
> +					    enum asahi_compass_chipset *chipset)
>  {
>  	const struct acpi_device_id *id;
>  
> @@ -487,7 +487,7 @@ static char *ak8975_match_acpi_device(struct device *dev,
>  		return NULL;
>  	*chipset = (int)id->driver_data;
>  
> -	return (char *)dev_name(dev);
> +	return dev_name(dev);
>  }
>  
>  static int ak8975_probe(struct i2c_client *client,
> @@ -497,7 +497,7 @@ static int ak8975_probe(struct i2c_client *client,
>  	struct iio_dev *indio_dev;
>  	int eoc_gpio;
>  	int err;
> -	char *name = NULL;
> +	const char *name = NULL;
>  
>  	/* Grab and set up the supplied GPIO. */
>  	if (client->dev.platform_data)
> @@ -539,7 +539,7 @@ static int ak8975_probe(struct i2c_client *client,
>  	if (id) {
>  		data->chipset =
>  			(enum asahi_compass_chipset)(id->driver_data);
> -		name = (char *) id->name;
> +		name = id->name;
>  	} else if (ACPI_HANDLE(&client->dev))
>  		name = ak8975_match_acpi_device(&client->dev, &data->chipset);
>  	else
> 
