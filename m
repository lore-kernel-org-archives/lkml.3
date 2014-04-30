Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaD3B4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:56:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56576 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD3B4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:56:45 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-1e-5360585ce76e
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] mfd: syscon: allow property as NULL in
 syscon_regmap_lookup_by_phandle
Date: Wed, 30 Apr 2014 11:14:26 +0900
Message-id: <1398824066-3036-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t8zA92YiIRggyMTOCzufz3KaHF51xw2
	i0Vbv7BbnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx+Mgc9oLD
	HBUvu7IbGBvYuxg5OSQETCTe337BCmGLSVy4t56ti5GLQ0hgGaPElr5/rDBFn873MUEkFjFK
	vJw/kx3CaWOSuLx5M1gVm4CuxJP3c5lBbBEBBYnNvc+A4hwczAJREpsOO4GEhQUiJV70NzOC
	2CwCqhIPJ74Ds3kF3CUOn1vNAlIuAdQ6Z5INyHgJgcdsEp/mbGODqBeQ+Db5EFSNrMSmA8wQ
	t0lKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCFhOGEH470D1ocYk4HG
	TWSWEk3OB4ZxXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwCq49yDDLg+EqG9drHc3PSU7cLkGLUve/9K9gveVW82q39Em29ZKbBO5kKrrVrDh1
	Z6LImekh300FJyrbbZJ+25rmfneqlmKS22Ql6cthzk9tb1SU60pfqDYIrQt7e0VWXtM+dHXQ
	/unXU7MnCN4tWLbso7MvF2PwEwHXvwKZF6Z1Bdoo93ErsRRnJBpqMRcVJwIATbobA1kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jAd2YiIRgg6XTWCzufz3KaHF51xw2
	i0Vbv7BbnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYsfjIHPaCwxwVL7uyGxgb2LsYOTkkBEwkPp3vY4KwxSQu3FvP1sXI
	xSEksIhR4uX8mewQThuTxOXNm1lBqtgEdCWevJ/LDGKLCChIbO59BhTn4GAWiJLYdNgJJCws
	ECnxor+ZEcRmEVCVeDjxHZjNK+AucfjcahaQcgmg1jmTbCYwci9gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzkz6R2MK5ssDjEKMDBqMTDK7A1PliINbGsuDL3EKMEB7OSCC9zQEKw
	EG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OBEZhXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYytX4rL/pufXeWSWvj7560fGQs2zfT33yoi81S9zdzYOHbq
	bd3Um7xRcc3vz04Km31+OaN6367f9aXJd44z+jhNkk//3HLmSdDM1/xPzomtS2yN+63weHHu
	7L6Mr7nVi/sXLy58zb7hR/cJu/Me62KkQuK8f3yLyb5jd2GBD/uejPuyNeWNPDOVWIozEg21
	mIuKEwHRf38ltgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass syscon device node itself as first parameter to this function
there is no need to parse and find syscon device node. So by allowing
"property" parameter as NULL allow syscon_regmap_lookup_by_phandle to
consider passed argument "np" itself as a syscon device node "syscon_np".
This will help us in avoiding addition of "syscon" property in a device node
which points back to same device node in device tree.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/mfd/syscon.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index dbea55d..b30f941 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -94,7 +94,11 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 	struct device_node *syscon_np;
 	struct regmap *regmap;
 
-	syscon_np = of_parse_phandle(np, property, 0);
+	if (property)
+		syscon_np = of_parse_phandle(np, property, 0);
+	else
+		syscon_np = np;
+
 	if (!syscon_np)
 		return ERR_PTR(-ENODEV);
 
-- 
1.7.10.4

