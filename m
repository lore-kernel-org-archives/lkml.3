Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaFVLmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:42:04 -0400
Received: from nbd.name ([46.4.11.11]:43174 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaFVLmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:42:02 -0400
Message-ID: <53A6C0FF.9090104@openwrt.org>
Date: Sun, 22 Jun 2014 13:41:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: Re: [PATCH 2/2] cfg80211: Use 5MHz bandwidth by default when checking
 usable channels
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz> <1397565476-4348-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
In-Reply-To: <1397565476-4348-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 14:37, Rostislav Lisovy wrote:
> Current code checks if the 20MHz bandwidth is allowed for
> particular channel -- if it is not, the channel is disabled.
> Since we need to use 5/10 MHz channels, this code is modified in
> the way that the default bandwidth to check is 5MHz. If the
> maximum bandwidth allowed by the channel is smaller than 5MHz,
> the channel is disabled. Otherwise the channel is used and the
> flags are set according to the bandwidth allowed by the channel.
> 
> Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
This change causes a regression and needs to be reverted or fixed.
It leaves Channel 12 enabled for US regdomain and does not prevent
bringing up AP mode on it (IEEE80211_CHAN_NO_20MHZ does not get set).

I think the main problem with this change is that max_bandwidth_khz
(which is used to derive the no-10mhz and no-20mhz flags) does not
consider the frequency when calculating the max bandwidth.

- Felix
