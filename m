Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaIRJrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:47:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8515 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaIRJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:46:59 -0400
X-AuditID: cbfee690-f79ce6d00000115a-44-541aaa0d3c5f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, gregkh@linuxfoundation.org, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] regmap: fix NULL pointer dereference in regmap_get_val_endian
Date: Thu, 18 Sep 2014 15:12:20 +0530
Message-id: <1411033340-5524-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWyRsSkWpd3lVSIwZevwhZTHz5hs2hevJ7N
	4vKuOWwWn47+Z7VYtPULuwOrx6ZVnWwe++euYffo27KK0ePzJrkAligum5TUnMyy1CJ9uwSu
	jOm337AW9AtUtL/Yx97AOIu3i5GTQ0LAROL49JNsELaYxIV764FsLg4hgaWMEv9vz2XsYuQA
	K/p3tA4iPp1R4vCmU4wQzgQmiZk/9oJ1swnoSjx5P5cZxBYRUJDY3PuMFcRmFiiSmHJsJQuI
	LSzgJ7Hw00RGEJtFQFViyZEfYDavgLtEV+c+qGUKEnMm2YDMlxB4zSbRvfMfM0S9gMS3yYdY
	IGpkJTYdYIY4WlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAzL0/+e
	TdjBeO+A9SFGAQ5GJR5eCQGpECHWxLLiytxDjKZAGyYyS4km5wODP68k3tDYzMjC1MTU2Mjc
	0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw6vqn3bvLy6XNWle+eeOvUFi4B
	x95ujlXn5Ls92jd9StWf62J6xTywf7VHqv6qe11Pn7q6fQxNPKX+LHKdzbFqo7PPvG58WfBe
	qOG6rPAu5t7fR2VlWsOT8yRX+xbwxEixPLfR23vm1L1TG6oW7lPU0Hjxf1tQroZHROEyriZ5
	/YZfRWUW05RYijMSDbWYi4oTAXd5sVZGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQV3eVVIhBnOaeSymPnzCZtG8eD2b
	xeVdc9gsPh39z2qxaOsXdgdWj02rOtk89s9dw+7Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBnTb79hLegXqGh/sY+9gXEWbxcjB4eEgInEv6N1XYyc
	QKaYxIV769m6GLk4hASmM0oc3nSKEcKZwCQx88deNpAqNgFdiSfv5zKD2CICChKbe5+xgtjM
	AkUSU46tZAGxhQX8JBZ+msgIYrMIqEosOfIDzOYVcJfo6tzHCLFYQWLOJJsJjNwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgQH/TOpHYwrGywOMQpwMCrx8B7glQoRYk0sK67MPcQo
	wcGsJML7ayFQiDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnAiMwriTc0NjE3NTa1NLEwMbNU
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cC4evfMp4KRP64r+rRM0rb5YxogwFLvIzH5p+X6
	2CtBsx88dF3EpyW+QvKU+MWOfdp2idoROpxbPavM3U/PeV1zrnWr35lHSUbJvW+dXveUTTvJ
	ESZziz1g/mR3t5eHWpXkdR2Nu+y3SyrXr1533naitdDmKyziurP6V6XyLji57KVIRdIL5/dK
	LMUZiYZazEXFiQCpDpzOkAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recents commits for getting reg endianness causing NULL pointer
dereference if dev is passed NULL in regmap_init_mmio. This patch
fixes this issue, and allows to parse reg endianness only if dev
and dev->of_node exist.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index f2281af..455a877 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -477,7 +477,7 @@ static enum regmap_endian regmap_get_val_endian(struct device *dev,
 					const struct regmap_bus *bus,
 					const struct regmap_config *config)
 {
-	struct device_node *np = dev->of_node;
+	struct device_node *np;
 	enum regmap_endian endian;
 
 	/* Retrieve the endianness specification from the regmap config */
@@ -487,15 +487,20 @@ static enum regmap_endian regmap_get_val_endian(struct device *dev,
 	if (endian != REGMAP_ENDIAN_DEFAULT)
 		return endian;
 
-	/* Parse the device's DT node for an endianness specification */
-	if (of_property_read_bool(np, "big-endian"))
-		endian = REGMAP_ENDIAN_BIG;
-	else if (of_property_read_bool(np, "little-endian"))
-		endian = REGMAP_ENDIAN_LITTLE;
+	/* If the dev and dev->of_node exist try to get endianness from DT */
+	if (dev && dev->of_node) {
+		np = dev->of_node;
 
-	/* If the endianness was specified in DT, use that */
-	if (endian != REGMAP_ENDIAN_DEFAULT)
-		return endian;
+		/* Parse the device's DT node for an endianness specification */
+		if (of_property_read_bool(np, "big-endian"))
+			endian = REGMAP_ENDIAN_BIG;
+		else if (of_property_read_bool(np, "little-endian"))
+			endian = REGMAP_ENDIAN_LITTLE;
+
+		/* If the endianness was specified in DT, use that */
+		if (endian != REGMAP_ENDIAN_DEFAULT)
+			return endian;
+	}
 
 	/* Retrieve the endianness specification from the bus config */
 	if (bus && bus->val_format_endian_default)
-- 
1.7.9.5

