Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaIWGqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:46:39 -0400
Received: from svenfoo.org ([82.94.215.22]:44406 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaIWGqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:46:37 -0400
Message-ID: <5421174A.7060101@zonque.org>
Date: Tue, 23 Sep 2014 08:46:34 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>, galak@codeaurora.org,
        dmitry.torokhov@gmail.com, zonque@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
CC: devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cap1106: Add support for various cap11xx devices
References: <1411445057-30048-1-git-send-email-mranostay@gmail.com> <1411445057-30048-2-git-send-email-mranostay@gmail.com>
In-Reply-To: <1411445057-30048-2-git-send-email-mranostay@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 06:04 AM, Matt Ranostay wrote:
> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
> index d70b65a..07f9e88 100644
> --- a/drivers/input/keyboard/cap1106.c
> +++ b/drivers/input/keyboard/cap1106.c
> @@ -55,8 +55,6 @@
>  #define CAP1106_REG_MANUFACTURER_ID	0xfe
>  #define CAP1106_REG_REVISION		0xff
>  
> -#define CAP1106_NUM_CHN 6
> -#define CAP1106_PRODUCT_ID	0x55
>  #define CAP1106_MANUFACTURER_ID	0x5d
>  
>  struct cap1106_priv {
> @@ -64,7 +62,25 @@ struct cap1106_priv {
>  	struct input_dev *idev;
>  
>  	/* config */
> -	unsigned short keycodes[CAP1106_NUM_CHN];
> +	u32 *keycodes;
> +	unsigned int num_channels;
> +};
> +
> +struct cap11xx_hw_model {
> +	uint8_t product_id;
> +	unsigned int num_channels;
> +};
> +
> +enum {
> +	CAP1106,
> +	CAP1126,
> +	CAP1188,
> +};
> +
> +struct cap11xx_hw_model cap11xx_devices[] = {

This can be static const.

And, as I said, there should be a 3rd patch that renames the file and
its functions, structs, defines etc to the more generic "11xx" variants.


Thanks,
Daniel

