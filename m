Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaJCJKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:10:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8708 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaJCJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:07 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-05-542e67ecee21
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 4/4] integrity: do zero padding of the key id
Date: Fri, 03 Oct 2014 12:09:57 +0300
Message-id: <c95ac95640d3c0fc4394d538c826f4872bf150d8.1412327306.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7pv0vVCDD69s7C49Xcvs8W7pt8s
	Fl+W1lmsW7+YyWL2rocsFi9nzGO3uLxrDpvFh55HbBY3p11gsfi0YhKzA5fHzll32T2mnVjG
	4vHg0GYWj90LPjN59HxP9ni/7yqbx4oNJ5g9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK+PR
	4lOsBTdYK06/fsjWwPicpYuRk0NCwESi/cxcdghbTOLCvfVsXYxcHEICSxkltq3qhnI6mSTO
	zFsIVsUmoCexofkHO0hCROAoo8S0M9dZQRLMAukSnyb1ghUJC9hKTJjxjBHEZhFQlVi5+QvQ
	Og4OXoE4ievbQyG2yUmcPDYZrJVTwEpiy9UNbCC2kIClxPr+Fey4xCcw8i9gZFjFKJpamlxQ
	nJSea6RXnJhbXJqXrpecn7uJERLIX3cwLj1mdYhRgINRiYf3ww3dECHWxLLiytxDjBIczEoi
	vKfj9EKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MJofezQ9esmdSe8/Wf57fFexz1hE6/DudQaq
	GqnVvMtYX7sWvXvFuujNj7cavZumnTtwsOJGYZHnpq8aN3d+67o+x2PZhCPu3u1FolPTpbqv
	Nlpu3LFpU696/Nsn+93Yi2bPWx9hOWHq3vnH7atetK0UCfPb+8rveGJ7ZbKJ1OIX0zvDD7UV
	tTxSYinOSDTUYi4qTgQAIdbQRUICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest KEYS code return error if hexadecimal string length id odd.
Fix it.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/digsig_asymmetric.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 37e0d98..4fec181 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -28,7 +28,7 @@ static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
 	struct key *key;
 	char name[12];
 
-	sprintf(name, "id:%x", keyid);
+	sprintf(name, "id:%08x", keyid);
 
 	pr_debug("key search: \"%s\"\n", name);
 
-- 
1.9.1

