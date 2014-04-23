Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaDWN37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:29:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaDWN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:51 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-6d-5357c04dffff
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 08/20] ima: load x509 certificate from the kernel
Date: Wed, 23 Apr 2014 16:30:26 +0300
Message-id: <f0bc49cfbccd2bffc597f14c69e6590dc5d15d3d.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xq7q+B8KDDa4dtLa49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MpYdaKkYCp3RdPfLSwNjJs4uxg5OSQETCSuTellg7DFJC7c
	Ww9mCwksZZTY0WbaxcgFZHcySdy/sB8swSagJ7Gh+Qc7iC0i4CKxe04fE0gRs0APo8TuP4uZ
	QRLCAo4ST5vfgtksAqoSE9rWMoLYvAJxEpfmr2CB2KYgsezLWrAaTgEriT/N09khNltKfJ80
	Gaf4BEb+BYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCQvHLDsbFx6wOMQpwMCrx8Eos
	DwsWYk0sK67MPcQowcGsJMK7ZFF4sBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG9lvH0+0+lpyf
	KP6oUe2XVJMy88qs66xXt4i391+dm7v+3pptn+ffWBh1VZlp+ar0H3L1f5kn7p6ytW/jD+3t
	lrcnHDvFMHmZ32yG6Y6JYZP+JNm+X33wn8eqr35dSbXyodrrZZ4I1EtuaD5Y8WzCOseaX4uc
	pgpFFqXYLzUPtbrBmq7/4FGJkhJLcUaioRZzUXEiAP3h7rIjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide configuration option to load X509 certificate into the
_ima kernel keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig    | 9 +++++++++
 security/integrity/ima/ima_init.c | 1 +
 2 files changed, 10 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index be11c01..5474c47 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -131,3 +131,12 @@ config IMA_TRUSTED_KEYRING
 	help
 	   This option requires that all keys added to the _ima
 	   keyring be signed by a key on the system trusted keyring.
+
+config IMA_LOAD_X509
+	bool "Load X509 certificate to the '_ima' trusted keyring"
+	depends on IMA_TRUSTED_KEYRING
+	select INTEGRITY_LOAD_X509
+	default n
+	help
+	   This option enables X509 certificate loading from the kernel
+	   to the '_ima' trusted keyring.
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 515c1a2..c13d6a8 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -108,6 +108,7 @@ int __init ima_init(void)
 	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	ima_init_policy();
 	integrity_init_keyring(INTEGRITY_KEYRING_IMA);
+	integrity_load_x509(INTEGRITY_KEYRING_IMA, "/etc/keys/x509_ima.der");
 
 	return ima_fs_init();
 }
-- 
1.8.3.2

