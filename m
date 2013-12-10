Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3LJJ3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:29:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3LJJ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:29:18 -0500
Date: Tue, 10 Dec 2013 10:29:16 +0100
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
Subject: Re: [PATCH v2 04/16] wl1251: implement hardware ARP filtering
Message-ID: <20131210092916.GD22756@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-5-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386494714-21070-5-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Update hardware ARP filter configuration on BSS_CHANGED_ARP_FILTER
> notification from mac80211.
> Ported from wl1271 driver.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/net/wireless/ti/wl1251/acx.c  |   26 ++++++++++++++++++++++++++
>  drivers/net/wireless/ti/wl1251/acx.h  |   15 +++++++++++++++
>  drivers/net/wireless/ti/wl1251/main.c |   12 ++++++++++++
>  3 files changed, 53 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
> index cce50e2..5f4a552 100644
> --- a/drivers/net/wireless/ti/wl1251/acx.c
> +++ b/drivers/net/wireless/ti/wl1251/acx.c
> @@ -1062,6 +1062,32 @@ out:
>  	return ret;
>  }
>  
> +int wl1251_acx_arp_ip_filter(struct wl1251 *wl, bool enable, __be32 address)
> +{
> +	struct wl1251_acx_arp_filter *acx;
> +	int ret;

Is it good idea to use be32 for IP address? AFAICT IPv4 addresses
really don't have edianity. Perhaps u32 is better?

> +	if (enable)
> +		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);

acx->address is an array of u8, so no endianity there, either.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
