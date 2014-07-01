Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbaGAPRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:17:13 -0400
Received: from mail.eperm.de ([89.247.134.16]:46437 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbaGAPRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:17:12 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] DRBG: Select correct DRBG core for stdrng
Date: Tue, 01 Jul 2014 17:07:28 +0200
Message-ID: <2048210.Q12HSlDxg7@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <36957559.tbJt1gJF6I@myon.chronox.de>
References: <36957559.tbJt1gJF6I@myon.chronox.de>
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
index 53ff20d..14495df 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1764,7 +1764,7 @@ static int drbg_kcapi_init(struct crypto_tfm *tfm)
 	bool pr = false;
 	int coreref = 0;
 
-	drbg_convert_tfm_core(crypto_tfm_alg_name(tfm), &coreref, &pr);
+	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm), &coreref, &pr);
 	/*
 	 * when personalization string is needed, the caller must call reset
 	 * and provide the personalization string as seed information
-- 
1.9.3


