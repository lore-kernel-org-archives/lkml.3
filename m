Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKFOVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:21:37 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39757 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKFOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:21:35 -0500
Message-ID: <545B83EC.7000304@roeck-us.net>
Date: Thu, 06 Nov 2014 06:21:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Thalmeier <michael.thalmeier@hale.at>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (lm75) Add support for the NXP LM75B
References: <1415282376-3055-1-git-send-email-michael.thalmeier@hale.at>
In-Reply-To: <1415282376-3055-1-git-send-email-michael.thalmeier@hale.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.545B83EF.0010,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On 11/06/2014 05:59 AM, Michael Thalmeier wrote:
> It is basically a faster lm75 with improved (11 bit) resolution.
>
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>   Documentation/hwmon/lm75 | 6 ++++++
>   drivers/hwmon/lm75.c     | 6 ++++++
>   2 files changed, 12 insertions(+)
>
> diff --git a/Documentation/hwmon/lm75 b/Documentation/hwmon/lm75
> index c6a5ff1..62e216a 100644
> --- a/Documentation/hwmon/lm75
> +++ b/Documentation/hwmon/lm75
> @@ -53,6 +53,12 @@ Supported chips:
>                  http://www.ti.com/product/tmp75
>                  http://www.ti.com/product/tmp175
>                  http://www.ti.com/product/tmp275
> +  * NXP LM75B
> +    Prefix: 'lm75b'
> +    Addresses scanned: none
> +    Datasheet: Publicly available at the NXP website
> +               http://www.nxp.com/documents/data_sheet/LM75B.pdf
> +
>
No additional newline, please.

>   Author: Frodo Looijaard <frodol@dds.nl>
>
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index d16dbb33a..7ec5ccd 100644
> --- a/drivers/hwmon/lm75.c
> +++ b/drivers/hwmon/lm75.c
> @@ -44,6 +44,7 @@ enum lm75_type {		/* keep sorted in alphabetical order */
>   	g751,
>   	lm75,
>   	lm75a,
> +	lm75b,
>   	max6625,
>   	max6626,
>   	mcp980x,
> @@ -271,6 +272,10 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
>   		data->resolution = 12;
>   		data->sample_time = HZ / 2;
>   		break;
> +	case lm75b:
> +		data->resolution = 11;
> +		data->sample_time = HZ / 4;
> +		break;

Alphabetic order, please.

>   	}
>
>   	/* configure as specified */
> @@ -334,6 +339,7 @@ static const struct i2c_device_id lm75_ids[] = {
>   	{ "tmp175", tmp175, },
>   	{ "tmp275", tmp275, },
>   	{ "tmp75", tmp75, },
> +	{ "lm75b", lm75b, },

Alphabetic order, please.

Thanks,
Guenter

>   	{ /* LIST END */ }
>   };
>   MODULE_DEVICE_TABLE(i2c, lm75_ids);
>

