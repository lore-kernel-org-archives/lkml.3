Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaHEKtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaHEKtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:13 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c3-53e0b6a80f85
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 27/29] iommu: exynos: document internal structures
Date: Tue, 05 Aug 2014 12:47:55 +0200
Message-id: <1407235677-26324-28-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7ortj0INnhwS9zi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlbHj03+mgl8yFX+nnGdsYDwh3sXIySEhYCKx
	bvdSFghbTOLCvfVsXYxcHEICSxkl2uecZYVw+pgkHi+exQhSxSZgKNH1tgusSkSgl1Giv+kH
	E4jDLLCOVWJ/73WwWcICThIL905jA7FZBFQlvl3byAxi8wp4Siw81sUMsU9O4v/LFUwgNidQ
	/PDNA6wgtpCAh8TPDWvYJzDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREjtfdzAu
	PWZ1iFGAg1GJh1dh791gIdbEsuLK3EOMEhzMSiK8EmseBAvxpiRWVqUW5ccXleakFh9iZOLg
	lGpgPDu7ftbxMxcn82dGqqsu/ZL/0rR1x5NjP430PfmubKu4tkvCYcUuvxf2vVZCnF0y/P0z
	dAx0l9T/MGj7If1ywse7joZf2e9/d7Tp1r3Hs/HojRPSMhrTOsKfxW5r+GjVdZjVJXWHR1+D
	ZNq5hy6LnV3Dp5/W5dqx/+qT1Af+pxa5PYu+6/iES4mlOCPRUIu5qDgRADTWikJ7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few words of comment to all internal structures used by the driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 59 ++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7600861..78ce618 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -189,37 +189,54 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
 	"UNKNOWN FAULT"
 };
 
-/* attached to dev.archdata.iommu of the master device */
+/*
+ * This structure is attached to dev.archdata.iommu of the master device
+ * on device add, contains a list of SYSMMU controllers defined by device tree,
+ * which are bound to given master device. It is usually referenced by 'owner'
+ * pointer.
+ */
 struct exynos_iommu_owner {
-	struct list_head clients;
+	struct list_head clients; /* list of sysmmu_drvdata.owner_node */
 };
 
+/*
+ * This structure is stored in ->priv field of generic struct iommu_domain,
+ * contains list of SYSMMU controllers from all master devices, which has been
+ * attached to this domain and page tables of IO address space defined by this
+ * domain. It is usually referenced by 'domain' pointer.
+ */
 struct exynos_iommu_domain {
-	struct list_head clients; /* list of sysmmu_drvdata.node */
+	struct list_head clients; /* list of sysmmu_drvdata.domain_node */
 	sysmmu_pte_t *pgtable; /* lv1 page table, 16KB */
 	short *lv2entcnt; /* free lv2 entry counter for each section */
-	spinlock_t lock; /* lock for this structure */
+	spinlock_t lock; /* lock for modyfying list of clients */
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
 };
 
+/*
+ * This structure hold all data of a single SYSMMU controller, this includes
+ * hw resources like registers and clocks, pointers and list nodes to connect
+ * it to all other structures, internal state and parameters read from device
+ * tree. It is usually referenced by 'data' pointer.
+ */
 struct sysmmu_drvdata {
-	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *master;	/* Owner of system MMU */
-	void __iomem *sfrbase;
-	struct clk *clk;
-	struct clk *clk_master;
-	int activations;
-	int suspended;
-	spinlock_t lock;
-	struct iommu_domain *domain;
-	struct list_head domain_node;
-	struct list_head owner_node;
-	phys_addr_t pgtable;
-	int version;
-	const char *name;
-	dma_addr_t base;
-	size_t size;
-	struct notifier_block pm_notifier;
+	struct device *sysmmu; /* SYSMMU controller device */
+	struct device *master; /* master device (owner of given SYSMMU) */
+	void __iomem *sfrbase; /* our registers */
+	struct clk *clk; /* SYSMMU's clock */
+	struct clk *clk_master; /* master's device clock */
+	int activations; /* number of calls to sysmmu_enable */
+	int suspended; /* status of the controller (managed by runtime pm) */
+	spinlock_t lock; /* lock for modyfying enable/disable state */
+	struct iommu_domain *domain; /* domain we belong to */
+	struct list_head domain_node; /* node for domain clients list */
+	struct list_head owner_node; /* node for owner clients list */
+	phys_addr_t pgtable; /* assigned page table structure */
+	int version; /* our version */
+	const char *name; /* our name from device tree */
+	dma_addr_t base; /* base addres of IO address space define in DT */
+	size_t size; /* size of IO address space define in DT */
+	struct notifier_block pm_notifier; /* notifier for pm domain on/off */
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
-- 
1.9.2

