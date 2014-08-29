Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaH2PDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:03:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14151 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaH2PDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:03:07 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e5-540096285218
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: r.krypa@samsung.com, havner@gmail.com, m.lis@samsung.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH 2/3] Fix a bidirectional UDS connect check typo
Date: Fri, 29 Aug 2014 17:02:54 +0200
Message-id: <1409324575-12057-2-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
References: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4NV2NaQwhBnMPmFjc2/aLzeL/ax2L
	vsdBFmcmLWSyuLxrDpvFh55HbBZ3D75lsXg7aQWzxfkL59gdOD12zrrL7nFtd6THx6e3WDz6
	tqxi9Di6fxGbx+dNcgFsUVw2Kak5mWWpRfp2CVwZFzv+MRfcZ6+4e3slawPjBrYuRk4OCQET
	icubv0PZYhIX7q0Hsrk4hASWMkrs+3aDGcLpZZI4sXw6WBWbgIHE9wt7wRIiAs1MEjO2rWAC
	STAL6ElMWrKbBcQWFrCXmLp0BSOIzSKgKnF/+T9mEJtXwF3i4uIbrBDr5CR6t70Bi3MKeEhc
	uPkFLC4EVPNp0TLWCYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNzXHYxLj1kd
	YhTgYFTi4X2RwRAixJpYVlyZe4hRgoNZSYR33QSgEG9KYmVValF+fFFpTmrxIUYmDk6pBkbd
	PC6fL0vumZ/Ojjz6uM3Sfc/6nlu3WKf7eS53EfsfEvy04qDWhqVz+FJYfvdJcinkF9xcmMn3
	+/lbwdJy2wP3dcxmn+Q9PP9/YUfNfPeyA9Fvm249Enwy9ae1tLOygfQkjXX31Gt3GzWpB6hE
	rC5t/jn1xg7l/lmmF8ynW2kt/ybwIWmVzQclluKMREMt5qLiRADJ6IPhFgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 54e70ec5eb090193b03e69d551fa6771a5a217c4 commit introduced a
bidirectional check that should have checked for mutual WRITE access
between two labels. Due to a typo the second check was incorrect.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 security/smack/smack_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 478d99e..00443a9 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3302,8 +3302,8 @@ static int smack_unix_stream_connect(struct sock *sock,
 		rc = smk_bu_note("UDS connect", skp, okp->smk_known,
 					MAY_WRITE, rc);
 		if (rc == 0) {
-			rc = smk_access(okp, okp->smk_known, MAY_WRITE, NULL);
-			rc = smk_bu_note("UDS connect", okp, okp->smk_known,
+			rc = smk_access(okp, skp->smk_known, MAY_WRITE, NULL);
+			rc = smk_bu_note("UDS connect", okp, skp->smk_known,
 						MAY_WRITE, rc);
 		}
 	}
-- 
1.9.3

