Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967435Ab3HIBm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:42:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967119Ab3HIBl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:41:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/22] net_sched: Fix stack info leak in cbq_dump_wrr().
Date: Thu,  8 Aug 2013 18:41:36 -0700
Message-Id: <20130809013953.666483614@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809013949.226228694@linuxfoundation.org>
References: <20130809013949.226228694@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a0db856a95a29efb1c23db55c02d9f0ff4f0db48 ]

Make sure the reserved fields, and padding (if any), are
fully initialized.

Based upon a patch by Dan Carpenter and feedback from
Joe Perches.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1467,6 +1467,7 @@ static int cbq_dump_wrr(struct sk_buff *
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cbq_wrropt opt;
 
+	memset(&opt, 0, sizeof(opt));
 	opt.flags = 0;
 	opt.allot = cl->allot;
 	opt.priority = cl->priority + 1;


