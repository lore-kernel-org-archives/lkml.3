Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaB0FC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:02:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21025 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaB0FC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:02:26 -0500
X-AuditID: cbfee68e-b7f566d000002344-9b-530ec6e0151b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
        "=?ISO-8859-1?Q?'Pali_Roh=E1r'?=" <pali.rohar@gmail.com>,
        "'Juha Yrjola'" <juha.yrjola@solidboot.com>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
In-reply-to: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
Subject: [PATCH 2/5] hwrng: omap3-rom: Use devm_clk_get()
Date: Thu, 27 Feb 2014 14:02:24 +0900
Message-id: <003f01cf3379$1a5ee600$4f1cb200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zeMUulUPjKSZTQeuQ54WfZho3FgAAA5kw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zQ92Hx/iCDXbZWXS/krG4vPASq8W7
	G0+ZLC7vmsNmMfH0byaL/Ve8HNg8vn2dxOKxc9Zddo9tB1Q9+rasYvRY+Podm8fnTXIBbFFc
	NimpOZllqUX6dglcGdvfH2QvOM9eMentXfYGxu1sXYwcHBICJhJLWhS6GDmBTDGJC/fWA4W5
	OIQEljFK/Nhwkg0iYSLRMrWLFSKxiFHi3prHUM5vRom+RwfYQarYBNQkvnw5DGaLCOhJ9K1v
	ZAQpYha4yCgx88oKsISQgK3Es0lLwMZyCthJTJiwjgXkDGEBS4nlb6tBwiwCqhIvDrazgoR5
	gco3XzcBCfMKCEr8mHyPBcRmFtCR2N86jQ3ClpfYvOYtM8Qz6hKP/upCXGAkce7XcagSEYl9
	L96BXSMh8JZdYvqEqUwQqwQkvk0+xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaS
	FQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihMRs3w7GmwesDzEmA62fyCwlmpwPjPm8
	knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBo6J7F
	cuz0jscus/6eWhTRxnZ/q/GOjVs0Fjg+3Hjw/8OumEyNFQ8TerQLrdf6OE+K6PuqdsR7HnfL
	uyfLz9ck83/xmitxgb9u1qyWMHPTi68unCo56qZVv2Kqmz4ny0MNt46Znm/2xgY/bHyc8Wi7
	7/eqLb8Xr/DeqLpCvvNBUV1sqPP0WUETlViKMxINtZiLihMBm3Yyu+8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd0Hx/iCDU6vs7TofiVjcXnhJVaL
	dzeeMllc3jWHzWLi6d9MFvuveDmweXz7OonFY+esu+we2w6oevRtWcXosfD1OzaPz5vkAtii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbH9/kL3gPHvFpLd32RsYt7N1
	MXJySAiYSLRM7WKFsMUkLtxbDxTn4hASWMQocW/NY1YI5zejRN+jA+wgVWwCahJfvhwGs0UE
	9CT61jcyghQxC1xklJh5ZQVYQkjAVuLZpCVgKzgF7CQmTFjH0sXIwSEsYCmx/G01SJhFQFXi
	xcF2VpAwL1D55usmIGFeAUGJH5PvsYDYzAI6Evtbp7FB2PISm9e8ZQYplxBQl3j0VxfiAiOJ
	c7+OQ5WISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECE4Kz6R3MK5qsDjEKMDBqMTD+0OXL1iINbGsuDL3EKMEB7OSCO8hF6AQb0piZVVqUX58
	UWlOavEhxmSgPycyS4km5wMTVl5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1ML
	UotgtjBxcEo1MFp+n3NZ887t/7NcUix/TNr1+vzE/LNPNBJ5Kg/MaHYPMuJyrvqpJNdztd4y
	g7X4uPh1icm5t0VjDq7av2LH9obpD0JC1/wRqjjQ2aqz7hP3RXOvBys89n1insuTfVKn+uW9
	+b27hCdITedeFHxG7u6usPTV1zedbr4RopBo0esR5LroXorOvjwlluKMREMt5qLiRADLH5EI
	TgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/omap3-rom-rng.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index c853e9e..6f2eaff 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -103,7 +103,7 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 	}
 
 	setup_timer(&idle_timer, omap3_rom_rng_idle, 0);
-	rng_clk = clk_get(&pdev->dev, "ick");
+	rng_clk = devm_clk_get(&pdev->dev, "ick");
 	if (IS_ERR(rng_clk)) {
 		pr_err("unable to get RNG clock\n");
 		return PTR_ERR(rng_clk);
@@ -120,7 +120,6 @@ static int omap3_rom_rng_remove(struct platform_device *pdev)
 {
 	hwrng_unregister(&omap3_rom_rng_ops);
 	clk_disable_unprepare(rng_clk);
-	clk_put(rng_clk);
 	return 0;
 }
 
-- 
1.7.10.4


