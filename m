Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3LJJZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:25:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43787 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LJJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:21:16 -0500
Date: Tue, 10 Dec 2013 10:21:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not
 associated
Message-ID: <20131210092114.GB22756@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386494714-21070-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
> index 6822b84..16b6479 100644
> --- a/drivers/net/wireless/ti/wl1251/cmd.c
> +++ b/drivers/net/wireless/ti/wl1251/cmd.c
> @@ -410,7 +411,10 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
>  	struct wl1251_cmd_scan *cmd;
>  	int i, ret = 0;
>  
> -	wl1251_debug(DEBUG_CMD, "cmd scan");
> +	wl1251_debug(DEBUG_CMD, "cmd scan channels %d ssid(%d) '%s'",
> +		     n_channels, (int)ssid_len, ssid);
> +
> +	WARN_ON(n_channels > SCAN_MAX_NUM_OF_CHANNELS);
>  

ssids can have \0s in them... and what is worse, they may not be 0
terminated AFAICT.

Potential solution is at
http://www.spinics.net/lists/linux-wireless/msg98640.html . 

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
