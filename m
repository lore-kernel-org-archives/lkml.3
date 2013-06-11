Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3FKLmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:42:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:37317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3FKLmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:42:10 -0400
Message-ID: <1370950926.8356.14.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix bogus RCU warning from
 ieee80211_get_tx_rates (Was: Re: rcu)
From: Johannes Berg <johannes@sipsolutions.net>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2013 13:42:06 +0200
In-Reply-To: <20130610042959.GA1902@gmail.com> (sfid-20130610_063023_078105_2ADDB0AE)
References: <20130609225120.GA2789@gmail.com>
	 <20130610042959.GA1902@gmail.com> (sfid-20130610_063023_078105_2ADDB0AE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 23:29 -0500, Calvin Owens wrote:
> rate_control_fill_sta_table(), whose sole caller is ieee80211_get_tx_rates(),
> is guaranteed by mac80211 not to be called concurrently with
> rate_control_set_rates() [1], the sole function that touches the rate table
> pointer/data in struct ieee80211_sta. The RCU dereference is therefore safe.

No, this is wrong. ieee80211_get_tx_rates() can be called by drivers in
any context and at any time, that was the whole point of using RCU here.

This needs to be fixed in ath9k, calling ieee80211_get_tx_rates() must
be done under RCU protection.

johannes

