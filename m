Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3EFMU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:20:56 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52237 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3EFMUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:20:52 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org, amit.shah@redhat.com,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [PATCH V2 1/3] virtio: console: Add emergency writeonly register to config space
Date: Mon,  6 May 2013 17:49:49 +0530
Message-Id: <1367842791-30285-2-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an emerg_wr register (writeonly) in config space
of virtio console device which can be used for debugging.

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/uapi/linux/virtio_console.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ee13ab6..3fd0dce 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -38,6 +38,7 @@
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_EMERG_WRITE 2 /* Does host support emergency write? */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
@@ -48,6 +49,8 @@ struct virtio_console_config {
 	__u16 rows;
 	/* max. number of ports this device can hold */
 	__u32 max_nr_ports;
+	/* emergency write register */
+	__u32 emerg_wr;
 } __attribute__((packed));
 
 /*
-- 
1.7.9.5

