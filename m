Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaICHYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:24:05 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22683 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbaICHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:27 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f8-5406c1eca331
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 6/8] ima: remove unnecessary code
Date: Wed, 03 Sep 2014 10:19:59 +0300
Message-id: <b698bd0778ead0491205b0fda4bf5ed6c67ecec3.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Vd03B9lCDK7P1rO49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBmd2/YwFUxlq/g5VbiBcQ5rFyMnh4SAicSbJ18ZIWwxiQv31rN1MXJxCAks
	ZZSYeOYwE4TTySTxauMrdpAqNgE9iQ3NP8BsEYEciUlnLjCD2MwC6RKfJvWCxYUFDCXu3PwM
	NpVFQFVizexnLCA2r0CcxItnPSwQ2+QkTh6bDHQFBwengJXEvKNaIGEhAUuJ9qvLGHEIT2Dk
	X8DIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJOi+7GBcfMzqEKMAB6MSD2+BGluIEGti
	WXFl7iFGCQ5mJRFe30SgEG9KYmVValF+fFFpTmrxIUYmDk6pBsZ1q6X36qkvzjx1ataD3jn/
	Xgv88pUP7mEIqddYI2GoIMF7f/qMcP0H84K+/r1xcVWwwzdz99WyR5lcLXiX5b6NdrE1ZC66
	L7Dn5kH9V02Xr7w6fvlsw/7VTZO84sqbuooKfj2fczI8c99ZW21D1ZeckZ+P3j4TnO049WdU
	ytfikJAjPIsfLVuoxFKckWioxVxUnAgAtuVNfhgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ima_appraise is 0, then action would not mandate to perform
appraisal and ima_appraise_measurement will never be called.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_appraise.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 225fd94..013ec3f 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -192,8 +192,6 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	int rc = xattr_len, hash_start = 0;
 
-	if (!ima_appraise)
-		return 0;
 	if (!inode->i_op->getxattr)
 		return INTEGRITY_UNKNOWN;
 
-- 
1.9.1

