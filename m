Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab3CZPy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:54:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993Ab3CZPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/150] mwifiex: fix potential out-of-boundary access to ibss rate table
Date: Tue, 26 Mar 2013 15:19:15 +0000
Message-Id: <1364311249-14454-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 5f0fabf84d7b52f979dcbafa3d3c530c60d9a92c upstream.

smatch found this error:

CHECK   drivers/net/wireless/mwifiex/join.c
  drivers/net/wireless/mwifiex/join.c:1121
  mwifiex_cmd_802_11_ad_hoc_join()
  error: testing array offset 'i' after use.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/join.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index d6b4fb0..97bb759 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1093,10 +1093,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		adhoc_join->bss_descriptor.bssid,
 		adhoc_join->bss_descriptor.ssid);
 
-	for (i = 0; bss_desc->supported_rates[i] &&
-			i < MWIFIEX_SUPPORTED_RATES;
-			i++)
-			;
+	for (i = 0; i < MWIFIEX_SUPPORTED_RATES &&
+		    bss_desc->supported_rates[i]; i++)
+		;
 	rates_size = i;
 
 	/* Copy Data Rates from the Rates recorded in scan response */
-- 
1.8.1.2

