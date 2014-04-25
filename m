Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaDYUOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:14:16 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:56986 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbaDYUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:14:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIWANzAWlNXQASl/2dsb2JhbABZgwaCQKkSmXACAoETF3SCUxMcIxiBAiQTiEUBykKFWoh/hEABA452ig4BinGHa4MzOw
Date: Fri, 25 Apr 2014 22:16:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Paris <eparis@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/audit.c: Remove positive test on
 backlog_wait_time
Message-Id: <20140425221615.091484e561e94309f45c9007@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_status.backlog_wait_time is __u32

Cc: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/audit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7c28936..b08a1bc 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -854,8 +854,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (s.mask & AUDIT_STATUS_BACKLOG_WAIT_TIME) {
 			if (sizeof(s) > (size_t)nlh->nlmsg_len)
 				return -EINVAL;
-			if (s.backlog_wait_time < 0 ||
-			    s.backlog_wait_time > 10*AUDIT_BACKLOG_WAIT_TIME)
+			if (s.backlog_wait_time > 10*AUDIT_BACKLOG_WAIT_TIME)
 				return -EINVAL;
 			err = audit_set_backlog_wait_time(s.backlog_wait_time);
 			if (err < 0)
-- 
1.8.4.5

