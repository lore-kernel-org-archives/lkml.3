Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaKKLKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKKLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 077/170] hyperv: Fix the total_data_buflen in send path
Date: Tue, 11 Nov 2014 11:07:16 +0000
Message-Id: <1415704129-12709-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 942396b01989d54977120f3625e5ba31afe7a75c upstream.

total_data_buflen is used by netvsc_send() to decide if a packet can be put
into send buffer. It should also include the size of RNDIS message before the
Ethernet frame. Otherwise, a messge with total size bigger than send_section_size
may be copied into the send buffer, and cause data corruption.

[Request to include this patch to the Stable branches]

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/hyperv/netvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f15297201777..7e3331821200 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -556,6 +556,7 @@ do_lso:
 do_send:
 	/* Start filling in the page buffers with the rndis hdr */
 	rndis_msg->msg_len += rndis_msg_size;
+	packet->total_data_buflen = rndis_msg->msg_len;
 	packet->page_buf_cnt = init_page_array(rndis_msg, rndis_msg_size,
 					skb, &packet->page_buf[0]);
 
-- 
2.1.0

