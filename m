Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3DAR4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:56:35 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:60126 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799Ab3DAR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:56:34 -0400
Message-ID: <1364838992.21627.61.camel@x61.thuisdomein>
Subject: [PATCH 1/8] virtio_net: do not export "u16" to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Jason Wang <jasowang@redhat.com>, Krishna Kumar <krkumar2@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 19:56:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2013 17:56:32.0863 (UTC) FILETIME=[3EB236F0:01CE2F02]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the lguest (userspace) tool fails with this error:
    In file included from lguest.c:46:0:
    /usr/include/linux/virtio_net.h:188:2: error: unknown type name ‘u16’
    make: *** [lguest] Error 1

virtio_net.h exports "u16" to userspace. Use "__u16" instead of "u16".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"u16" was added here in commit 986a4f4d452dec004697f667439d27c3fda9c928
("virtio_net: multiqueue support"). That commit was shipped in v3.8. So
if this patch ends up in the tree it should also be sent to stable.

 include/uapi/linux/virtio_net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index a5a8c88..c520203 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -191,7 +191,7 @@ struct virtio_net_ctrl_mac {
  * specified.
  */
 struct virtio_net_ctrl_mq {
-	u16 virtqueue_pairs;
+	__u16 virtqueue_pairs;
 };
 
 #define VIRTIO_NET_CTRL_MQ   4
-- 
1.7.11.7

