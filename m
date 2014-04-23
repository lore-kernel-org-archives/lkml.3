Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaDWN6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:58:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaDWN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:48 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-4a-5357c04927db
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 02/20] integrity: initialize EVM before IMA
Date: Wed, 23 Apr 2014 16:30:20 +0300
Message-id: <0c4156691df646d7db0764a651ec08950a3d7e81.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7qeB8KDDZZNkrK49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo4Nuc2Y8FL1oobb84zNTC+Y+li5OSQEDCRWP1iHpQtJnHh
	3nq2LkYuDiGBpYwS767tZIZwOpkkzj/cwApSxSagJ7Gh+Qc7iC0i4CKxe04fE0gRs0APo8Tu
	P4uZQRLCAtYSF/bcZAKxWQRUJeZ37QGL8wrESRy8MZURYp2CxLIva8HinAJWEn+ap4MNFRKw
	lPg+aTJO8QmM/AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITjlx2Mi49ZHWIU4GBU
	4uGVWB4WLMSaWFZcmXuIUYKDWUmEd8mi8GAh3pTEyqrUovz4otKc1OJDjEwcnFINjBZcK347
	ZNgdPPmXOejFEmetB797LA5s35Me0jql3CV2S0qAXvrRolXlnP2Tdp2XnJ2zcXGU+//9W6ad
	rdl1k9/r5Y3Wx7sk+GKTztVuPRa22qdD4/H0OVOuW7pM6VVKCDf65vrnblj6xia1iW7uwlfL
	5WQeL52u2D2xYsWZWZf65nKt05s8J02JpTgj0VCLuag4EQBRFSKjJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize EVM before IMA to prevent appraisal failure when reading
EVM X509 certificate and HMAC key.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index 0793f48..2e17590 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 
 integrity-y := iint.o
 
-subdir-$(CONFIG_IMA)			+= ima
-obj-$(CONFIG_IMA)			+= ima/
 subdir-$(CONFIG_EVM)			+= evm
 obj-$(CONFIG_EVM)			+= evm/
+subdir-$(CONFIG_IMA)			+= ima
+obj-$(CONFIG_IMA)			+= ima/
-- 
1.8.3.2

