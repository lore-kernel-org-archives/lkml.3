Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957Ab3ARIYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:24:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44736 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3ARIX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:23:59 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ALSA: ASoC: McASP: Fix data rotation for
	playback. Enables 24bit audio playback
Thread-Topic: [alsa-devel] [PATCH] ALSA: ASoC: McASP: Fix data rotation for
	playback. Enables 24bit audio playback
Thread-Index: AQHN8+mxIASE72Az3Uq09EIP5eXiZJhOwdkw
Date: Fri, 18 Jan 2013 08:22:53 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB49910@DBDE01.ent.ti.com>
References: <1358260860-10370-1-git-send-email-michal.bachraty@streamunlimited.com>
In-Reply-To: <1358260860-10370-1-git-send-email-michal.bachraty@streamunlimited.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 20:11:00, Michal Bachraty wrote:
> Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>

Even simple patches need a simple changelog.
Add a brief description about what & why it is done?


> ---
>  sound/soc/davinci/davinci-mcasp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
> index 13f8d73..a03bece 100644
> --- a/sound/soc/davinci/davinci-mcasp.c
> +++ b/sound/soc/davinci/davinci-mcasp.c
> @@ -626,7 +626,7 @@ static int davinci_config_channel_size(struct davinci_audio_dev *dev,
>  				       int word_length)
>  {
>  	u32 fmt;
> -	u32 rotate = (32 - word_length) / 4;
> +	u32 rotate = (word_length / 4) & 0x7;
>  	u32 mask = (1ULL << word_length) - 1;
>  
>  	/*
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 


Regards, 
Gururaja
