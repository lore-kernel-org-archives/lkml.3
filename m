Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbaELRhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:37:51 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:16354 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbaELRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:37:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocKAI4GcVNbsHLF/2dsb2JhbABZgwaCQaopCQEFAZobgRoXdIJmHCMYgQIkE4hFAc9FhVaIGGSERwEDjyWKIgGLBIgDgzg7gTA
Date: Mon, 12 May 2014 19:37:47 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/scan.c: replace memcpy by ether_addr_copy
Message-Id: <20140512193747.5714f0dd8278177425cf8b66@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7d09a71..6e321ee 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -893,7 +893,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	if (!channel)
 		return NULL;
 
-	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
+	ether_addr_copy(tmp.pub.bssid, bssid);
 	tmp.pub.channel = channel;
 	tmp.pub.scan_width = scan_width;
 	tmp.pub.signal = signal;
-- 
1.9.1

