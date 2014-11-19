Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaKSWco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:32:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbaKSUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.17 032/141] crypto: qat - Prevent dma mapping zero length assoc data
Date: Wed, 19 Nov 2014 12:50:55 -0800
Message-Id: <20141119205151.698077659@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tadeusz Struk <tadeusz.struk@intel.com>

commit 923a6e5e5f171317ac8bb462ac4b814fa7880d3c upstream.

Do not attempt to dma map associated data if it is zero length.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Tested-by: Nikolay Aleksandrov <nikolay@redhat.com>
Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/qat/qat_common/qat_algs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -650,6 +650,8 @@ static int qat_alg_sgl_to_bufl(struct qa
 		goto err;
 
 	for_each_sg(assoc, sg, assoc_n, i) {
+		if (!sg->length)
+			continue;
 		bufl->bufers[bufs].addr = dma_map_single(dev,
 							 sg_virt(sg),
 							 sg->length,


