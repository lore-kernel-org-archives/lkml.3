Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3JIMeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:34:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51815 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3JIMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:34:17 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-20-52554ccc58a4
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
Subject: [PATCH V2] PCI: designware: Add irq_create_mapping()
Date: Wed, 09 Oct 2013 21:32:12 +0900
Message-id: <000a01cec4eb$942dc7f0$bc8957d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7E65P+964MocGsTVqEJWzUSf+QDw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zke4Zn9Agg5s/tC3+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFiqat
	jBY/d81jsXj6oInJovHoA1aL1icPGB0EPX7/msTo8WTTRUaPnbPusnss2FTq8X3hfHaPvi2r
	GD2e/tjL7HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgy3l94wViwXbpi1aVVTA2MDWJdjJwc
	EgImEvOn7WSGsMUkLtxbz9bFyMUhJLCMUeLNxJ9sMEWdr1ugEtMZJTb2T4VyfjFK7J6znhWk
	ik1ATeLLl8PsILaIgKbE7BVbmECKmAXusEj83jcDrEhYwFbiWO9OoCIODhYBVYm5h/1AwrxA
	4dn7d7BC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX12IVXoS8653skOUiEjs
	e/GOEWSthMAWDomv3XPBZrIICEh8m3yIBaJXVmLTAaiPJSUOrrjBMoFRbBaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhJCRN3MN4/YH2IMRlo/URmKdHkfGBK
	ySuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY30R
	z/JpS620Ehjn3v+0Z8q3RW7C70WjGUP2bfknuKX5nW5Q4HaFnu70RbcDkntvrf/2ynOxi+mC
	pY3XCxlWdgs2d5SUmzyc/vBUcqTxpFMem9L5WEPniTFrb9nB3Myqfqes+SvvIz4OlrrrCz7N
	yW9KqPs1hW/azOX2z5Z82ea9vUz5xwK570osxRmJhlrMRcWJAL9fkPkfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jQd0zPqFBBqt/qFj8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLFU1b
	GS1+7prHYvH0QROTRePRB6wWrU8eMDoIevz+NYnR48mmi4weO2fdZfdYsKnU4/vC+ewefVtW
	MXo8/bGX2eP4je1MHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zHh/4QVjwXbpilWXVjE1MDaIdTFyckgImEh0vm5hg7DFJC7cWw9kc3EICUxnlNjYPxXK+cUo
	sXvOelaQKjYBNYkvXw6zg9giApoSs1dsYQIpYha4wyLxe98MsCJhAVuJY707gYo4OFgEVCXm
	HvYDCfMChWfv38EKYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3UhVulJzLve
	yQ5RIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM44TyT3sG4qsHiEKMAB6MSD+8D/pAgIdbEsuLK3EOMEhzMSiK8vhahQUK8KYmVValF+fFF
	pTmpxYcYk4H+nMgsJZqcD0yGeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAyOqdFbMzYFWdutX0EywPfs6zePpc0aej5/r3sHl8QebeNyZfCDvgf2BibdHm
	r0+Xb3R7d9Xp6Atn5bCW51d2BS50zynfeW7CQv3ahcoXbuRMEV95b5pCqdJmvqV+1QsreZf5
	+4WJa/6Zfb+rxqPuvXpG8SeNZMX1ttnLWHQUVP5eerRK8yjDbiWW4oxEQy3mouJEANETOcJ8	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

Without irq_create_mapping(), the correct irq number cannot be
provided. In this case, it makes problems such as NULL deference.
Thus, irq_create_mapping() should be added for MSI.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Suggested-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5440.

 drivers/pci/host/pcie-designware.c |   25 +++++++++++++------------
 drivers/pci/host/pcie-designware.h |    2 +-
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 8963017..92d58fd 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -157,7 +157,7 @@ static struct irq_chip dw_msi_irq_chip = {
 void dw_handle_msi_irq(struct pcie_port *pp)
 {
 	unsigned long val;
-	int i, pos;
+	int i, pos, irq;
 
 	for (i = 0; i < MAX_MSI_CTRLS; i++) {
 		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS + i * 12, 4,
@@ -165,8 +165,9 @@ void dw_handle_msi_irq(struct pcie_port *pp)
 		if (val) {
 			pos = 0;
 			while ((pos = find_next_bit(&val, 32, pos)) != 32) {
-				generic_handle_irq(pp->msi_irq_start
-					+ (i * 32) + pos);
+				irq = irq_find_mapping(pp->irq_domain,
+						i * 32 + pos);
+				generic_handle_irq(irq);
 				pos++;
 			}
 		}
@@ -237,9 +238,8 @@ static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)
 		}
 	}
 
-	irq = (pp->msi_irq_start + pos0);
-
-	if ((irq + no_irqs) > (pp->msi_irq_start + MAX_MSI_IRQS-1))
+	irq = irq_find_mapping(pp->irq_domain, pos0);
+	if (!irq)
 		goto no_valid_irq;
 
 	i = 0;
@@ -270,6 +270,7 @@ static void clear_irq(unsigned int irq)
 	struct irq_desc *desc;
 	struct msi_desc *msi;
 	struct pcie_port *pp;
+	struct irq_data *data = irq_get_irq_data(irq);
 
 	/* get the port structure */
 	desc = irq_to_desc(irq);
@@ -280,7 +281,7 @@ static void clear_irq(unsigned int irq)
 		return;
 	}
 
-	pos = irq - pp->msi_irq_start;
+	pos = data->hwirq;
 
 	irq_free_desc(irq);
 
@@ -371,8 +372,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
 	u32 val;
-
-	struct irq_domain *irq_domain;
+	int i;
 
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
@@ -441,15 +441,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
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
 
-		pp->msi_irq_start = irq_find_mapping(irq_domain, 0);
+		for (i = 0; i < MAX_MSI_IRQS; i++)
+			irq_create_mapping(pp->irq_domain, i);
 	}
 
 	if (pp->ops->host_init)
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index faccbbf..1bf9fc5 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -47,7 +47,7 @@ struct pcie_port {
 	u32			lanes;
 	struct pcie_host_ops	*ops;
 	int			msi_irq;
-	int			msi_irq_start;
+	struct irq_domain	*irq_domain;
 	unsigned long		msi_data;
 	DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
 };
-- 
1.7.10.4


