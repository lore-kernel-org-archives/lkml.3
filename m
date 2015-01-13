Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbbAMPVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:21:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55911 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbAMPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:21:00 -0500
Message-ID: <54B537DA.7030707@atmel.com>
Date: Tue, 13 Jan 2015 16:20:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Bo Shen <voice.shen@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        "Alexander Morozov" <linux@meltdown.ru>
Subject: Re: [PATCH v2 1/3] ASoC: codecs: wm8904: add dt ids table
References: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/12/2014 04:31, Bo Shen a écrit :
> From: Alexander Morozov <linux@meltdown.ru>
> 
> Signed-off-by: Alexander Morozov <linux@meltdown.ru>
> [Add driver data to distinguish device type]
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> 
> Changes in v2:
> - Add driver data for distinguish the device capability.
> 
>  sound/soc/codecs/wm8904.c | 22 ++++++++++++++++++++++

Mark,

Do you want us to re-send this patch or can you take it?

On my side, I'm planning to take the 2 last ones of this series: is it
okay for you?

Thanks, bye.

>  1 file changed, 22 insertions(+)
> 
> diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
> index 4d2d2b1..6e3f175 100644
> --- a/sound/soc/codecs/wm8904.c
> +++ b/sound/soc/codecs/wm8904.c
> @@ -2255,10 +2255,32 @@ static const struct i2c_device_id wm8904_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, wm8904_i2c_id);
>  
> +#ifdef CONFIG_OF
> +static enum wm8904_type wm8904_data = WM8904;
> +static enum wm8904_type wm8912_data = WM8912;
> +
> +static const struct of_device_id wm8904_of_match[] = {
> +	{
> +		.compatible = "wlf,wm8904",
> +		.data = &wm8904_data,
> +	}, {
> +		.compatible = "wlf,wm8912",
> +		.data = &wm8912_data,
> +	}, {
> +		.compatible = "wlf,wm8918",
> +		.data = &wm8904_data,
> +	}, {
> +		/* sentinel */
> +	}
> +};
> +MODULE_DEVICE_TABLE(of, wm8904_of_match);
> +#endif
> +
>  static struct i2c_driver wm8904_i2c_driver = {
>  	.driver = {
>  		.name = "wm8904",
>  		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(wm8904_of_match),
>  	},
>  	.probe =    wm8904_i2c_probe,
>  	.remove =   wm8904_i2c_remove,
> 


-- 
Nicolas Ferre
