Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3EQVhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab3EQVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 066/102] virtio: dont expose u16 in userspace api
Date: Fri, 17 May 2013 14:36:21 -0700
Message-Id: <20130517213251.325527072@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/virtio_net.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


