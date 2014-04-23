Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaDWNvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:51:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8270 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaDWN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:53 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-74-5357c04fe58c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 10/20] evm: load x509 certificate from the kernel
Date: Wed, 23 Apr 2014 16:30:28 +0300
Message-id: <52664f56f6c3d8d1fdc4b771bc0a850d870ff5ef.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7r+B8KDDbb2Klnc+ruX2eJd028W
	i3XrFzNZXN41h83iQ88jNouXu76xW3xaMYnZgd3jwaHNLB4935M9Tq8s9ni/7yqbR9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGW0Tb3PWvCGq+LRt+OsDYzdnF2MnBwSAiYSF1euYYSwxSQu
	3FvP1sXIxSEksJRR4suD+YwQTieTxKwzh1lAqtgE9CQ2NP9gB7FFBFwkds/pYwIpYhboYZTY
	/WcxM0hCWMBR4vC8B2BjWQRUJV6v3MoKYvMKxEnsmbuWBWKdgsSyL2vB6jkFrCT+NE8HGyok
	YCnxfdJknOITGPkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJxy87GBcfszrEKMDB
	qMTDK7E8LFiINbGsuDL3EKMEB7OSCO+SReHBQrwpiZVVqUX58UWlOanFhxiZODilGhgN8xWN
	Hrx8p3hoW1hxxbfcOlM2Q8PvdVvtWWJLizaePJApVuFg8mvWO+b7YQfqN9YIhTptUni3MIPt
	qZ3mm8kimp1L76nKT3/0WvhWwKTTHw8tuVZ7+7NVccX/N9JM5st9G689itxnz3ZO9ojL/EVS
	r5+LMUeVLFht9CyM3039iBmv+4QlHDZKLMUZiYZazEXFiQCC3ITYJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide configuration option to load X509 certificate into the
_evm kernel keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig    | 9 +++++++++
 security/integrity/evm/evm_main.c | 1 +
 2 files changed, 10 insertions(+)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 3f9098c6..70d12f7 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -51,3 +51,12 @@ config EVM_TRUSTED_KEYRING
 	help
 	   This option requires that all keys added to the _evm
 	   keyring be signed by a key on the system trusted keyring.
+
+config EVM_LOAD_X509
+	bool "Load X509 certificate to the '_evm' trusted keyring"
+	depends on EVM_TRUSTED_KEYRING
+	select INTEGRITY_LOAD_X509
+	default n
+	help
+	   This option enables X509 certificate loading from the kernel
+	   to the '_evm' trusted keyring.
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 8a11920..0f1b489 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -448,6 +448,7 @@ static int __init init_evm(void)
 	evm_init_config();
 
 	integrity_init_keyring(INTEGRITY_KEYRING_EVM);
+	integrity_load_x509(INTEGRITY_KEYRING_EVM, "/etc/keys/x509_ima.der");
 
 	error = evm_init_secfs();
 	if (error < 0) {
-- 
1.8.3.2

