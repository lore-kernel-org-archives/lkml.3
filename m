Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaGGPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:25:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:54370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaGGPV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:21:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="558367889"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 00/10] lib: introduce string_escape_mem an %*pE specifier
Date: Mon,  7 Jul 2014 18:21:42 +0300
Message-Id: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduced function is a kind of opposite to string_unescape. We have
several users of such functionality each of them created custom implementation.
The series contains clean up of test suite, adding new call, and switching few
users to use it via %*pE specifier.

Test suite covers all of existing and most of potential use cases.

Changelog v2:
- addressed Joe's comments:
  - added patch 4/10
  - moving patches 5/10-10/10 to %*pE instead of direct string_escape_mem call,
    as a result the series and code looks cleaner 
- address few of Andrew's comments:
  - added patch 1/10
  - kernel documentation moved to c-file
  - when test case fails the necessary messages are printed on KERN_WARNING
    level

Andy Shevchenko (10):
  lib / string_helpers: move documentation to c-file
  lib / string_helpers: refactoring the test suite
  lib / string_helpers: introduce string_escape_mem()
  lib/vsprintf: add %*pE[achnops] format specifier
  wireless: libertas: print esaped string via %*pE
  wireless: ipw2x00: print SSID via %*pE
  lib80211: remove unused print_ssid()
  staging: wlan-ng: use %*pEhp to print SN
  staging: rtl8192e: use %*pEn to escape buffer
  staging: rtl8192u: use %*pEn to escape buffer

 Documentation/printk-formats.txt               |  28 +++
 drivers/net/wireless/ipw2x00/ipw2100.c         |  22 +-
 drivers/net/wireless/ipw2x00/ipw2200.c         | 270 +++++++--------------
 drivers/net/wireless/ipw2x00/libipw_rx.c       |  65 +++---
 drivers/net/wireless/ipw2x00/libipw_wx.c       |  16 +-
 drivers/net/wireless/libertas/cfg.c            |   8 +-
 drivers/net/wireless/libertas/mesh.c           |   7 +-
 drivers/staging/rtl8192e/rtllib.h              |  14 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h |  14 +-
 drivers/staging/wlan-ng/prism2sta.c            |  28 +--
 include/linux/string_helpers.h                 |  65 +++---
 include/net/lib80211.h                         |   5 -
 lib/string_helpers.c                           | 312 +++++++++++++++++++++++++
 lib/test-string_helpers.c                      | 250 +++++++++++++++++++-
 lib/vsprintf.c                                 |  72 ++++++
 net/wireless/lib80211.c                        |  32 ---
 16 files changed, 817 insertions(+), 391 deletions(-)

-- 
2.0.1

