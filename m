Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3BVFjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:39:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11609 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3BVFjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:39:43 -0500
X-AuditID: cbfee691-b7f556d000001a24-0d-5127049df2b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] lib: devres: Fix misplaced #endif
Date: Fri, 22 Feb 2013 14:39:40 +0900
Message-id: <000301ce10bf$028176c0$07846440$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QvwIQvVMe0phTShywU8x8ewbKvg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zQ925LOqBBg8OWVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mc6emsRZ8YK2YsXcTUwPjE5YuRk4OCQETiX/35rJD2GISF+6t
	Z+ti5OIQEljGKNH+ro8dpmhP114miMQiRokHSxezQDizmSR2TtrMBlLFJqAm8eXLYaAODg4R
	AX2JthYNEJNZwEXi6DQRkAphASOJVc/2MoLYLAKqEl+W/ADr5BWwlWhb8pIJwhaU+DH5Hthx
	zAJaEut3HmeCsOUlNq95ywwyUkJAXeLRX12QsIiAnsSsN/MYIUpEJPa9eMcIcpmEQDe7xLKF
	y9ghdglIfJt8iAWiV1Zi0wFmiLckJQ6uuMEygVFsFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4o
	TkovMtUrTswtLs1L10vOz93ECImTiTsY7x+wPsSYDLR+IrOUaHI+MM7ySuINjY1NzExMTcwt
	Tc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx68W5j0LW7s84OONlR+i6
	eEedmgPG5te2W01by6gRE1BlEXbvYOHlP8nLL53Q+Zj0/pLDmzxx/7zfFz0eek3imtr6cXei
	ls1qy1nCyT+Xc/7o3df0Zs1z1fwPthI3tasUH1zOvCwmsPefj8V+Wb4vHyQnXn9ze8eC1BuS
	9++EXd3ov+WhXtQUWSWW4oxEQy3mouJEAOj4rx+pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd25LOqBBgfum1tc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjHOnprEWfGCtmLF3E1MD
	4xOWLkZODgkBE4k9XXuZIGwxiQv31rN1MXJxCAksYpR4sHQxC4Qzm0li56TNbCBVbAJqEl++
	HGbvYuTgEBHQl2hr0QAxmQVcJI5OEwGpEBYwklj1bC8jiM0ioCrxZckPsE5eAVuJtiUvmSBs
	QYkfk++B3cAsoCWxfudxJghbXmLzmrfMICMlBNQlHv3VBQmLCOhJzHozjxGiRERi34t3jBMY
	BWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwFD6T2sG4ssHi
	EKMAB6MSD2+Di1qgEGtiWXFl7iFGCQ5mJRFe/VCgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDE0ReSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamBcvvpE
	942c/88rj/Cta/ttozEt8en8bdKTtrc1PY5+x+D2+vCftsB7C1JDJq6JrernqBNpWr0i46t4
	SvqUueYHD1pPWcGdwxNofrTGoOShqtfU1cWzfx/fvHbezJDDnSG7NzfzZufZTFt2Y+aM8jQ7
	vrurrcrCHua+yzp3T6c95JaavhqT50IBJZbijERDLeai4kQA4HsCHgYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A misplaced #endif causes link errors related to pcim_*() functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 lib/devres.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index 88ad759..8235331 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -227,6 +227,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
+#endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
 /*
@@ -432,4 +433,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif /* CONFIG_PCI */
-#endif /* CONFIG_HAS_IOPORT */
-- 
1.7.2.5


