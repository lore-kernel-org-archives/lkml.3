Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3EFMVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:21:03 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47364 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3EFMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:20:58 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org, amit.shah@redhat.com,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [PATCH V2 2/3] Documentation: virtio: Add emergency write (emerg_wr) config register in virtio console.
Date: Mon,  6 May 2013 17:49:50 +0530
Message-Id: <1367842791-30285-3-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
---
 Documentation/virtual/virtio-spec.txt |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
index 0d6ec85..3ca38f8 100644
--- a/Documentation/virtual/virtio-spec.txt
+++ b/Documentation/virtual/virtio-spec.txt
@@ -1927,11 +1927,16 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
     ports; configuration fields nr_ports and max_nr_ports are
     valid and control virtqueues will be used.
 
+  VIRTIO_CONSOLE_F_EMERG_WRITE(2) Device has support for emergency
+  write. Configuration filed emerg_wr is valid.
+
   Device configuration layout The size of the console is supplied
   in the configuration space if the VIRTIO_CONSOLE_F_SIZE feature
   is set. Furthermore, if the VIRTIO_CONSOLE_F_MULTIPORT feature
   is set, the maximum number of ports supported by the device can
-  be fetched.struct virtio_console_config {
+  be fetched. If VIRTIO_CONSOLE_F_EMERG_WRITE is set then one can
+  use emergency write to output single character without initializing
+  virtio queues. struct virtio_console_config {
 
 	u16 cols;
 
@@ -1941,6 +1946,7 @@ Ports 2 onwards only if VIRTIO_CONSOLE_F_MULTIPORT is set
 
 	u32 max_nr_ports;
 
+	u32 emerg_wr;
 };
 
   Device Initialization
-- 
1.7.9.5

