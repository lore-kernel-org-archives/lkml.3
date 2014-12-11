Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbaLKC6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:58:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32467 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaLKC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:58:37 -0500
X-AuditID: cbfee68f-f791c6d000004834-48-548908584b0a
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: catalin.marinas@arm.com, Will.Deacon@arm.com, heiko@sntech.de,
        Li.Xiubo@freescale.com, shc_work@mail.ru, p.zabel@pengutronix.de,
        nicoleotsuka@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        robh+dt@kernel.org, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net
Cc: padma.v@samsung.com, alsa-devel@alsa-project.org, shawn.guo@freescale.com,
        bcousson@baylibre.com, tony@atomide.com, kernel@pengutronix.de,
        kgene@kernel.org, kesavan.abhilash@gmail.com, pawel.moll@arm.com
Subject: [PATCH 1/2] lib: devres: add a helper function for ioremap_wc
Date: Thu, 11 Dec 2014 08:28:45 +0530
Message-id: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkRjeCozPE4NpjA4srFw8xWfyddIzd
	4s78v6wW75f1MFo8OdDOaHHgzw5Gi+bF69ks/j96zWqxaupOFos1f5Us+h+/ZrbovNDBanF5
	1xw2i1e9N9gt7t47wWLx++Z3NosJ09eyWLTuPcJusayljcVi0g4pi/1XvCxefjzB4iDmseFz
	E5vHmnlrGD1+/5rE6PHt6yQWj/c3Wtk9/h3uZ/LYOesuu8emVZ1sHneu7WHz2D93DbvH4r7J
	rB5T5h5h9ej/a+DRt2UVo8f2a/OYPT5vkgsQiOKySUnNySxLLdK3S+DKuPr7GGPBPuGKJZPm
	sjUwPufvYuTkkBAwkTg2tZMJwhaTuHBvPVsXIxeHkMBSRoklrx6ywRS9mXWPHcQWEljEKDGt
	PQ+iqI9J4sD+NrAEm4CexIJ/X5lBEiICK5kkXr37xwjiMAtcZpToWPSQFaRKWMBN4vvHw2Ad
	LAKqEs9+XQKL8wq4SjQ17wNq4ABapyAxZ5INSK+EwB4OicO/7jFD1AtIfJt8iAWiRlZi0wFm
	iOskJQ6uuMEygVFwASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAqD3971n/Dsa7B6wP
	MQpwMCrx8K642h4ixJpYVlyZe4jRFGjDRGYp0eR8YGrIK4k3NDYzsjA1MTU2Mrc0UxLnXSj1
	M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo0p7ZvCeovSO47Jn5NyD8lt5px9xjZ7a4+W+
	d+Easz3fqlaWqS5qERI6oyHr7Mxm8e7N+bh9V84+tr5qkhHJnGpbIi8UnC858c1FnydKC5nT
	F/bwfDim2ysUwHz7Peveim/5nvdzbx5bFK3L36I0iVdFdJHug7tNLXyn0zcwPLq8WiFI0vuB
	EktxRqKhFnNRcSIAGZgmadUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG4ER2eIwa1DqhZXLh5isvg76Ri7
	xZ35f1kt3i/rYbR4cqCd0eLAnx2MFs2L17NZ/H/0mtVi1dSdLBZr/ipZ9D9+zWzReaGD1eLy
	rjlsFq96b7Bb3L13gsXi983vbBYTpq9lsWjde4TdYllLG4vFpB1SFvuveFm8/HiCxUHMY8Pn
	JjaPNfPWMHr8/jWJ0ePb10ksHu9vtLJ7/Dvcz+Sxc9Zddo9NqzrZPO5c28PmsX/uGnaPxX2T
	WT2mzD3C6tH/18Cjb8sqRo/t1+Yxe3zeJBcgENXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDDAUlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGENY8bV38cYC/YJVyyZNJetgfE5fxcjJ4eEgInEm1n32CFsMYkL99azgdhCAosY
	Jaa153UxcgHZfUwSB/a3gRWxCehJLPj3lRkkISKwkkni1bt/jCAOs8BlRomORQ9ZQaqEBdwk
	vn88DNbBIqAq8ezXJbA4r4CrRFPzPqAGDqB1ChJzJtlMYORewMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4JTyT3sG4qsHiEKMAB6MSD2/A5fYQIdbEsuLK3EOMEhzMSiK8STc6QoR4
	UxIrq1KL8uOLSnNSiw8xmgItn8gsJZqcD0xXeSXxhsYm5qbGppYmFiZmlkrivEr2bSFCAumJ
	JanZqakFqUUwfUwcnFINjI4zt8f9vfZJ2vsKU9khjoMBCoc1Ig+ZWdTZHI/6dsiOc/9hwbXR
	yYt6LzKoaP+eXnpcTl14golW7pFbj+MjzO3dzksXm6bbHdbqzp904Vlf3cYlD+9EskXu+p3v
	Gvc2JktRU1jIf+/lH0rGJVt3Ked+6Z/pwDj1UUL7mk1sj4OvpOZo3d9npsRSnJFoqMVcVJwI
	AIDR6BUfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a resource managed writecombine ioremap function.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 Documentation/driver-model/devres.txt |    1 +
 include/linux/io.h                    |    2 ++
 lib/devres.c                          |   28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index b5ab416..0f80cee 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -274,6 +274,7 @@ IOMAP
   devm_ioport_unmap()
   devm_ioremap()
   devm_ioremap_nocache()
+  devm_ioremap_wc()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
   devm_iounmap()
   pcim_iomap()
diff --git a/include/linux/io.h b/include/linux/io.h
index fa02e55..42b33f0 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -64,6 +64,8 @@ void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   resource_size_t size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				   resource_size_t size);
+void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
+				   resource_size_t size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
diff --git a/lib/devres.c b/lib/devres.c
index 0f1dd2e..e8e1738 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -72,6 +72,34 @@ void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 EXPORT_SYMBOL(devm_ioremap_nocache);
 
 /**
+ * devm_ioremap_wc - Managed ioremap_wc()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ *
+ * Managed ioremap_wc().  Map is automatically unmapped on driver detach.
+ */
+void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
+			   resource_size_t size)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_wc(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_wc);
+
+/**
  * devm_iounmap - Managed iounmap()
  * @dev: Generic device to unmap for
  * @addr: Address to unmap
-- 
1.7.9.5

