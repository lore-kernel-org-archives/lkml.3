Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbaE3Q4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:56:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60175 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933752AbaE3Q4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:56:36 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 0/4 v2] cfg80211/mac80211: Add new interface type for OCB (Outside the Context of a BSS) mode
Date: Fri, 30 May 2014 18:56:20 +0200
Message-Id: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment defines a procedure for data frames
transmission by an STA that is not a member of a BSS. Such data
frames are defined as being transmitted "outside the context of a
BSS" (this is allowed only if the MIB variable dot11OCBActivated is
true).  This patchset adds new interface type (NL80211_IFTYPE_OCB)
for an STA in the OCB mode.

When an OCB mode is used, all the STAs communicate with each other
without the need for a coordinator. In such case no beacons are
sent and BSSID is set to wildcard (all 1's). Every STA receives all
frames from every STA in range and transmits to every STA tuned to
the same channel. The communication is taking place in a reserved
frequency band (5.9 GHz).

This patchset presents work in progress. Patches adding *_leave_ocb()
functions and modifying RX/TX path in mac80211 to work with OCB
mode will come in near future.


Changes v1 --> v2:
* Added proper (__)cfg80211_join_ocb function
* Removed the infrastructure for ocb_housekeeping
  (has to be reworked and added in the future)
* OCB_ONLY channel flags are checked in __cfg80211_join_ocb()

Rostislav Lisovy (4):
  cfg80211: Add channel flags limiting availability to OCB mode only
  cfg80211: Add new interface type for OCB mode
  nl80211: Do not ignore 5/10MHz wide channels in nl80211_send_chandef()
  mac80211: OCB mode interface configuration

 include/net/cfg80211.h       |  9 ++++++
 include/uapi/linux/nl80211.h |  8 +++++
 net/mac80211/Makefile        |  3 +-
 net/mac80211/cfg.c           | 22 +++++++++++++
 net/mac80211/chan.c          |  1 +
 net/mac80211/driver-ops.h    |  3 +-
 net/mac80211/ieee80211_i.h   |  3 ++
 net/mac80211/iface.c         | 22 +++++++++++++
 net/mac80211/ocb.c           | 22 +++++++++++++
 net/mac80211/util.c          |  5 +++
 net/wireless/Makefile        |  2 +-
 net/wireless/chan.c          |  2 ++
 net/wireless/core.h          |  8 +++++
 net/wireless/nl80211.c       |  6 ++++
 net/wireless/ocb.c           | 75 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 11 +++++++
 net/wireless/reg.c           |  2 ++
 net/wireless/trace.h         | 17 ++++++++++
 net/wireless/util.c          |  5 ++-
 19 files changed, 222 insertions(+), 4 deletions(-)
 create mode 100644 net/mac80211/ocb.c
 create mode 100644 net/wireless/ocb.c

-- 
2.0.0.rc4

