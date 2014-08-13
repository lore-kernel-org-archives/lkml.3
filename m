Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHMLNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:13:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbaHMLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:13:39 -0400
Date: Wed, 13 Aug 2014 12:13:38 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] mfd: wm8994: declare dc servo register for wm8958 as
	volatile
Message-ID: <20140813111338.GG15833@opensource.wolfsonmicro.com>
References: <1407926786-8528-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407926786-8528-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:46:25AM +0100, Nikesh Oswal wrote:
> DC Servo register 57h holds the DC offset value after the hardware has
> completed the DC Servo Correction, so declare this register as volatile
> because it is changed by the hardware.
> 
> Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-regmap.c          |    1 +
>  include/linux/mfd/wm8994/registers.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
> index 2fbce9c..e775565 100644
> --- a/drivers/mfd/wm8994-regmap.c
> +++ b/drivers/mfd/wm8994-regmap.c
> @@ -1169,6 +1169,7 @@ static bool wm8958_volatile_register(struct device *dev, unsigned int reg)
>  	case WM8958_FW_MINOR_0:
>  	case WM8958_FW_PATCH_1:
>  	case WM8958_FW_PATCH_0:
> +	case WM8958_DC_SERVO:

I think you can just use the WM8994_DC_SERVO_4 define the
register is called DC Servo (4) in the datasheet.

Also would it be worth adding DC_SERVO_1 and DC_SERVO_READBACK as
they are being treated as volatile on 8994 and look identical in
the datasheet.

>  		return true;
>  	default:
>  		return wm8994_volatile_register(dev, reg);
> diff --git a/include/linux/mfd/wm8994/registers.h b/include/linux/mfd/wm8994/registers.h
> index db8cef3..85b4fec 100644
> --- a/include/linux/mfd/wm8994/registers.h
> +++ b/include/linux/mfd/wm8994/registers.h
> @@ -71,6 +71,7 @@
>  #define WM8994_DC_SERVO_1                       0x54
>  #define WM8994_DC_SERVO_2                       0x55
>  #define WM8994_DC_SERVO_4                       0x57
> +#define WM8958_DC_SERVO			0x57
>  #define WM8994_DC_SERVO_READBACK                0x58
>  #define WM8994_DC_SERVO_4E			0x59
>  #define WM8994_ANALOGUE_HP_1                    0x60
> -- 
> 1.7.9.5

Thanks,
Charles
