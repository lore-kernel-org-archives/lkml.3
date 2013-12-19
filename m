Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3LSM0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:26:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3LSL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ujjal Roy <royujjal@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 129/208] mwifiex: fix memory leak issue for ibss join
Date: Thu, 19 Dec 2013 11:53:47 +0000
Message-Id: <1387454106-19326-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ujjal Roy <royujjal@gmail.com>

commit 517543fd72d577dde2ebd9505dc4abf26d589f9a upstream.

For IBSS join if the requested SSID matches current SSID,
it returns without freeing the allocated beacon IE buffer.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 8af97ab..252e09b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -319,8 +319,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		if (bss_desc && bss_desc->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp(&priv->curr_bss_params.bss_descriptor.
 				       ssid, &bss_desc->ssid))) {
-			kfree(bss_desc);
-			return 0;
+			ret = 0;
+			goto done;
 		}
 
 		/* Exit Adhoc mode first */
-- 
1.8.3.2

