Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaJ2NfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729AbaJ2NfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:35:10 -0400
Date: Wed, 29 Oct 2014 09:35:06 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: stable@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        pmoore@redhat.com
Subject: [PATCH][STABLE] audit: correct AUDIT_GET_FEATURE return message type
Message-ID: <20141029133506.GN26201@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
should reply with a message tagged as an AUDIT_GET_FEATURE type with a struct
audit_feature.  The current reply is a message tagged as an AUDIT_GET
type with a struct audit_feature.

This appears to have been a cut-and-paste-eo in commit b0fed40.

Reported-by: Steve Grubb <sgrubb@redhat.com>
Cc: stable@vger.kernel.org # v3.13-rc1
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

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
