Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3A1DrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:47:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3A1Dq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:46:56 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH 6/6] audit: send multicast messages only if there are listeners
Date: Sun, 27 Jan 2013 22:45:18 -0500
Message-Id: <1359344718-3953-7-git-send-email-rbriggs@redhat.com>
In-Reply-To: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
References: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

Test first to see if there are any userspace multicast listeners bound to the
socket before starting the multicast send work.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---
 kernel/audit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9eef05b..d153a6b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -428,6 +428,8 @@ static void kauditd_send_multicast_skb(struct sk_buff *skb)
 	struct sk_buff *copy;
 	struct nlmsghdr *nlh;
 
+	if (!netlink_has_listeners(audit_sock, AUDIT_NLGRP_READLOG))
+		return;
 	/*
 	 * The seemingly wasteful skb_copy() is necessary because the original
 	 * kaudit unicast socket sends up messages with nlmsg_len set to the
-- 
1.8.0.2

