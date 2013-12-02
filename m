Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab3LBV23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3LBTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.4 37/60] audit: use nlmsg_len() to get message payload length
Date: Mon,  2 Dec 2013 11:06:18 -0800
Message-Id: <20131202190338.344090372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 4d8fe7376a12bf4524783dd95cbc00f1fece6232 upstream.

Using the nlmsg_len member of the netlink header to test if the message
is valid is wrong as it includes the size of the netlink header itself.
Thereby allowing to send short netlink messages that pass those checks.

Use nlmsg_len() instead to test for the right message length. The result
of nlmsg_len() is guaranteed to be non-negative as the netlink message
already passed the checks of nlmsg_ok().

Also switch to min_t() to please checkpatch.pl.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -695,7 +695,7 @@ static int audit_receive_msg(struct sk_b
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {


