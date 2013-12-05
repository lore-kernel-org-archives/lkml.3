Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3LERht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3LERhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 52/90] audit: fix info leak in AUDIT_GET requests
Date: Thu,  5 Dec 2013 17:35:34 +0000
Message-Id: <1386264972-5399-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 64fbff9ae0a0a843365d922e0057fc785f23f0e3 upstream.

We leak 4 bytes of kernel stack in response to an AUDIT_GET request as
we miss to initialize the mask member of status_set. Fix that.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index f02d3fc..39b0438 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -684,6 +684,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	switch (msg_type) {
 	case AUDIT_GET:
+		status_set.mask		 = 0;
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
 		status_set.pid		 = audit_pid;
-- 
1.8.3.2

