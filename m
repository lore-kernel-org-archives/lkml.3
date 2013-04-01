Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3DASCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:02:36 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64537 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab3DASCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:02:35 -0400
Message-ID: <1364839353.21627.70.camel@x61.thuisdomein>
Subject: [PATCH 7/8] virtio_console: do not export "u32" to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Amit Shah <amit.shah@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 20:02:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 18:02:33.0632 (UTC) FILETIME=[15BB3200:01CE2F03]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_console.h exports "u32" to userspace. Use "__u32" instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with a kernel build.

1) Again. I'm guessing userspace doesn't use VIRTIO_CONSOLE_BAD_ID.

 include/uapi/linux/virtio_console.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ee13ab6..c312f16 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -39,7 +39,7 @@
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
 
-#define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
+#define VIRTIO_CONSOLE_BAD_ID		(~(__u32)0)
 
 struct virtio_console_config {
 	/* colums of the screens */
-- 
1.7.11.7

