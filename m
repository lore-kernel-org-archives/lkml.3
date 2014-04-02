Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaDBNcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:32:10 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46434 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaDBNcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:32:04 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 0/4 v2] cfg80211: The very first steps to support 5/10MHz channels in 5.9Ghz band
Date: Wed,  2 Apr 2014 15:31:51 +0200
Message-Id: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment specifies usage of 5 and 10 MHz wide
channels in 5.9GHz band for vehicular environment. This patch-set
adds new channel attributes holding the information about the
prohibited bandwidths. This is meant to be used mainly with
channels in 5.9GHz band in future implementation of 802.11p.

Changes since v1:
 * Rebased to 3.14
 * Squashed patches 1+2
 * All patches have long commit message


Rostislav Lisovy (4):
  cfg80211: Add attributes describing prohibited channel bandwidth
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
1.9.1

