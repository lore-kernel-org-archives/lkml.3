Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaB0OxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:53:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:34927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0OxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:53:18 -0500
Message-ID: <1393512787.4648.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 2/4] mac80211: set NET_NAME_USER for user-space created
 ifs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Tom Gundersen <teg@jklm.no>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 15:53:07 +0100
In-Reply-To: <1393512434-1325-3-git-send-email-dh.herrmann@gmail.com> (sfid-20140227_154844_921310_B406E62F)
References: <1393512434-1325-1-git-send-email-dh.herrmann@gmail.com>
	 <1393512434-1325-3-git-send-email-dh.herrmann@gmail.com>
	 (sfid-20140227_154844_921310_B406E62F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given the premise of your patches,

> +++ b/net/mac80211/iface.c
> @@ -1620,6 +1620,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  					+ IEEE80211_ENCRYPT_HEADROOM;
>  		ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
>  
> +		ndev->name_assign_type = NET_NAME_USER;

this is wrong because we call this in main.c with a "wlan%d" argument
for the name, which gets expanded.

johannes

