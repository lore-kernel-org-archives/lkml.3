Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3J2Gx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:53:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55525 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3J2Gxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:53:53 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-ec-526f5b804c3e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: introduce CONFIG_F2FS_CHECK_FS for BUG_ON control
Date: Tue, 29 Oct 2013 15:53:11 +0900
Message-id: <1383029592-17477-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA92G6PwggyOdEhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZZy/to+t4Adrxe8N
	M5gaGB+zdDFyckgImEh8uTYVyhaTuHBvPVsXIxeHkMAyRonP128zwxSt+/eMBSIxnVGi8VsX
	lNPMJDH31m/GLkYODjYBbYnN+w1AGkQEmCUWTD3PCFLDLDCBUeL/ovdgK4QFfCS+dF1kBbFZ
	BFQlPv6dxQTSyyvgLnH5rg7EMm2Jbc8ngvVKCNxnk5i28RE7RL2AxLfJh1hA6iUEZCU2HYA6
	TlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAnBvh2MNw9YH2JMBho3
	kVlKNDkfGMJ5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoFRX3jZw+4le1zLJ8h2WKVyTpix8/UztmVzfFa5mwkrpRZc8v+e9fSr96tzQmHrLjgs
	Dvxm/cx0mtPEuQ/bm550KRiavYo6FV8SGibZUrPUuuLBPbutZ+bx/H8/8/veQzcYT7asj7wc
	KcK4QcJE/ZuO13urCl2ZQL/ug0er/zy8PsV9wpGsb4tclFiKMxINtZiLihMBa87X3VcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2G6Pwgg/NLRSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4f20fW8EP1orfG2YwNTA+Zuli5OSQEDCRWPfvGZQtJnHh3nq2LkYuDiGB
	6YwSjd+6WCCcZiaJubd+M3YxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9B5skLOAj
	8aXrIiuIzSKgKvHx7ywmkF5eAXeJy3d1IJZpS2x7PpFxAiP3AkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBAf5MegfjqgaLQ4wCHIxKPLwWbPlBQqyJZcWVuYcYJTiYlUR4dwQDhXhT
	EiurUovy44tKc1KLDzEmAy2fyCwlmpwPjL68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamAU/2+i0yYRueI3p/uGmKWsPOdD27KzVXwnmRj8l7SdGpm3yNnJ
	uaWHdaZ0+tOsDuNJX85mVR/e5y/XurBz9c+vCpP+a1zYWjvn2CXzbNZf8dXq6jXa3tIzSzzN
	VqXZLBPe+3zDv9Xxe3dJBOqkBpldWx+f/Cc6VdZsCsfGJd8ucItsEePIZFFiKc5INNRiLipO
	BAA1RqKItAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config will support an option to remove so many BUG_ONs that degrade
the performance potentially.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
index e06e099..214fe10 100644
--- a/fs/f2fs/Kconfig
+++ b/fs/f2fs/Kconfig
@@ -63,3 +63,11 @@ config F2FS_FS_SECURITY
 	  the extended attribute support in advance.
 
 	  If you are not using a security module, say N.
+
+config F2FS_CHECK_FS
+	bool "F2FS consistency checking feature"
+	depends on F2FS_FS
+	help
+	  Enables BUG_ONs which check the file system consistency in runtime.
+
+	  If you want to improve the performance, say N.
-- 
1.8.4.474.g128a96c

