Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaEFRHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:07:48 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:22031 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaEFRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:07:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4UALwWaVNbtAAq/2dsb2JhbABZgwarbQQBAQEBAQEFAZoHAgKBHxd0gmYcIxiBAiQTiEUBzjOFVoh8hEYBA48bihsBiwCHe4M2Ow
Date: Tue, 6 May 2014 19:07:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] arch/unicore32/mm/ioremap.c: convert printk/warn_on to
 warn(1
Message-Id: <20140506190734.56036e71639f391e57c6ed00@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+coalesce formats

(This is untested)

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/unicore32/mm/ioremap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/unicore32/mm/ioremap.c b/arch/unicore32/mm/ioremap.c
index 13068ee..5d9568c 100644
--- a/arch/unicore32/mm/ioremap.c
+++ b/arch/unicore32/mm/ioremap.c
@@ -143,13 +143,8 @@ void __iomem *__uc32_ioremap_pfn_caller(unsigned long pfn,
 	/*
 	 * Don't allow RAM to be mapped
 	 */
-	if (pfn_valid(pfn)) {
-		printk(KERN_WARNING "BUG: Your driver calls ioremap() on\n"
-			"system memory.  This leads to architecturally\n"
-			"unpredictable behaviour, and ioremap() will fail in\n"
-			"the next kernel release. Please fix your driver.\n");
-		WARN_ON(1);
-	}
+	if (pfn_valid(pfn))
+		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
 
 	type = get_mem_type(mtype);
 	if (!type)
-- 
1.8.4.5

