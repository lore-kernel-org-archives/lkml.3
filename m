Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaFWOi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:38:26 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35153 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaFWOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:38:24 -0400
Message-ID: <1403534300.7341.6.camel@lolumad>
Subject: Re: [PATCH 2/2] cfg80211: Use 5MHz bandwidth by default when
 checking usable channels
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 23 Jun 2014 16:38:20 +0200
In-Reply-To: <1403517938.4418.16.camel@jlt4.sipsolutions.net>
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1397565476-4348-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <53A6C0FF.9090104@openwrt.org>
	 <1403514536.4418.6.camel@jlt4.sipsolutions.net>
	 <53A7FBB2.2050703@openwrt.org>
	 <1403517938.4418.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 12:05 +0200, Johannes Berg wrote:
> On Mon, 2014-06-23 at 12:04 +0200, Felix Fietkau wrote:
> > On 2014-06-23 11:08, Johannes Berg wrote:
> > > On Sun, 2014-06-22 at 13:41 +0200, Felix Fietkau wrote:
> > >> On 2014-04-15 14:37, Rostislav Lisovy wrote:
> > >> > Current code checks if the 20MHz bandwidth is allowed for
> > >> > particular channel -- if it is not, the channel is disabled.
> > >> > Since we need to use 5/10 MHz channels, this code is modified in
> > >> > the way that the default bandwidth to check is 5MHz. If the
> > >> > maximum bandwidth allowed by the channel is smaller than 5MHz,
> > >> > the channel is disabled. Otherwise the channel is used and the
> > >> > flags are set according to the bandwidth allowed by the channel.
> > >> > 
> > >> > Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
> > > 
> > >> This change causes a regression and needs to be reverted or fixed.
> > > 
> > > Noted, I've reverted it in mac80211.git.
> > > 
> > >> It leaves Channel 12 enabled for US regdomain and does not prevent
> > >> bringing up AP mode on it (IEEE80211_CHAN_NO_20MHZ does not get set).
> > > 
> > > I'm not sure this makes sense - CHAN_NO_20MHZ shouldn't get set on that
> > > channel? It should be disabled for other reasons for AP mode - e.g.
> > > NO_IR.
> > I was thinking it could be valid in AP mode for 5 MHz operation.
> 
> Huh, ok, maybe. I guess Rostislav can look into the details :)
> 

I am a bit confused right now. The regression is that the channel used
to be completely disabled and now it is not? The regulatory restrictions
prohibit the 20MHz BW for this channel but 5MHz BW is alright?

(I am out of office for the next few days, thus I am unfortunately
unable to write/test any code.)

Rostislav;

