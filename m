Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AYOyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:54:40 -0500
Received: from mga07.intel.com ([143.182.124.22]:10387 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395Ab3AYOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:54:37 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: stable@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH 1/1] digsig: Fix memory leakage in digsig_verify_rsa()
Date: Fri, 25 Jan 2013 16:54:20 +0200
Message-Id: <783235259540e27e745f68316b1735e8d4ce9137.1359125652.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

digsig_verify_rsa() does not free kmalloc'ed buffer returned by
mpi_get_buffer().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: stable@vger.kernel.org
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
1.7.10.4

