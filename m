Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaDYGw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:52:26 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57156 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDYGwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:52:24 -0400
Date: Thu, 24 Apr 2014 23:52:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH] bma150: extend chip detection for bma180
Message-ID: <20140425065220.GF10433@core.coreip.homeip.net>
References: <D682743C-E578-420D-A9DD-8B90673F8393@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D682743C-E578-420D-A9DD-8B90673F8393@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 11:30:02AM +0200, Dr. H. Nikolaus Schaller wrote:
> This driver has been used  while on the OpenPhoenux GTA04 with
> a BMA180.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Applied, thank you.

> ---
>  drivers/input/misc/bma150.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
> index 52d3a9b..b36831c 100644
> --- a/drivers/input/misc/bma150.c
> +++ b/drivers/input/misc/bma150.c
> @@ -70,6 +70,7 @@
>  #define BMA150_CFG_5_REG	0x11
>  
>  #define BMA150_CHIP_ID		2
> +#define BMA180_CHIP_ID		3
>  #define BMA150_CHIP_ID_REG	BMA150_DATA_0_REG
>  
>  #define BMA150_ACC_X_LSB_REG	BMA150_DATA_2_REG
> @@ -539,7 +540,7 @@ static int bma150_probe(struct i2c_client *client,
>  	}
>  
>  	chip_id = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
> -	if (chip_id != BMA150_CHIP_ID) {
> +	if (chip_id != BMA150_CHIP_ID && chip_id != BMA180_CHIP_ID) {
>  		dev_err(&client->dev, "BMA150 chip id error: %d\n", chip_id);
>  		return -EINVAL;
>  	}
> @@ -643,6 +644,7 @@ static UNIVERSAL_DEV_PM_OPS(bma150_pm, bma150_suspend, bma150_resume, NULL);
>  
>  static const struct i2c_device_id bma150_id[] = {
>  	{ "bma150", 0 },
> +	{ "bma180", 0 },
>  	{ "smb380", 0 },
>  	{ "bma023", 0 },
>  	{ }
> -- 
> 1.9.1
> 
> 

-- 
Dmitry
