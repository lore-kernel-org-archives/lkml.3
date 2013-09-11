Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3IKQGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:06:25 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:38858 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209Ab3IKQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:55 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>, Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, devel@driverdev.osuosl.org
Subject: [PATCH 10/11] staging: usbip: Separate protocol/program version
Date: Wed, 11 Sep 2013 18:06:56 +0200
Message-Id: <1378915617-29791-11-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
References: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
 <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all new program versions necessarily introduce
non-backwards-compatible protocol changes. We thus move the definition
of the protocol version from configure.ac to usbip_network.h, where it
logically belongs to.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/configure.ac        | 1 -
 drivers/staging/usbip/userspace/src/usbip_network.c | 6 +++---
 drivers/staging/usbip/userspace/src/usbip_network.h | 6 ++++++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 7bba496..099d24b 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -2,7 +2,6 @@ dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
 AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
-AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
 
 CURRENT=0
 REVISION=1
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index 61cd8db..f5955c2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -153,7 +153,7 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	op_common.version = USBIP_VERSION;
+	op_common.version = PROTOCOL_VERSION;
 	op_common.code    = code;
 	op_common.status  = status;
 
@@ -183,9 +183,9 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 
 	PACK_OP_COMMON(0, &op_common);
 
-	if (op_common.version != USBIP_VERSION) {
+	if (op_common.version != PROTOCOL_VERSION) {
 		dbg("version mismatch: %d %d", op_common.version,
-		    USBIP_VERSION);
+		    PROTOCOL_VERSION);
 		return -ERR_MISMATCH;
 	}
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index d3c1b71..6a41fd8 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -14,6 +14,12 @@
 
 #include <stdint.h>
 
+/*
+ * Protocol version. Incremented only on non-backwards-compatible
+ * changes.
+ */
+#define PROTOCOL_VERSION 0x111
+
 extern int usbip_port;
 extern char *usbip_port_string;
 extern char *usbip_srp_password;
-- 
1.8.4

