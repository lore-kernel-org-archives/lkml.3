Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbaKSWGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:06:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbaKSVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.14 024/122] audit: correct AUDIT_GET_FEATURE return message type
Date: Wed, 19 Nov 2014 12:51:14 -0800
Message-Id: <20141119205209.605713908@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -687,7 +687,7 @@ static int audit_get_feature(struct sk_b
 
 	seq = nlmsg_hdr(skb)->nlmsg_seq;
 
-	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
+	audit_send_reply(skb, seq, AUDIT_GET_FEATURE, 0, 0, &af, sizeof(af));
 
 	return 0;
 }


