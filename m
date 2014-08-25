Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaHYFF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 01:05:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbaHYFF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 01:05:56 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH] audit: correct AUDIT_GET_FEATURE return message type
Date: Mon, 25 Aug 2014 01:03:01 -0400
Message-Id: <9ca71c59332bc54efbcdc80170db690c051ca93c.1408942844.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
should reply with a message tagged as an AUDIT_GET_FEATURE type with a struct
audit_feature.  The current reply is a message tagged as an AUDIT_GET
type with a struct audit_feature.

This appears to have been a cut-and-paste-eo in commit b0fed40.

Reported-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d20f00f..3a80abb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -724,7 +724,7 @@ static int audit_get_feature(struct sk_buff *skb)
 
 	seq = nlmsg_hdr(skb)->nlmsg_seq;
 
-	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
+	audit_send_reply(skb, seq, AUDIT_GET_FEATURE, 0, 0, &af, sizeof(af));
 
 	return 0;
 }
-- 
1.7.1

