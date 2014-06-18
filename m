Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966548AbaFRMlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:41:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44798 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966138AbaFRMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:41:49 -0400
X-AuditID: cbfee690-b7fb56d000003439-d7-53a1890bd9f7
From: Chanho Park <chanho61.park@samsung.com>
To: casey@schaufler-ca.com
Cc: james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] Smack: separate smackfstransmute and smackfsroot
Date: Wed, 18 Jun 2014 21:41:44 +0900
Message-id: <1403095304-15368-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkUJe7c2Gwwb82MYt7236xWVzer23R
	9zjI4vKuOWwWH3oesTmwenx8eovFo2/LKkaPo/sXsXl83iQXwBLFZZOSmpNZllqkb5fAlfHi
	dS9TwSbhigULPRoYv/N3MXJySAiYSPQducsKYYtJXLi3nq2LkYtDSGApo8SMPY+Yuhg5wIqW
	LxGDiE9nlHj+EaQBxGljkvg28QNYN5uArsSW568YQRpEBKQk1n0TBwkzC/QySqz/VgNiCws4
	Slx+8QusnEVAVWLxtu3sIDavgKfE7f+7WCCOkJM4eWwy2HwJgfdsEgeXbodqEJD4NvkQC8RB
	shKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIEBefrfswk7
	GO8dsD7EmAw0biKzlGhyPjCg80riDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBcenMF217zGtD5yh6rbvckC78WN1BVs3wWmuGfcr+nS5O0RwlHle7
	HuXNdVZy5bbZHOFS3PHigrTTunWNcWVVL1jiFsakuu3XzlMLSVp2o+nLgxAOg/av1RnSio6T
	us7Exn7p7vBf17viMHO9TNafU1Oz1Mpeaiw/deWv8eGzRX82rFzk3yGlxFKckWioxVxUnAgA
	hzhFRV4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQV3uzoXBBiu+8Vrc2/aLzeLyfm2L
	vsdBFpd3zWGz+NDziM2B1ePj01ssHn1bVjF6HN2/iM3j8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCGsaMF697mQo2CVcsWOjRwPidv4uRg0NCwERi+RKxLkZOIFNM
	4sK99WxdjFwcQgLTGSWef7zLCuG0MUl8m/iBFaSKTUBXYsvzV4wgzSICUhLrvomDhJkFehkl
	1n+rAbGFBRwlLr/4BVbOIqAqsXjbdnYQm1fAU+L2/10sEMvkJE4em8w6gZF7ASPDKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgcH8mvYNxVYPFIUYBDkYlHl6O3AXBQqyJZcWVuYcYJTiY
	lUR4jxUvDBbiTUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjAW80riDY1NzIwsjcwNLYyMzUkT
	VhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBccvkF4bvRbt+5QUJbY1LbVx+tW1R/qPL5Wse
	VL2Z+mn+k3Oib6XOz1a9Hj+n/E2u146LWxLbr6QFftpymctVhp3hcGLf+Xf73h3uEW9e1Gxy
	poYlY9F5swjWuw8KP7tbBv3+y2SZ+zJuwUGlvR5si47wZwWwG++cGWCZ++q2kSvD7m9+n04s
	2KfEUpyRaKjFXFScCADIldCpuwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to previous commit(e830b39: Smack: Add smkfstransmute mount option),
the smackfstransmute option is the smackfsroot option + transmute option.
I think it can be confused because the transmute option can only have "TRUE".
Before the patch, you cannot use the smackfsroot and the smackfstransmute at
the same time. If you use the options simultaenously, the previous option will
be omitted. In the below example, the smackfsroot option will be omitted.
mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=_ tmpfs /tmp

After the patch, now you can use the smackfstransmute option like below:
mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=TRUE tmpfs /tmp

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 Documentation/security/Smack.txt | 3 +++
 security/smack/smack.h           | 2 ++
 security/smack/smack_lsm.c       | 5 ++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index b6ef7e9..27290d8 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -669,6 +669,9 @@ Smack supports some mount options:
 	smackfsfloor=label: specifies a label to which all labels set on the
 	filesystem must have read access. Not yet enforced.
 
+	smackfstransmute=TRUE: assign a transmute option for the root of the
+	file system if it lacks the Smack extended attribute.
+
 These mount options apply to all file system types.
 
 Smack auditing
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 020307e..d4f75e6 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -146,6 +146,8 @@ struct smk_port_label {
 #define SMK_FSROOT	"smackfsroot="
 #define SMK_FSTRANS	"smackfstransmute="
 
+#define SMK_FSTRANS_ON	"TRUE"
+
 #define SMACK_CIPSO_OPTION 	"-CIPSO"
 
 /*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index f2c3080..7d3f40d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -450,9 +450,8 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 			}
 		} else if (strncmp(op, SMK_FSTRANS, strlen(SMK_FSTRANS)) == 0) {
 			op += strlen(SMK_FSTRANS);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_root = nsp;
+			if (strncmp(op, SMK_FSTRANS_ON,
+				    strlen(SMK_FSTRANS_ON)) == 0) {
 				transmute = 1;
 				specified = 1;
 			}
-- 
1.9.1

