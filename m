Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3AYKTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:19:15 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:39477 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536Ab3AYKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:19:13 -0500
Message-ID: <51025C1F.8050600@linux-ipv6.org>
Date: Fri, 25 Jan 2013 19:19:11 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: dmitry.kasatkin@intel.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
CC: yoshfuji@linux-ipv6.org
Subject: [PATCH] digsig: Fix memory leakage in digsig_verify_rsa().
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

digsig_verify_rsa() does not free kmalloc'ed buffer returned by
mpi_get_buffer().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 lib/digsig.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/digsig.c b/lib/digsig.c
index 8c0e629..dc2be7e 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key *key,
 	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
+	kfree(p);
+
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
 	if (err)
 		goto err;
-- 
1.7.9.5

