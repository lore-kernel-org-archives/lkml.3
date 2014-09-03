Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaICHdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:33:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64504 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaICHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:32:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bd-5406c40b1c9c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 1/3] integrity: move asymmetric keys config option
Date: Wed, 03 Sep 2014 10:29:27 +0300
Message-id: <f7354395cac7332e34102ecc3f6ca9fcaceccb78.1409728926.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e/4FV3uI2whBrOeylnc+ruX2eLL0jqL
	lzPmsVtc3jWHzeJDzyM2i08rJjE7sHnsnHWX3ePBoc0sHrsXfGby6NuyitHj8ya5ANYoLpuU
	1JzMstQifbsEroyZl16xF6zgrZg7oZ25gfEuVxcjJ4eEgInE/zf7WCBsMYkL99azdTFycQgJ
	LGWU2DbjHTuE08kk0XHlFzNIFZuAnsSG5h/sILaIQI7EpDMXwOLMAukSnyb1gsWFBVwldj/4
	BWazCKhKXN73Acjm4OAViJM4N9EQYpmcxMljk1lBbE4BK4kNr3eC2UIClhLLXq1hwSU+gZF/
	ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQwPu6g3HpMatDjAIcjEo8vBGCbCFCrIll
	xZW5hxglOJiVRHh9E4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGA99Pdnc7ui5uLPs01EN76nH
	tNWOXRL8Y8n5YurKRby6hi0n/k07fOZJiJ7STskA77Ci01tX++zZkmv/z+fmN9N5287c/mG7
	/np0iPXHjv1p577/THvr3fLjdzWP5Mybct35E7t/b9Nn0ajmOe/bsaTjxBGxYGWTjE17eq6J
	rdZ4/eOJ7ovXN4KVWIozEg21mIuKEwFDGXRbGgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better visual appearance it is better to co-locate
asymmetric key option together with signature support.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 245c6d9..f79d853 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,6 +17,18 @@ config INTEGRITY_SIGNATURE
 	  This is useful for evm and module keyrings, when keys are
 	  usually only added from initramfs.
 
+config INTEGRITY_ASYMMETRIC_KEYS
+	boolean "Enable asymmetric keys support"
+	depends on INTEGRITY_SIGNATURE
+	default n
+        select ASYMMETRIC_KEY_TYPE
+        select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+        select PUBLIC_KEY_ALGO_RSA
+        select X509_CERTIFICATE_PARSER
+	help
+	  This option enables digital signature verification using
+	  asymmetric keys.
+
 config INTEGRITY_AUDIT
 	bool "Enables integrity auditing support "
 	depends on INTEGRITY && AUDIT
@@ -32,17 +44,5 @@ config INTEGRITY_AUDIT
 	  be enabled by specifying 'integrity_audit=1' on the kernel
 	  command line.
 
-config INTEGRITY_ASYMMETRIC_KEYS
-	boolean "Enable asymmetric keys support"
-	depends on INTEGRITY_SIGNATURE
-	default n
-        select ASYMMETRIC_KEY_TYPE
-        select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-        select PUBLIC_KEY_ALGO_RSA
-        select X509_CERTIFICATE_PARSER
-	help
-	  This option enables digital signature verification using
-	  asymmetric keys.
-
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
-- 
1.9.1

