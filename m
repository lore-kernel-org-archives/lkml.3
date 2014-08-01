Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaHEJzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:55:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37219 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbaHEJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:55:15 -0400
From: Haiyang Zhang <thomas1206@gmail.com>
X-Google-Original-From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Increase the buffer length for netvsc_channel_cb()
Date: Fri,  1 Aug 2014 15:55:30 +0000
Message-Id: <1406908530-22667-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the buffer is too small for a packet from VMBus, a bigger buffer will be
allocated in netvsc_channel_cb() and retry reading the packet from VMBus.
Increasing this buffer size will reduce the retry overhead.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 24441ae..3960acd 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -591,7 +591,7 @@ struct nvsp_message {
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 
-#define NETVSC_PACKET_SIZE                      2048
+#define NETVSC_PACKET_SIZE                      4096
 
 #define VRSS_SEND_TAB_SIZE 16
 
-- 
1.7.1

