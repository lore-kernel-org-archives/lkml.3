Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaCTT1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:27:47 -0400
Received: from lekensteyn.nl ([178.21.112.251]:55676 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759766AbaCTT1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:27:44 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        John W Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, lekensteyn@gmail.com
Subject: [PATCH 0/3] rtlwifi (and staging rtl8821ae) cleanups
Date: Thu, 20 Mar 2014 19:52:21 +0100
Message-Id: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch of these series was NAKed some weeks ago because it would
conflict with the new rtl8723be driver. Since those changes are in wireless-next
now, I have adjusted that patch to take care of rtl8723be.

The other two patches to the staging driver is similar to the rtlwifi changes.
I am not sure who to send these two patches to. Greg is the staging maintainer,
but John takes wireless patches, so I have included both of you.

All patches are compile-tested on top of v3.14-rc2-938-g67b3bd4.

I also found the following (unrelated to my patches) warning while compiling the
staging driver, perhaps it needs a closer look?

  CC [M]  drivers/net/wireless/rtlwifi/stats.o
  CC [M]  drivers/staging/rtl8821ae/rtl8821ae/hal_btc.o
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function ‘rtl8821ae_dm_clear_txpower_tracking_state’:
drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u invokes undefined behavior [-Waggressive-loop-optimizations]
   rtldm->bb_swing_idx_ofdm[p] = rtldm->default_ofdm_index;
                               ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
  for (p = RF90_PATH_A; p < MAX_RF_PATH; ++p) {
  ^
  CC [M]  drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.o

Thanks,
Peter

Peter Wu (3):
  rtlwifi: remove unused allow_all_destaddr functions
  staging/rtl8821ae: avoid accessing RCR directly
  staging/rtl8821ae: remove unused allow_all_destaddr function

 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 21 ---------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 21 ---------------------
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8723be/hw.h |  2 --
 drivers/net/wireless/rtlwifi/wifi.h         |  2 --
 drivers/staging/rtl8821ae/rtl8821ae/hw.c    | 27 +++------------------------
 drivers/staging/rtl8821ae/rtl8821ae/hw.h    |  3 ---
 drivers/staging/rtl8821ae/rtl8821ae/sw.c    |  1 -
 drivers/staging/rtl8821ae/wifi.h            |  2 --
 19 files changed, 3 insertions(+), 148 deletions(-)

-- 
1.9.1

