Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3DZRxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:53:25 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42672
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3DZRxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:53:24 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Fix a compiler warning in netvsc_send()
Date: Fri, 26 Apr 2013 11:25:55 -0700
Message-Id: <1367000755-2571-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed: warning: cast from pointer to integer of different size

The Hyper-V hosts always use 64 bit request id. The guests can have 32 or 64
bit pointers which equal to the ulong type size. So we cast it to ulong type.
And, assigning 32bit integer to 64 bit variable works fine.

The VMBus returns the same id in the completion packet. But the value has no
effect on the host side.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index f5f0f09..2b04804 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -522,7 +522,7 @@ int netvsc_send(struct hv_device *device,
 	sendMessage.msg.v1_msg.send_rndis_pkt.send_buf_section_size = 0;
 
 	if (packet->completion.send.send_completion)
-		req_id = (u64)packet;
+		req_id = (ulong)packet;
 	else
 		req_id = 0;
 
-- 
1.7.4.1

