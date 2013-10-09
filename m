Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3JIIKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:10:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3JIIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:10:12 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-fd-52550f328915
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 17:09:21 +0900
Message-id: <000401cec4c6$dc415180$94c3f480$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Extwbs09DEKhMT+CyRFEgzGK6CA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zka4Rf2iQwYV7vBZ/Jx1jt1jSlGHx
	8pCmxfwj51gtLi+8xGrRu+Aqm8WFpz1sFpd3zWGzODvvOJvFjPP7mCw2Tv3FaNF+SdliRdNW
	Roufu+axWDx90MRk0Xj0AatF65MHjA6CHr9/TWL0eLLpIqPHzll32T0WbCr1+L5wPrtH35ZV
	jB5Pf+xl9jh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZ0w88YS74KlBxtP0OawPjX94uRk4O
	CQETiUmv17BD2GISF+6tZ+ti5OIQEljGKLHz6QkmmKKVd1tYIRLTGSXaP69jhHB+MUo0HFoL
	VsUmoCbx5cthsFEiApoSs1dsYQIpYha4wyLxe98MoHYODmEBK4kFf7NAalgEVCXWXd3DCGLz
	CthKrHi1hx3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCBjJATUJR791YVYpSex4MANZogS
	EYl9L96B3SYhsIdDYuOjScwQuwQkvk0+xALRKyux6QAzxGOSEgdX3GCZwCg2C8nmWUg2z0Ky
	eRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihKSEiTsY7x+wPsSYDLR+IrOUaHI+
	MKXklcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR
	WoRP1vQsw/zjV4RUG/1durhvcflGz65RdGljXWHk3833f2LVd0nHXTYzJYV+m6R9fmWUySpc
	/ulPF+t/xUkRrDFKXAxRV1r7y94VNKeoT/zw/8ZN05Sk1id7ts6RnfGaUY9j3VN16QrZHaxl
	CRUGfw841Cc++/5Rt25XqZa2s2KtzXe+FCWW4oxEQy3mouJEAHSDaukfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jQV0j/tAgg9WX2S3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAPlFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYx
	Zkw/8IS54KtAxdH2O6wNjH95uxg5OSQETCRW3m1hhbDFJC7cW8/WxcjFISQwnVGi/fM6Rgjn
	F6NEw6G1TCBVbAJqEl++HGYHsUUENCVmr9jCBFLELHCHReL3vhlAozg4hAWsJBb8zQKpYRFQ
	lVh3dQ8jiM0rYCux4tUedghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg4yREFCXePRXF2KV
	nsSCAzeYIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBCecZ9I7GFc1WBxiFOBgVOLhfcAfEiTEmlhWXJl7iFGCg1lJhPcwZ2iQEG9KYmVV
	alF+fFFpTmrxIcZkoEcnMkuJJucDk2FeSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tS
	s1NTC1KLYLYwcXBKNTBKW7BZnf+XfuPqRKeE4pCnb86dmVBlZ13J3qyz4+raHW639JSLZ17I
	aK+oONK+8Qlf+F1hbaPLltO77u7NCSviyJn66c/xK3MSZE6zTngdu+629Ed338613le+FE5/
	7relxSXV4O66oweNHT1YNxaZbd/28trCgvlfJbkZEyaL3s5h4RBMTr+rxFKckWioxVxUnAgA
	XOhJ9nwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without irq_create_mapping(), the correct irq number cannot be
provided. In this case, it makes problem such as NULL deference.
Thus, irq_create_mapping() should be added for MSI.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
---
Tested on Exynos5440.

 drivers/pci/host/pcie-designware.c |   10 ++++------
 drivers/pci/host/pcie-designware.h |    1 +
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 8963017..e536bb6 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -237,6 +237,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
 		}
 	}
 
+	pp->msi_irq_start = irq_create_mapping(pp->irq_domain, 0);
+
 	irq = (pp->msi_irq_start + pos0);
 
 	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
@@ -372,8 +374,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	struct of_pci_range_parser parser;
 	u32 val;
 
-	struct irq_domain *irq_domain;
-
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
 		return -EINVAL;
@@ -441,15 +441,13 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	}
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		irq_domain = irq_domain_add_linear(pp->dev->of_node,
+		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
 					MAX_MSI_IRQS, &msi_domain_ops,
 					&dw_pcie_msi_chip);
-		if (!irq_domain) {
+		if (!pp->irq_domain) {
 			dev_err(pp->dev, "irq domain init failed\n");
 			return -ENXIO;
 		}
-
-		pp->msi_irq_start = irq_find_mapping(irq_domain, 0);
 	}
 
 	if (pp->ops->host_init)
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index faccbbf..240fc11 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -50,6 +50,7 @@ struct pcie_port {
 	int			msi_irq_start;
 	unsigned long		msi_data;
 	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
+	struct irq_domain	*irq_domain;
 };
 
 struct pcie_host_ops {
-- 
1.7.10.4


