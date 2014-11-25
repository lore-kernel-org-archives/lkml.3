Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaKYKse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:48:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaKYKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 241/254] audit: correct AUDIT_GET_FEATURE return message type
Date: Tue, 25 Nov 2014 10:39:51 +0000
Message-Id: <1416912004-5928-242-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit 9ef91514774a140e468f99d73d7593521e6d25dc upstream.

When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
should reply with a message tagged as an AUDIT_GET_FEATURE type with a struct
audit_feature.  The current reply is a message tagged as an AUDIT_GET
type with a struct audit_feature.

This appears to have been a cut-and-paste-eo in commit b0fed40.

Reported-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 855aaa0803d9..6726aa6f82be 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -724,7 +724,7 @@ static int audit_get_feature(struct sk_buff *skb)
 
 	seq = nlmsg_hdr(skb)->nlmsg_seq;
 
-	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
+	audit_send_reply(skb, seq, AUDIT_GET_FEATURE, 0, 0, &af, sizeof(af));
 
 	return 0;
 }
-- 
2.1.0

