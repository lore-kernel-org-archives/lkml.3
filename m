Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaBGLYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaBGLXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/88] rtlwifi: rtl8192cu: Fix W=1 build warning
Date: Fri,  7 Feb 2014 11:22:11 +0000
Message-Id: <1391772205-22239-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0b948341f398646b0d59d746800fbbf3656886e7 upstream.

When this driver is built with "make W=1", the following warning is output:

drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:56:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 5212ad2..873754b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -76,7 +76,7 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 				      GFP_KERNEL, hw, rtl_fw_cb);
 
 
-	return 0;
+	return err;
 }
 
 static void rtl92cu_deinit_sw_vars(struct ieee80211_hw *hw)
-- 
1.8.3.2

