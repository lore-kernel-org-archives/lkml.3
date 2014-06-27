Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaF0QZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:25:10 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33941 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaF0QZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:25:08 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC] Try multiple bandwidths when checking usable channels.
Date: Fri, 27 Jun 2014 18:24:53 +0200
Message-Id: <1403886294-713-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue with the code in the reverted 8eca1fb692cc commit (and the
previous unmodified implementation as well) was that we checked if a
channel of some particular bandwidth (i.e. 5 or formerly 20 MHz) will
be within some regulatory rule range -- if it was, we then blindly set
IEEE80211_CHAN_NO_* flags according to the maximum bandwidth allowed,
not according to the fact if such a channel would be within the
regulatory rule range. Example demonstrating behaviour of the reverted
patch: At first we checked if Channel 12 (BW set to 5 MHz) is usable
in US -- it is. Then we continued setting flags -- because the maximum
allowed bandwidth for the band 2402--2472 is 40 MHz, we allowed 20 MHz
operation which is completely wrong since "2467 MHz" (Channel 12) +
"10 MHz" (1/2 of the BW) is no more within the allowed 2402--2472.


Rostislav Lisovy (1):
  Try explicitly bandwidths 5--160 MHz when checking usable channels.

 include/net/cfg80211.h |   8 +-
 net/wireless/reg.c     | 202 +++++++++++++++++++++++++++++++------------------
 2 files changed, 137 insertions(+), 73 deletions(-)

-- 
2.0.0.rc4

