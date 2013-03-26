Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3CZXCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:02:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab3CZXCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/49] mwifiex: fix potential out-of-boundary access to ibss rate table
Date: Tue, 26 Mar 2013 16:01:24 -0700
Message-Id: <20130326225842.345990024@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/join.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1102,10 +1102,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mw
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


