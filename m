Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbaFCUG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:06:26 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:44555 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932925AbaFCUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:06:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOAIUpjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SDAiOBGjeIRgHRMBeFVYgZZB2EKgSPS4o/ix2IFoM6O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/audit.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  3 Jun 2014 22:05:10 +0200
Message-Id: <1401825910-8793-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition.

Cc: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 47845c5..48e6e5d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -718,7 +718,7 @@ static int audit_set_feature(struct sk_buff *skb)
 	struct audit_features *uaf;
 	int i;
 
-	BUILD_BUG_ON(AUDIT_LAST_FEATURE + 1 > sizeof(audit_feature_names)/sizeof(audit_feature_names[0]));
+	BUILD_BUG_ON(AUDIT_LAST_FEATURE + 1 > ARRAY_SIZE(audit_feature_names));
 	uaf = nlmsg_data(nlmsg_hdr(skb));
 
 	/* if there is ever a version 2 we should handle that here */
-- 
1.8.4.5

