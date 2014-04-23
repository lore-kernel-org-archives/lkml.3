Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaDWNoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:44:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56746 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaDWN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:54 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-4b-5357c04a8cb7
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 03/20] ima: move asymmetric keys config option
Date: Wed, 23 Apr 2014 16:30:21 +0300
Message-id: <34575ff06cf564319195273a5890540d3653019d.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4VV2vA+HBBk/bOS1u/d3LbPGu6TeL
	xbr1i5ksLu+aw2bxoecRm8XLXd/YLT6tmMTswO7x4NBmFo+e78kep1cWe7zfd5XNo2/LKkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDI6V9sVrOKtmPx8J1sD432uLkZODgkBE4lje64zQ9hiEhfu
	rWfrYuTiEBJYyihxfvEXdpCEkEAnk8Tn14YgNpuAnsSG5h9gcREBF4ndc/qYQBqYBXoYJXb/
	WQw2SVjATmL6pg9Akzg4WARUJR6ciAEJ8wrESWy4c5YFYpmCxLIva8HKOQWsJP40T4faZSnx
	fdJknOITGPkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJxC87GBcfszrEKMDBqMTD
	K7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZODilGhg1izjF+MXW
	VhqfU/t9vvbABM3z1j9qjt1qWDO9aIKsYNxpZX6dn4lLtu4Xdm3ceJf5v4Kv0NIHU/axbCuL
	mTV3Hd+q1V5de5975+qpP6+wm8wm/Pbe0WM+/BEc57Qbj/FceX7hrXFZrphIcst7vXbh6+az
	vf9fm6TA4/X23b5lk7oO/Xjso3tHiaU4I9FQi7moOBEA5dDbVSICAAA=
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
1.8.3.2

