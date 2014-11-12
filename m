Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKLBUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKLBUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 015/319] hyperv: Fix the total_data_buflen in send path
Date: Wed, 12 Nov 2014 10:12:33 +0900
Message-Id: <20141112010955.213162606@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 942396b01989d54977120f3625e5ba31afe7a75c ]

total_data_buflen is used by netvsc_send() to decide if a packet can be put
into send buffer. It should also include the size of RNDIS message before the
Ethernet frame. Otherwise, a messge with total size bigger than send_section_size
may be copied into the send buffer, and cause data corruption.

[Request to include this patch to the Stable branches]

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -556,6 +556,7 @@ do_lso:
 do_send:
 	/* Start filling in the page buffers with the rndis hdr */
 	rndis_msg->msg_len += rndis_msg_size;
+	packet->total_data_buflen = rndis_msg->msg_len;
 	packet->page_buf_cnt = init_page_array(rndis_msg, rndis_msg_size,
 					skb, &packet->page_buf[0]);
 


