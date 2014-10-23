Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaJWQQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:16:08 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:24681 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbaJWQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:16:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswNAB0pSVRbtA79/2dsb2JhbABcgw66QwUBdJo+gRMXAX2EMC8jgRo3iEUBuhGOTCyGJYozHYQ1BZ1djGiJRYFHATYggVw7L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Sage Weil <sage@inktank.com>,
        "David S. Miller" <davem@davemloft.net>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] libceph: remove unused variable in handle_reply()
Date: Thu, 23 Oct 2014 18:15:59 +0200
Message-Id: <1414080959-6053-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

osdmap_epoch is redundant with reassert_epoch and unused.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ceph/osd_client.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index f3fc54e..432bd75 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1700,7 +1700,6 @@ static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
 	int err;
 	u32 reassert_epoch;
 	u64 reassert_version;
-	u32 osdmap_epoch;
 	int already_completed;
 	u32 bytes;
 	unsigned int i;
@@ -1725,7 +1724,6 @@ static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
 	result = ceph_decode_32(&p);
 	reassert_epoch = ceph_decode_32(&p);
 	reassert_version = ceph_decode_64(&p);
-	osdmap_epoch = ceph_decode_32(&p);
 
 	/* lookup */
 	down_read(&osdc->map_sem);
-- 
1.9.3

