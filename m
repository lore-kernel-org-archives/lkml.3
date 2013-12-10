Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3LJJf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:35:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44638 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3LJJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:35:20 -0500
Date: Tue, 10 Dec 2013 10:35:18 +0100
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
Subject: Re: [PATCH v2 06/16] wl1251: configure hardware en-/decryption for
 monitor mode
Message-ID: <20131210093518.GF22756@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-7-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386494714-21070-7-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> --- a/drivers/net/wireless/ti/wl1251/tx.c
> +++ b/drivers/net/wireless/ti/wl1251/tx.c
> @@ -287,6 +287,9 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
>  	info = IEEE80211_SKB_CB(skb);
>  
>  	if (info->control.hw_key) {
> +		if (unlikely(wl->monitor_present))
> +			return -1;
> +


This function seems to use 0/-errno convention. So probably "return
-EINVAL"?

With that fixed:

Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
