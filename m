Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaBSSJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbaBSSJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:31 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 5/5] audit: send multicast messages only if there are listeners
Date: Wed, 19 Feb 2014 13:08:23 -0500
Message-Id: <0f0de282d06e74633d79fc878b10ace1045397c3.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test first to see if there are any userspace multicast listeners bound to the
socket before starting the multicast send work.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 0da57b6..6e8d137 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -434,6 +434,8 @@ static void kauditd_send_multicast_skb(struct sk_buff *skb)
 	struct sk_buff *copy;
 	struct nlmsghdr *nlh;
 
+	if (!netlink_has_listeners(audit_sock, AUDIT_NLGRP_READLOG))
+		return;
 	/*
 	 * The seemingly wasteful skb_copy() is necessary because the original
 	 * kaudit unicast socket sends up messages with nlmsg_len set to the
-- 
1.7.1

