Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3CYBQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab3CYBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:42 -0400
Message-Id: <20130325010526.424976979@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 021/104] mwifiex: fix potential out-of-boundary access to ibss rate table
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/join.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1062,10 +1062,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mw
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


