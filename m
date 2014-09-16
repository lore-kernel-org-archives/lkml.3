Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaIPVq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:46:56 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60183 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbaIPVqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:46:54 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:47 +0000
Message-Id: <1410910735-27929-11-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 10/18] usbip: Separate protocol/program version
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

Not all new program versions necessarily introduce
non-backwards-compatible protocol changes. We thus move the definition
of the protocol version from configure.ac to usbip_network.h, where it
logically belongs to.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/configure.ac        | 1 -
 tools/usb/usbip/src/usbip_network.c | 6 +++---
 tools/usb/usbip/src/usbip_network.h | 6 ++++++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/usb/usbip/configure.ac b/tools/usb/usbip/configure.ac
index 6a8156f..cee780e 100644
--- a/tools/usb/usbip/configure.ac
+++ b/tools/usb/usbip/configure.ac
@@ -2,7 +2,6 @@ dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
 AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
-AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
 
 CURRENT=0
 REVISION=1
diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
index f68741d..6e6216d 100644
--- a/tools/usb/usbip/src/usbip_network.c
+++ b/tools/usb/usbip/src/usbip_network.c
@@ -157,7 +157,7 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	op_common.version = USBIP_VERSION;
+	op_common.version = PROTOCOL_VERSION;
 	op_common.code    = code;
 	op_common.status  = status;
 
@@ -187,9 +187,9 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 
 	PACK_OP_COMMON(0, &op_common);
 
-	if (op_common.version != USBIP_VERSION) {
+	if (op_common.version != PROTOCOL_VERSION) {
 		dbg("version mismatch: %d %d", op_common.version,
-		    USBIP_VERSION);
+		    PROTOCOL_VERSION);
 		return -ERR_MISMATCH;
 	}
 
diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
index 151e815..942d1bb 100644
--- a/tools/usb/usbip/src/usbip_network.h
+++ b/tools/usb/usbip/src/usbip_network.h
@@ -13,6 +13,12 @@
 
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
2.1.0

