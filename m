Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbaDWNoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:44:01 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56746 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaDWN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:54 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-4f-5357c04ac7be
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 04/20] integrity: move integrity subsystem options to a
 separate menu
Date: Wed, 23 Apr 2014 16:30:22 +0300
Message-id: <88c75c3617ada0b70a84477d243eee0bb11d1806.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7peB8KDDa6+MrO49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mr4+HkfY8EBwYot65pYGhiX83UxcnJICJhITF51ig3CFpO4
	cG89kM3FISSwlFHi1ebPTCAJIYFOJonPrw1BbDYBPYkNzT/YQWwRAReJ3XP6mEAamAV6GCV2
	/1nMDJIQFgiXuHp9NthUFgFViZ/tyxlBbF6BOInNVx+yQGxTkFj2ZS1YPaeAlcSf5unsEMss
	Jb5PmoxTfAIj/wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIcH4ZQfj4mNWhxgFOBiV
	eHgllocFC7EmlhVX5h5ilOBgVhLhXbIoPFiINyWxsiq1KD++qDQntfgQIxMHp1QDY7jTQrn+
	/Off+RasyLSTfNjw8d2WgllSr0oOZftPtfP5aXTW0WHTjHtNmTV2kuc6jwX+s/Pl4Yudsk6x
	NH3ek3XiQn2OE6/8bXd/x/w28MgrHsVeI/eMdzLXit9zvmrbdXRtYNUv1Rm7bxpWCqVNqnq9
	corYzofJTXe/LHU/lXek79A1VbNp5UosxRmJhlrMRcWJAEwxSAskAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrity subsystem got lots of options and takes more than half
of security menu.

This patch moves integrity subsystem options to a separate menu.
It does not affect existing configuration. Re-configuration is
not needed.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Kconfig     | 11 ++++++++---
 security/integrity/evm/Kconfig |  9 +--------
 security/integrity/ima/Kconfig |  3 +--
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index f79d853..b16c9cd 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -1,7 +1,10 @@
 #
-config INTEGRITY
-	def_bool y
-	depends on IMA || EVM
+menuconfig INTEGRITY
+	bool "Integrity Subsystem"
+	depends on SECURITY
+	default y
+
+if INTEGRITY
 
 config INTEGRITY_SIGNATURE
 	boolean "Digital signature verification using multiple keyrings"
@@ -46,3 +49,5 @@ config INTEGRITY_AUDIT
 
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
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
index 81a2797..5f95e50 100644
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
1.8.3.2

