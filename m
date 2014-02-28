Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaB1PBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:01:42 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33799 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaB1PBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:39 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-19-5310a4d1ed18
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 6/8] evm: enable key retention service automatically
Date: Fri, 28 Feb 2014 16:59:30 +0200
Message-id: <43c402f0d4fbcf222f8d669ccf5d237059bd34fe.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7oXlwgEG7yYwWJxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugStjwqFtTAVL2CuaVn9gbGD8xdrFyMkhIWAicbptKQuELSZx
	4d56ti5GLg4hgaWMEqc2HYZyOpkkzm2fxwxSxSagJ7Gh+Qc7iC0i4Cyx6FY7K0gRs8BURolX
	t6aBjRIWcJHY0f4XrIhFQFXi+rmdbCA2r0CcxNs7h9kh1ilILPuyFmwop4CVxJbL98BOEhKw
	lLj6bC4bLvEJjPwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE49cdjEuPWR1iFOBg
	VOLhlVgkECzEmlhWXJl7iFGCg1lJhPfSYqAQb0piZVVqUX58UWlOavEhRiYOTqkGRskz4kaf
	zxg/5PnSE6PUOGX3rMzDmcLGDH81NqUbsnRPC3OXde4I2xp4YbHgirSWWf0vnvnpH/z+XemA
	x+JHaVF7FliavZvNrFL+QT7zrM5pEZsD2RtXRLDuUTT3eBZe/F6wWdpr35Tlu28HPLjtXvho
	L3voQdtIvv4bIs/Fdv/4vpd76pYfrEosxRmJhlrMRcWJAPxUA7IlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If keys are not enabled, EVM is not visible in the configuration menu.
It may be difficult to figure out what to do unless  you really know.

Other subsystems as NFS, CIFS select keys automatically.
This patch does the same.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 5aa9103..d35b491 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -1,9 +1,10 @@
 config EVM
 	boolean "EVM support"
-	depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
+	depends on SECURITY
+	select KEYS
+	select ENCRYPTED_KEYS
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
-	select ENCRYPTED_KEYS
 	default n
 	help
 	  EVM protects a file's security extended attributes against
-- 
1.8.3.2

