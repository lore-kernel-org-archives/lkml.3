Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaICHcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:32:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9431 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaICHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:32:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c1-5406c40c222f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 2/3] integrity: move integrity subsystem options to a
 separate menu
Date: Wed, 03 Sep 2014 10:29:28 +0300
Message-id: <bce4893d9928b4c6ba9e69e8b4d858489acf6e9e.1409728926.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e/4FV2eI2whBqe+8Vrc+ruX2eLL0jqL
	lzPmsVtc3jWHzeJDzyM2i08rJjE7sHnsnHWX3ePBoc0sHrsXfGby6NuyitHj8ya5ANYoLpuU
	1JzMstQifbsEroyTOyaxFDwWqnj+ZTF7A+Ni/i5GTg4JAROJpetnsELYYhIX7q1n62Lk4hAS
	WMoo8altDSOE08kk0X72PRNIFZuAnsSG5h/sILaIQI7EpDMXmEFsZoF0iU+TesHiwgIREq0f
	2hlBbBYBVYn/B2eBxXkF4iS+7rsOtU1O4uSxyWA2p4CVxIbXO8FsIQFLiWWv1rDgEp/AyL+A
	kWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjofd3BuPSY1SFGAQ5GJR7eCEG2ECHWxLLi
	ytxDjBIczEoivL6JQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MHLnL71f2zmI28Ur00D3SkJm4
	K/HInSdzXf8s9J9Un3jpmIf4rTCzH4da3s8pZ/5pskAiyUDyedHNK+9qPJI3WZiGt14UK2Ks
	Nv11+XWe5ecZzY9tODSt82yv/biQ+oLj9ZrO/Zt37NtW5fqyetaRxecXTCq7WewsZi384Osd
	pW/Tes6Xnnh3VYmlOCPRUIu5qDgRANZFkRQbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrity subsystem got lots of options and takes more than half
of security menu.

This patch moves integrity subsystem options to a separate menu.
It does not affect existing configuration. Re-configuration is
not needed.

Changes in v2:
- previous patch moved integrity out of the 'security' menu.
  This version keeps integrity as a security option (Mimi).

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     | 14 ++++++++++++--
 security/integrity/evm/Kconfig |  9 +--------
 security/integrity/ima/Kconfig |  3 +--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index f79d853..a734a83 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -1,7 +1,13 @@
 #
 config INTEGRITY
-	def_bool y
-	depends on IMA || EVM
+	bool "Integrity subsystem support"
+	depends on SECURITY
+	default y
+
+if INTEGRITY
+
+menu "Options"
+
 
 config INTEGRITY_SIGNATURE
 	boolean "Digital signature verification using multiple keyrings"
@@ -46,3 +52,7 @@ config INTEGRITY_AUDIT
 
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
+
+endmenu
+
+endif   # if INTEGRITY
diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index d606f3d..df20a2f 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -1,6 +1,6 @@
 config EVM
 	boolean "EVM support"
-	depends on SECURITY
+	depends on INTEGRITY
 	select KEYS
 	select ENCRYPTED_KEYS
 	select CRYPTO_HMAC
@@ -12,10 +12,6 @@ config EVM
 
 	  If you are unsure how to answer this question, answer N.
 
-if EVM
-
-menu "EVM options"
-
 config EVM_ATTR_FSUUID
 	bool "FSUUID (version 2)"
 	default y
@@ -47,6 +43,3 @@ config EVM_EXTRA_SMACK_XATTRS
 	  additional info to the calculation, requires existing EVM
 	  labeled file systems to be relabeled.
 
-endmenu
-
-endif
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 08758fb..2477d1e 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -2,8 +2,7 @@
 #
 config IMA
 	bool "Integrity Measurement Architecture(IMA)"
-	depends on SECURITY
-	select INTEGRITY
+	depends on INTEGRITY
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
-- 
1.9.1

