Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbbAUPHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:07:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37895 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbbAUPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:06:43 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7a-54bfbff0e631
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC...)
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] crypto: ccp: terminate ccp_support array with empty element
Date: Wed, 21 Jan 2015 18:06:31 +0300
Message-id: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xy7of9u8PMZiyhcti269HbBZzzrew
	WHS/krG4f+8nk8XlXXPYLI5M2cfqwObReukvm8eWlTeZPLYdUPXo27KK0ePzJrkA1igum5TU
	nMyy1CJ9uwSujBPbb7AV3GCpmDvpKFsD41fmLkZODgkBE4mH304zQdhiEhfurWfrYuTiEBJY
	yiix8PhLRginj0ni6+x5LCBVbAJ6Ev9mbWcDsUUEHjBKTGjyAbGZBXQkNl5rBZskLOAjselo
	MyuIzSKgKtH+6jdYL6+Am8TFOzsZIbbJSWy8s4J1AiP3AkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghgfFlB+PiY1aHGAU4GJV4eCtC94cIsSaWFVfmHmKU4GBWEuFdBQwrId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYwz9u9hOmNwKuj9xjOdM48baa8sm8Va0y66KX3ilU+MGRwOPw6o
	NObGLEnntV0TO3HhtH7+r/v2aEsoVLDnBxTJJ2tdi64Rcz+eyPzf6MfblPDJx12XHJVJD598
	N2dva98bsfU7crhi/0610OWddWF/BeOaKasdVmiVOzbeYN4jkhkVsaXnn5ESS3FGoqEWc1Fx
	IgCbDj2q6gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_match_cpu() expects array of x86_cpu_ids terminated
with empty element.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/crypto/ccp/ccp-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index c6e6171..ca29c12 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -583,6 +583,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 #ifdef CONFIG_X86
 static const struct x86_cpu_id ccp_support[] = {
 	{ X86_VENDOR_AMD, 22, },
+	{ },
 };
 #endif
 
-- 
2.2.1

