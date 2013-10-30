Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3J3LzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:55:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3J3LzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:55:06 -0400
Date: Wed, 30 Oct 2013 12:55:04 +0100
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
Subject: Re: [PATCH 13/16] wl1251: enforce changed hw encryption support on
 monitor state change
Message-ID: <20131030115504.GG8763@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-14-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382819655-30430-14-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-10-26 22:34:12, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> The firmware doesn't support per packet encryption selection, so disable hw
> encryption support completly while a monitor interface is present to support

"completely".

> injection of packets (which shouldn't get encrypted by hw).
> To enforce the changed hw encryption support force a disassociation on
> non-monitor interfaces.
> For disassociation a workaround using hw connection monitor is employed,
> which temporary enables hw connection manager flag.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

Missing sign-off.

> index 174f403..f054741 100644
> --- a/drivers/net/wireless/ti/wl1251/main.c
> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -685,6 +685,16 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
>  		wl->power_level = conf->power_level;
>  	}
>  
> +	/*
> +	 * Tell stack that connection is lost because hw encryption isn't
> +	 * supported in monitor mode.
> +	 * XXX This requires temporary enabling the hw connection monitor flag
> +	 */

"of the" and I guess you can remove the XXX? This way it looks like
workaround is not complete.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
