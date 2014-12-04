Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbaLDVYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:24:13 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51041 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaLDVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:24:12 -0500
Date: Thu, 4 Dec 2014 13:24:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v3 1/3] hwmon: tmp401: add support for TI TMP435
Message-ID: <20141204212408.GA10390@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5480D0FB.02E1,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 05:45:51PM +0100, Bartosz Golaszewski wrote:
> From: Patrick Titiano <ptitiano@baylibre.com>
> 
> Signed-off-by: Patrick Titiano <ptitiano@baylibre.com>
> [Bartosz Golaszewski: prepared for submission, code review fixes]
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/hwmon/tmp401.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
> index 7fa6e7d..ccd9938 100644
> --- a/drivers/hwmon/tmp401.c
> +++ b/drivers/hwmon/tmp401.c
> @@ -46,7 +46,7 @@
>  /* Addresses to scan */
>  static const unsigned short normal_i2c[] = { 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
>  
> -enum chips { tmp401, tmp411, tmp431, tmp432 };
> +enum chips { tmp401, tmp411, tmp431, tmp432, tmp435 };
>  
>  /*
>   * The TMP401 registers, note some registers have different addresses for
> @@ -136,6 +136,7 @@ static const u8 TMP432_STATUS_REG[] = {
>  #define TMP411C_DEVICE_ID			0x10
>  #define TMP431_DEVICE_ID			0x31
>  #define TMP432_DEVICE_ID			0x32
> +#define TMP435_DEVICE_ID			0x35
>  
>  /*
>   * Driver data (common to all clients)
> @@ -146,6 +147,7 @@ static const struct i2c_device_id tmp401_id[] = {
>  	{ "tmp411", tmp411 },
>  	{ "tmp431", tmp431 },
>  	{ "tmp432", tmp432 },
> +	{ "tmp435", tmp435 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, tmp401_id);
> @@ -684,6 +686,11 @@ static int tmp401_detect(struct i2c_client *client,
>  			return -ENODEV;
>  		kind = tmp432;
>  		break;
> +	case TMP435_DEVICE_ID:
> +		if (client->addr != 0x4c)
> +			return -ENODEV;

On second thought, is this really correct ?

I had another look into the datasheet. It seems to me that the chip
may support up to 9 different addresses, though that is a bit vague
since the datasheet first claims that the address would be 0x4c,
only to go on and list the 9 addresses (0x48 to 0x4f as well as 0x37)
in the next paragraph.

Thanks,
Guenter
