Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaHMLIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:08:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaHMLIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:08:46 -0400
Date: Wed, 13 Aug 2014 12:08:44 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] ASoC: wm_hubs: Fix DC Servo readback
Message-ID: <20140813110844.GF15833@opensource.wolfsonmicro.com>
References: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:47:20AM +0100, Nikesh Oswal wrote:
> wm_hubs is a common driver code shared by WM8958, WM1811, WM8944
> and WM8993 all these codecs have the DC Servo Values either in register
> 57h or 59h. Current code was reading register 58h for WM8958 and WM8994
> revisions 2 and 3 but looking at the data sheet the DC Servo Values are
> stored in register 57h for these codecs. This patch fixes it by reading
> the correct register for DC Servo
> 
> Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/wm_hubs.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
> index 916817f..95c5d71 100644
> --- a/sound/soc/codecs/wm_hubs.c
> +++ b/sound/soc/codecs/wm_hubs.c
> @@ -210,9 +210,6 @@ static int wm_hubs_read_dc_servo(struct snd_soc_codec *codec,
>  	case 2:
>  		dcs_reg = WM8994_DC_SERVO_4E;
>  		break;
> -	case 1:
> -		dcs_reg = WM8994_DC_SERVO_READBACK;
> -		break;
>  	default:
>  		dcs_reg = WM8993_DC_SERVO_3;
>  		break;
> -- 

This doesn't look right, firstly if it is the same register for
all versions then surely we should change the code that sets
dcs_readback_mode rather than setting that to different values
but treating them the same. Although obviously if nothing still
uses this case we could remove it as well.

Also I think the situation is more complex for example on version
4.4 of the datasheet for wm8994 the WR_VAL fields appear to be in
register 59h. Which is not consistent with this.

Thanks,
Charles
