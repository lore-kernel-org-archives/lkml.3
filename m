Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaLMEqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:46:04 -0500
Received: from smtp302.phy.lolipop.jp ([210.157.22.85]:53090 "EHLO
	smtp302.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaLMEqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:46:03 -0500
Message-ID: <548BC483.4090703@sakamocchi.jp>
Date: Sat, 13 Dec 2014 13:45:55 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Clemens Ladisch <clemens@ladisch.de>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] ALSA: oxfw: fix detect_loud_models() return value
References: <20141212192810.GB22234@mwanda>
In-Reply-To: <20141212192810.GB22234@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13 2014 04:28, Dan Carpenter wrote:
> This code causes a static checker warning:
> 
> 	sound/firewire/oxfw/oxfw.c:46 detect_loud_models()
> 	warn: signedness bug returning '(-2)'
> 
> The detect_loud_models() function should return false on falure, so that
> we don't try to set up the loud code for hardware that doesn't support
> it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
> index cf1d0b5..60e5cad 100644
> --- a/sound/firewire/oxfw/oxfw.c
> +++ b/sound/firewire/oxfw/oxfw.c
> @@ -43,7 +43,7 @@ static bool detect_loud_models(struct fw_unit *unit)
>  	err = fw_csr_string(unit->directory, CSR_MODEL,
>  			    model, sizeof(model));
>  	if (err < 0)
> -		return err;
> +		return false;
>  
>  	for (i = 0; i < ARRAY_SIZE(models); i++) {
>  		if (strcmp(models[i], model) == 0)

Reviewd-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>


Thanks

Takashi Sakamoto
o-takashi@sakamocchi.jp
