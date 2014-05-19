Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaESOtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:49:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50631 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaESOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:49:14 -0400
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 0/2] mac80211: Add new interface type for OCB (Outside the Context of a BSS) mode
Date: Mon, 19 May 2014 16:49:03 +0200
Message-Id: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment defines a procedure for data frames
transmission by an STA that is not a member of a BSS. Such data
frames are defined as being transmitted "outside the context of a
BSS" (this is allowed only if the MIB variable dot11OCBActivated
is true).  This patchset adds new interface type (NL80211_IFTYPE_OCB)
for an STA in the OCB mode.

When an OCB mode is used, all the STAs communicate with each
other without the need for a coordinator. In such case no beacons
are sent and BSSID is set to wildcard (all 1's). Every STA receives
all frames from every STA in range and transmits to every STA tuned
to the same channel. The communication is taking place in a reserved
frequency band (5.9 GHz).

Rostislav Lisovy (2):
  cfg80211: Add channel flags limiting availability to OCB mode only
  mac80211: Add new interface type for OCB mode

 include/net/cfg80211.h       |   2 +
 include/uapi/linux/nl80211.h |   8 +++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |   1 +
 net/mac80211/chan.c          |   2 +
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  38 ++++++++++++++
 net/mac80211/iface.c         |  28 +++++++++++
 net/mac80211/ocb.c           | 115 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c          |   5 ++
 net/wireless/nl80211.c       |   3 ++
 net/wireless/reg.c           |   2 +
 net/wireless/util.c          |   1 +
 13 files changed, 209 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/ocb.c

-- 
2.0.0.rc0

