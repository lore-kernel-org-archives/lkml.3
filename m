Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaCKNFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:05:25 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58862 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaCKNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:05:23 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 0/5] cfg80211: Add channel attributes to be used with 5/10MHz channels
Date: Tue, 11 Mar 2014 14:05:09 +0100
Message-Id: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment specifies usage of 5 and 10 MHz wide
channels in 5.9GHz band for vehicular environment. This patch-set adds
new channel attributes holding the information about the prohibited
bandwidths. This is meant to be used mainly with channels in 5.9GHz
band in future implementation of 802.11p.


Rostislav Lisovy (5):
  cfg80211: Add attributes describing prohibited channel bandwidth
  nl80211: Support for 5/10 MHz channels when reporting BW restrictions
  cfg80211: Take the BW restrictions into account when checking the
    channel
  cfg80211: Use 5MHz bandwidth by default when checking usable channels
  mac80211: Update conf_is_ht() to work properly with 5/10MHz channels

 include/net/cfg80211.h       |  6 ++++++
 include/net/mac80211.h       |  4 +++-
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/chan.c          |  2 ++
 net/wireless/nl80211.c       | 13 +++++++++++++
 net/wireless/reg.c           | 22 +++++++++++++++-------
 6 files changed, 45 insertions(+), 8 deletions(-)

-- 
1.8.5.1

