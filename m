Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaGFAif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:38:35 -0400
Received: from mail.eperm.de ([89.247.134.16]:53358 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaGFAie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:38:34 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: joe@perches.com, dan.carpenter@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, fengguang.wu@intel.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, aris@redhat.com
Subject: [PATCH 4/6] DRBG: Select correct DRBG core for stdrng
Date: Sun, 06 Jul 2014 02:25:04 +0200
Message-ID: <1740666.9OhPDPl60Q@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the DRBG is initialized, the core is looked up using the DRBG name.
The name that can be used for the lookup is registered in
cra_driver_name. The cra_name value contains stdrng.

Thus, the lookup code must use crypto_tfm_alg_driver_name to obtain the
precise DRBG name and select the correct DRBG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index dba5ed2..2a7860f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1761,7 +1761,7 @@ static int drbg_kcapi_init(struct crypto_tfm *tfm)
 	bool pr = false;
 	int coreref = 0;
 
-	drbg_convert_tfm_core(crypto_tfm_alg_name(tfm), &coreref, &pr);
+	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm), &coreref, &pr);
 	/*
 	 * when personalization string is needed, the caller must call reset
 	 * and provide the personalization string as seed information
-- 
1.9.3


