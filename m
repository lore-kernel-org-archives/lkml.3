Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3HBXOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:14:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33349 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3HBXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:14:03 -0400
Message-ID: <1375485238.32477.41.camel@what-is-leg>
Subject: [PATCH] drivers/crypto/nx: saves chaining value from co-processor
From: Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.hengli.com.au, mhcerri@linux.vnet.ibm.com
Date: Fri, 02 Aug 2013 18:13:58 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080223-3620-0000-0000-000003CC0899
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chaining value from co-processor was not being saved. This value is
needed because it is used as the IV, for example by cts(cbc(aes)).

Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 35d483f..a2f99a9 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -95,6 +95,7 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
        if (rc)
                goto out;

+       memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
        atomic_inc(&(nx_ctx->stats->aes_ops));
        atomic64_add(csbcpb->csb.processed_byte_count,
                     &(nx_ctx->stats->aes_bytes));
-- 
1.7.10.4


