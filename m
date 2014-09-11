Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaIKOas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:30:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56989 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIKOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:30:45 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 0/4] 802.11p OCB mode
Date: Thu, 11 Sep 2014 16:30:18 +0200
Message-Id: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment (already part of IEEE 802.11-2012)
specifies usage of 5 and 10 MHz wide channels in 5.9GHz band for
vehicular environment. All the 802.11p compliant devices should
be set to the newly added operation mode -- OCB (Outside the
Context of a BSS). No authentication/association is necessary to
communicate. The only parameter to be configured is the channel
(central frequency and bandwidth) to communicate on. The channel
has to be known a priori. It is set during the 'ocb join'
operation (sent via netlink message from user-space).

This patchset adds the OCB mode, OCB join and leave handling
(nl80211, cfg80211, mac80211), 802.11p EDCA parameters
modification, RX and TX path (for unicast/broadcast messages).

What aspects are ignored for now:
* Rate control -- We limit the supported datarates to the .11a
  mandatory rates and use the Minstrel as usual
* Actually restricting the OCB mode to the 5.9 GHz band

Tested with the ath9k card with slightly modified driver.
User-space configuration utilities are not part of this patch.

Rostislav Lisovy (4):
  mac80211: OCB mode + join and leave handling
  mac80211: Use different EDCA config for OCB
  cfg80211: Join and Leave handling for OCB mode
  nl80211: Join and Leave handling for OCB mode

 include/net/cfg80211.h       |  11 ++
 include/net/mac80211.h       |   2 +
 include/uapi/linux/nl80211.h |  11 ++
 net/mac80211/Kconfig         |  11 ++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |  14 +++
 net/mac80211/chan.c          |   1 +
 net/mac80211/debug.h         |  10 ++
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  20 ++++
 net/mac80211/iface.c         |  20 ++++
 net/mac80211/ocb.c           | 236 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c            |  33 ++++++
 net/mac80211/tx.c            |  15 +++
 net/mac80211/util.c          |  31 +++++-
 net/mac80211/wme.c           |   4 +
 net/wireless/Makefile        |   2 +-
 net/wireless/chan.c          |   8 ++
 net/wireless/core.h          |  10 ++
 net/wireless/nl80211.c       |  47 +++++++++
 net/wireless/ocb.c           |  88 ++++++++++++++++
 net/wireless/rdev-ops.h      |  21 ++++
 net/wireless/trace.h         |  21 ++++
 net/wireless/util.c          |   5 +-
 24 files changed, 618 insertions(+), 9 deletions(-)
 create mode 100644 net/mac80211/ocb.c
 create mode 100644 net/wireless/ocb.c

-- 
2.0.0.rc4

