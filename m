Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3E1VZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab3E1VZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 69/78] virtio: don't expose u16 in userspace api
Date: Tue, 28 May 2013 14:20:18 -0700
Message-Id: <1369776027-17859-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 77d21f23a1e4db8639e3916547c903a3b3c7a07c ]

Programs using virtio headers outside of kernel will no longer
build because u16 type does not exist in userspace. All user ABI
must use __u16 typedef instead.

Bug introduce by:
  commit 986a4f4d452dec004697f667439d27c3fda9c928
  Author: Jason Wang <jasowang@redhat.com>
  Date:   Fri Dec 7 07:04:56 2012 +0000

    virtio_net: multiqueue support

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/virtio_net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 848e358..f3857ff 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -185,7 +185,7 @@ struct virtio_net_ctrl_mac {
  * specified.
  */
 struct virtio_net_ctrl_mq {
-	u16 virtqueue_pairs;
+	__u16 virtqueue_pairs;
 };
 
 #define VIRTIO_NET_CTRL_MQ   4
-- 
1.8.1.2

