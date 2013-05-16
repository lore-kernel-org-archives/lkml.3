Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3EPQon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3EPQok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:44:40 -0400
Date: Thu, 16 May 2013 19:44:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_console: fix uapi header
Message-ID: <20130516164410.GA31985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uapi should use __u32 not u32.
Fix a macro in virtio_console.h which uses u32.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
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
MST
