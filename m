Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaDWNaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:30:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaDWN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:51 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-71-5357c04ed8b1
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 09/20] evm: create '_evm' as a builtin 'trusted' keyring
Date: Wed, 23 Apr 2014 16:30:27 +0300
Message-id: <f793666712900a3d339371a54cb2fc1e24f48827.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7p+B8KDDX7s0bG49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mro2X2BreAHV8WXWwsZGxh7ObsYOTkkBEwkJrV+ZIGwxSQu
	3FvP1sXIxSEksJRRYt/VZewQTieTxM0b18Gq2AT0JDY0/2AHsUUEXCR2z+ljAiliFuhhlNj9
	ZzEzSEJYwEPi9+ztjCA2i4CqxMN9U9lAbF6BOIk/c1ZCrVOQWPZlLVg9p4CVxJ/m6WBDhQQs
	Jb5PmoxTfAIj/wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIeH4ZQfj4mNWhxgFOBiV
	eHgllocFC7EmlhVX5h5ilOBgVhLhXbIoPFiINyWxsiq1KD++qDQntfgQIxMHp1QDY+0MKQ3R
	/j+ZG6+Frlxcxau2Ns1b6pLbrLOCEu9XpDkGG7xt/8p7mc8gewPPZu5XN/6ecub9aFb9a6n8
	zOoPkaIsZ74JV9fND38qa7/leNkUb/ee/8++3RZkPrJtfmToTN7s7ZW5kdO0stasiqivPWds
	mZw+s8IsdVKrVOnsiY2W03i2HHJrV2Ipzkg01GIuKk4EAAKarFglAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require all keys added to the EVM keyring be signed by an
existing trusted key on the system trusted keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig    | 8 ++++++++
 security/integrity/evm/evm_main.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index df20a2f..3f9098c6 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -43,3 +43,11 @@ config EVM_EXTRA_SMACK_XATTRS
 	  additional info to the calculation, requires existing EVM
 	  labeled file systems to be relabeled.
 
+config EVM_TRUSTED_KEYRING
+	bool "Require all keys on the _evm keyring be signed"
+	depends on EVM && SYSTEM_TRUSTED_KEYRING
+	select INTEGRITY_TRUSTED_KEYRING
+	default n
+	help
+	   This option requires that all keys added to the _evm
+	   keyring be signed by a key on the system trusted keyring.
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 4c00adb..8a11920 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -447,6 +447,8 @@ static int __init init_evm(void)
 
 	evm_init_config();
 
+	integrity_init_keyring(INTEGRITY_KEYRING_EVM);
+
 	error = evm_init_secfs();
 	if (error < 0) {
 		pr_info("Error registering secfs\n");
-- 
1.8.3.2

