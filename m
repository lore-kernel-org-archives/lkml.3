Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab3DZLGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:06:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62164 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3DZLGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:06:36 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [PATCH 1/2] virtio: console: Add early writeonly register to config space
Date: Fri, 26 Apr 2013 16:34:55 +0530
Message-Id: <1366974299-17877-2-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a early_wr register (writeonly) in config space of virtio console device which can be used for debugging.

The patch also updates virtio-spec in Documentation to reflect this feature addition in virtio console.

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
---
 Documentation/virtual/virtio-spec.txt |   13 +++++++++++--
 include/uapi/linux/virtio_console.h   |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
index 0d6ec85..bc4e8b5 100644
--- a/Documentation/virtual/virtio-spec.txt
+++ b/Documentation/virtual/virtio-spec.txt
@@ -1927,11 +1927,18 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
     ports; configuration fields nr_ports and max_nr_ports are
     valid and control virtqueues will be used.
 
+  VIRTIO_CONSOLE_F_EARLY_WRITE(2) Device has support for early
+  write. Configuration field early_wr is valid.
+
   Device configuration layout The size of the console is supplied
   in the configuration space if the VIRTIO_CONSOLE_F_SIZE feature
   is set. Furthermore, if the VIRTIO_CONSOLE_F_MULTIPORT feature
   is set, the maximum number of ports supported by the device can
-  be fetched.struct virtio_console_config {
+  be fetched. If VIRTIO_CONSOLE_F_EARLY_WRITE is set then one can
+  use early write to output single character without initializing
+  virtio queues.
+
+  struct virtio_console_config {
 
 	u16 cols;
 
@@ -1941,7 +1948,9 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
 
 	u32 max_nr_ports;
 
-};
+	u32 early_wr;
+
+  };
 
   Device Initialization
 
diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ee13ab6..7cd84b5 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -38,6 +38,7 @@
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_EARLY_WRITE 2	/* Does host support early write? */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
@@ -48,6 +49,8 @@ struct virtio_console_config {
 	__u16 rows;
 	/* max. number of ports this device can hold */
 	__u32 max_nr_ports;
+	/* early write register */
+	__u32 early_wr;
 } __attribute__((packed));
 
 /*
-- 
1.7.9.5

