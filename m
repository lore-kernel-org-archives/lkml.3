Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaFWKFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:05:03 -0400
Received: from nbd.name ([46.4.11.11]:38699 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaFWKFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:05:00 -0400
Message-ID: <53A7FBB2.2050703@openwrt.org>
Date: Mon, 23 Jun 2014 12:04:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rostislav Lisovy <lisovy@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: Re: [PATCH 2/2] cfg80211: Use 5MHz bandwidth by default when checking
 usable channels
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>	 <1397565476-4348-3-git-send-email-rostislav.lisovy@fel.cvut.cz>	 <53A6C0FF.9090104@openwrt.org> <1403514536.4418.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1403514536.4418.6.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-23 11:08, Johannes Berg wrote:
> On Sun, 2014-06-22 at 13:41 +0200, Felix Fietkau wrote:
>> On 2014-04-15 14:37, Rostislav Lisovy wrote:
>> > Current code checks if the 20MHz bandwidth is allowed for
>> > particular channel -- if it is not, the channel is disabled.
>> > Since we need to use 5/10 MHz channels, this code is modified in
>> > the way that the default bandwidth to check is 5MHz. If the
>> > maximum bandwidth allowed by the channel is smaller than 5MHz,
>> > the channel is disabled. Otherwise the channel is used and the
>> > flags are set according to the bandwidth allowed by the channel.
>> > 
>> > Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
> 
>> This change causes a regression and needs to be reverted or fixed.
> 
> Noted, I've reverted it in mac80211.git.
> 
>> It leaves Channel 12 enabled for US regdomain and does not prevent
>> bringing up AP mode on it (IEEE80211_CHAN_NO_20MHZ does not get set).
> 
> I'm not sure this makes sense - CHAN_NO_20MHZ shouldn't get set on that
> channel? It should be disabled for other reasons for AP mode - e.g.
> NO_IR.
I was thinking it could be valid in AP mode for 5 MHz operation.

- Felix
