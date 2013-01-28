Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3A1Q6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:58:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56032 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3A1Q6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:58:48 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Dave Howells <dhowells@redhat.com>
Subject: [PATCH 11/15] Add EFI signature data types
Date: Mon, 28 Jan 2013 11:42:35 -0500
Message-Id: <1359391359-25783-12-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Howells <dhowells@redhat.com>

Add the data types that are used for containing hashes, keys and certificates
for cryptographic verification.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/efi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1ae16b6..de7021d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -388,6 +388,12 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_FILE_SYSTEM_GUID \
     EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define EFI_CERT_SHA256_GUID \
+    EFI_GUID(  0xc1c41626, 0x504c, 0x4092, 0xac, 0xa9, 0x41, 0xf9, 0x36, 0x93, 0x43, 0x28 )
+
+#define EFI_CERT_X509_GUID \
+    EFI_GUID(  0xa5c059a1, 0x94e4, 0x4aa7, 0x87, 0xb5, 0xab, 0x15, 0x5c, 0x2b, 0xf0, 0x72 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -523,6 +529,20 @@ typedef struct {
 
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
+typedef struct  {
+	efi_guid_t signature_owner;
+	u8 signature_data[];
+} efi_signature_data_t;
+
+typedef struct {
+	efi_guid_t signature_type;
+	u32 signature_list_size;
+	u32 signature_header_size;
+	u32 signature_size;
+	u8 signature_header[];
+	/* efi_signature_data_t signatures[][] */
+} efi_signature_list_t;
+
 /*
  * All runtime access to EFI goes through this structure:
  */
-- 
1.8.0.2

