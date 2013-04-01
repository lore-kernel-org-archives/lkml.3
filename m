Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3DAR7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:59:19 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:59942 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757201Ab3DAR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:59:18 -0400
Message-ID: <1364839156.21627.65.camel@x61.thuisdomein>
Subject: [PATCH 3/8] virtio: do not export "u16" and "u64" to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 19:59:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 17:59:17.0791 (UTC) FILETIME=[A1003AF0:01CE2F02]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_balloon.h exports "u16" and "u64" to userspace. Use "__u16" and
"__u64" instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with a kernel build.

1) Both types are used in this header for quite some time now. So is my
patch flawed or doesn't userspace actually use virtio_balloon.h?

 include/uapi/linux/virtio_balloon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 652dc8b..5e26f61 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -52,8 +52,8 @@ struct virtio_balloon_config
 #define VIRTIO_BALLOON_S_NR       6
 
 struct virtio_balloon_stat {
-	u16 tag;
-	u64 val;
+	__u16 tag;
+	__u64 val;
 } __attribute__((packed));
 
 #endif /* _LINUX_VIRTIO_BALLOON_H */
-- 
1.7.11.7

