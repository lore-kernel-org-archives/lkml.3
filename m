Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaJCLki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:40:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35316 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaJCLk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:40:28 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3b-542e8b29293c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 3/4] ima: ignore empty and with whitespaces policy lines
Date: Fri, 03 Oct 2014 14:40:20 +0300
Message-id: <17424574b1e414071a32cb36f72eadee69b5f793.1412336062.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4VV3Nbr0QgwundC1u/d3LbPFlaZ3F
	yxnz2C0u75rDZvGh5xGbxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bcvlNsBRPYK3ZcesDUwPiCtYuRk0NCwETi/P/zzBC2mMSFe+vZuhi5OIQE
	ljJK3Hv6kwnC6WSS+H/rPlgHm4CexIbmH+wgtohAjsSkMxfAupkF0iU+TeoFiwsLeEtceXyE
	DcRmEVCVmLq2hQnE5hWIk9g+6z0jxDY5iZPHJgPN5ODgFLCSWNfnDxIWErCU6Lz6gA2H8ARG
	/gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLuyw7GxcesDjEKcDAq8fB+vKEbIsSa
	WFZcmXuIUYKDWUmEV7pJL0SINyWxsiq1KD++qDQntfgQIxMHp1QDY2fA0xsXV/Z1PnK4Hr1z
	+4xnDifM/5g9C2e55Faief2O+/dJsq9ei/T+YV58vM4h3MPMKkdylUNXZfT5pwxf+vgv7naW
	+Gdx55Ns+4Wc2at5luYGO/Ic0w4/ZNJaxhJg6um5eMZx76awO47izZI3frI7Kj5WUC/rT6o5
	KFAUtPHZL3vu3rALSizFGYmGWsxFxYkAiMhVfRkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty policy lines cause parsing failures which is, especially
for new users, hard to spot. This patch prevents it.

It is now possible to 'cat policy > <securityfs>/ima/policy'.

Changes in v2:
* strip leading blanks and tabs in rules to prevent parsing failures

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index bf232b9..d2c47d4 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -696,8 +696,9 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	p = strsep(&rule, "\n");
 	len = strlen(p) + 1;
+	p += strspn(p, " \t");
 
-	if (*p == '#')
+	if (*p == '#' || *p == '\0')
 		return len;
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
-- 
1.9.1

