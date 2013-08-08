Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914Ab3HHJkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:40:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40985 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab3HHJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:40:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-fd-520367648b2a
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 10/16] iommu/exynos: remove custom fault handler
Date: Thu, 08 Aug 2013 18:39:48 +0900
Message-id: <002e01ce941b$394d2cf0$abe786d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF56Ec+VhGDh2S2aXDkvojSDaqQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZsW5KOnOQwentlhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOKC6blNSczLLUIn27BK6MZ62vWQs2aFTs+dLD1MDYptjFyMEhIWAi8WK7QhcjJ5ApJnHh
	3nq2LkYuDiGBZYwSm99cZIZImEgsa2lghkgsYpSYNvkKlPOXUeLFroMsIFVsAloSq+ceZwRJ
	iAj8ZpS49WwOK4jDLPCfSWLr7SZ2kCphAWeJR8da2EBsFgFVidlzt4Lt4BWwlHiw+x4LhC0o
	8WMyhM0MNHX9zuNMELa8xOY1b6FuUpDYcfY1I4gtIqAn8fXNJqgaEYl9L96BXSEhMJdDovPt
	IWaIZQIS3yYfYoF4WlZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQn
	pRcZ6xUn5haX5qXrJefnbmKERH//Dsa7B6wPMSYDrZ/ILCWanA9MHnkl8YbGZkYWpiamxkbm
	lmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYHT+deDP/OKAe4vr06ZJh/Gn
	9W2zmvi7Zv5GgYTY+jc7Ga8q+sZ9zju8ochitejp7avm1pd9yX3U4aX4ba19/aVn21/muL+a
	Yv9pJVeGlNMTg6uzdd7N+epW/PzrdYUQwb/6nsHvPP9vm9SfeTO6j73+zi7P4Gv/1rrOflrT
	dOD7U/ckl5Cbp2uUWIozEg21mIuKEwEL4xm8FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAd2UdOYggzXbTCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	xysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM561vmYt2KBRsedLD1MD
	Y5tiFyMnh4SAicSylgZmCFtM4sK99WxdjFwcQgKLGCWmTb7CDOH8ZZR4sesgC0gVm4CWxOq5
	xxlBEiICvxklbj2bwwriMAv8Z5LYeruJHaRKWMBZ4tGxFjYQm0VAVWL23K1gO3gFLCUe7L7H
	AmELSvyYDGEzA01dv/M4E4QtL7F5zVuomxQkdpx9zQhiiwjoSXx9swmqRkRi34t3jBMYBWYh
	GTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwcnkmtYNxZYPFIUYB
	DkYlHt6OAKYgIdbEsuLK3EOMEhzMSiK8F4uBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwP
	THx5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4ff0Ldang
	xJ4nH0t+bD9sL5BYF+x7r1b50+n5pwufrjOw0Wg7onHX2uXlq5nf/xdNkWFYH1Kp9+tjmPL9
	VXo7rF5qW+trTY8o31vu6C3X6fcwzMV1C3PIu3e/10ftMDH0OrQ/z1/Spea/x+xJCoubjTlk
	G8J1Vjrk7bi6J9jKY0bCUrn8AwJKLMUZiYZazEXFiQDz1z2zcgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes custom fault handler. The device drivers that
need to register fault handler can register
with iommu_set_fault_handler().

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   71 ++++++++++--------------------------------
 1 files changed, 17 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 88b9139..e8f3e82 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -131,16 +131,6 @@ enum exynos_sysmmu_inttype {
 	SYSMMU_FAULTS_NUM
 };
 
-/*
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @itype
- *                is SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
- */
-typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
-			unsigned long pgtable_base, unsigned long fault_addr);
-
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
 	REG_AR_FAULT_ADDR,
@@ -182,7 +172,6 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
-	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
 	void __iomem *sfrbases[0];
 };
@@ -318,34 +307,17 @@ finish:
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
-static void __set_fault_handler(struct sysmmu_drvdata *data,
-					sysmmu_fault_handler_t handler)
-{
-	unsigned long flags;
-
-	write_lock_irqsave(&data->lock, flags);
-	data->fault_handler = handler;
-	write_unlock_irqrestore(&data->lock, flags);
-}
-
-void exynos_sysmmu_set_fault_handler(struct device *dev,
-					sysmmu_fault_handler_t handler)
-{
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-
-	__set_fault_handler(data, handler);
-}
-
-static int default_fault_handler(enum exynos_sysmmu_inttype itype,
-		     unsigned long pgtable_base, unsigned long fault_addr)
+static void show_fault_information(const char *name,
+		enum exynos_sysmmu_inttype itype,
+		unsigned long pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
-			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+	pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
+		sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
 
 	ent = section_entry(__va(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
@@ -358,16 +330,12 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
 	pr_err("Generating Kernel OOPS... because it is unrecoverable.\n");
 
 	BUG();
-
-	return 0;
 }
 
 static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
 	enum exynos_sysmmu_inttype itype;
 	unsigned long addr = -1;
 
@@ -377,16 +345,17 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	WARN_ON(!is_sysmmu_active(data));
 
-	pdev = to_platform_device(data->sysmmu);
-	for (i = 0; i < (pdev->num_resources / 2); i++) {
-		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+	for (i = 0; i < data->nsfrs; i++) {
+		struct resource *irqres;
+		irqres = platform_get_resource(to_platform_device(data->sysmmu),
+						IORESOURCE_IRQ, i);
 		if (irqres && ((int)irqres->start == irq))
 			break;
 	}
 
 	clk_enable(data->clk_master);
 
-	if (i == pdev->num_resources) {
+	if (i == data->nsfrs) {
 		itype = SYSMMU_FAULT_UNKNOWN;
 	} else {
 		itype = (enum exynos_sysmmu_inttype)
@@ -402,19 +371,15 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 		ret = report_iommu_fault(data->domain, data->dev,
 				addr, itype);
 
-	if ((ret == -ENOSYS) && data->fault_handler) {
-		unsigned long base = data->pgtable;
-		if (itype != SYSMMU_FAULT_UNKNOWN)
-			base = __raw_readl(
-					data->sfrbases[i] + REG_PT_BASE_ADDR);
-		ret = data->fault_handler(itype, base, addr);
-	}
-
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
-	else
-		dev_dbg(data->sysmmu, "%s is not handled.\n",
-				sysmmu_fault_name[itype]);
+	else {
+		unsigned long ba = data->pgtable;
+		if (itype != SYSMMU_FAULT_UNKNOWN)
+			ba = __raw_readl(data->sfrbases[i] + REG_PT_BASE_ADDR);
+		show_fault_information(dev_name(data->sysmmu),
+					itype, ba, addr);
+	}
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
@@ -663,8 +628,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	__set_fault_handler(data, &default_fault_handler);
-
 	data->sysmmu = dev;
 	data->clk = devm_clk_get(dev, "sysmmu");
 	if (IS_ERR(data->clk)) {
-- 
1.7.2.5


