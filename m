Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab3GXAJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:09:49 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46508 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GXAJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:09:47 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] mac80211: use oneshot blink API for LED triggers
Date: Wed, 24 Jul 2013 02:09:40 +0200
Message-Id: <1374624581-6012-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes, John,

This patch changes the mac80211 LED driver to use the generic oneshot
LED API.

The current mac80211 blink code seems to lead to very short tx blinks
and toggles the LED on tx.  The oneshot API ensure a complete LED on-off
cycle for each blink event, thus getting a better result for an activity
indicator: one visible blink for sporadic events and a steady on-off
blink sequence on constant traffic.

Would you consider this patch for wireless-next?

Thanks,
Fabio

Fabio Baltieri (1):
  mac80211: use oneshot blink API for LED triggers

 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/led.c         | 21 +++++++++------------
 net/mac80211/led.h         |  2 +-
 net/mac80211/status.c      |  2 +-
 net/mac80211/tx.c          |  1 -
 5 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.8.2

