Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3J3Lbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:31:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3J3Lba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:31:30 -0400
Date: Wed, 30 Oct 2013 12:31:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 06/16] wl1251: split RX and TX data path initialisation
Message-ID: <20131030113129.GC8204@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-7-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382819655-30430-7-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Split up data path initialisation into RX and TX data path initialisation
> functions. This change is required for channel switching in monitor mode.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> ---
>  drivers/net/wireless/ti/wl1251/cmd.c  |   37 ++++++++++++++++++++++++++-------
>  drivers/net/wireless/ti/wl1251/cmd.h  |    3 ++-
>  drivers/net/wireless/ti/wl1251/init.c |    9 ++++++--
>  3 files changed, 39 insertions(+), 10 deletions(-)
> 
> @@ -238,6 +235,32 @@ int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable)
>  	wl1251_debug(DEBUG_BOOT, "rx %s cmd channel %d",
>  		     enable ? "start" : "stop", channel);
>  
> +out:
> +	kfree(cmd);
> +	return ret;
> +}
> +
> +int wl1251_cmd_data_path_tx(struct wl1251 *wl, u8 channel, bool enable)
> +{
> +	struct cmd_enabledisable_path *cmd;
> +	int ret;
> +	u16 cmd_tx;
> +
> +	wl1251_debug(DEBUG_CMD, "cmd data path");
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

Again, doing jump just to kfree(NULL)... is probably not worth
it.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
