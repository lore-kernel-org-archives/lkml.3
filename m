Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaE1WG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:06:28 -0400
Received: from smtp310.phy.lolipop.jp ([210.157.22.78]:34557 "EHLO
	smtp310.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaE1WG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:06:26 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 18:06:25 EDT
Message-ID: <53865BE3.3010602@sakamocchi.jp>
Date: Thu, 29 May 2014 06:57:55 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Clemens Ladisch <clemens@ladisch.de>
CC: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [patch 2/2] ALSA: fireworks: small leak on error
 path
References: <20140528164246.GC1824@mwanda>
In-Reply-To: <20140528164246.GC1824@mwanda>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(May 29 2014 01:42), Dan Carpenter wrote:
> There was a typo here so we return directly instead of freeing "hwinfo".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewd-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Tested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

> diff --git a/sound/firewire/fireworks/fireworks.c b/sound/firewire/fireworks/fireworks.c
> index 8e856cc..996fdc4 100644
> --- a/sound/firewire/fireworks/fireworks.c
> +++ b/sound/firewire/fireworks/fireworks.c
> @@ -157,7 +157,7 @@ get_hardware_info(struct snd_efw *efw)
>  	/* Hardware metering. */
>  	if (hwinfo->phys_in_grp_count  > HWINFO_MAX_CAPS_GROUPS ||
>  	    hwinfo->phys_out_grp_count > HWINFO_MAX_CAPS_GROUPS) {
> -		return -EIO;
> +		err = -EIO;
>  		goto end;
>  	}
>  	efw->phys_in = hwinfo->phys_in;

