Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622Ab3DKUdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:33:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3DKU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:14 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BDmXERY6GLIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w1eqRo_xLM8A:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.873042948@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bing Zhao <bzhao@marvell.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [ 041/171 ] mwifiex: fix potential out-of-boundary access to ibss rate table
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0041-mwifiex-fix-potential-out-of-boundary-access-to-ibss.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

[ Upstream commit 5f0fabf84d7b52f979dcbafa3d3c530c60d9a92c ]

smatch found this error:

CHECK   drivers/net/wireless/mwifiex/join.c
  drivers/net/wireless/mwifiex/join.c:1121
  mwifiex_cmd_802_11_ad_hoc_join()
  error: testing array offset 'i' after use.

Cc: <stable@vger.kernel.org> # 3.0+
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/join.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 82e63ce..fa42578 100644
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
1.7.10.4


