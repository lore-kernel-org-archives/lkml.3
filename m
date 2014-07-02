Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaGBNVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:21:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:15960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaGBNVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:21:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="567258190"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/6] lib / string_helpers: introduce string_escape_mem
Date: Wed,  2 Jul 2014 16:20:23 +0300
Message-Id: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduced function is a kind of opposite to string_unescape. We have
several users of such functionality each of them created custom implementation.
The series contains clean up of test suite, adding new call, and switching few
users to use it.

Test suite covers all of existing and most of potential use cases.

Andy Shevchenko (6):
  lib / string_helpers: clean up test suite
  lib / string_helpers: introduce string_escape_mem()
  lib80211: re-use string_escape_mem_any_np()
  staging: wlan-ng: re-use string_escape_mem()
  staging: rtl8192e: re-use string_escape_mem()
  staging: rtl8192u: re-use string_escape_mem()

 drivers/staging/rtl8192e/rtllib.h              |  13 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h |  13 +-
 drivers/staging/wlan-ng/prism2sta.c            |  29 +--
 include/linux/string_helpers.h                 |  83 ++++++++
 lib/string_helpers.c                           | 215 +++++++++++++++++++++
 lib/test-string_helpers.c                      | 250 +++++++++++++++++++++++--
 net/wireless/lib80211.c                        |  24 +--
 7 files changed, 551 insertions(+), 76 deletions(-)

-- 
2.0.0

