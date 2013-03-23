Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab3CWEE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:04:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30792 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3CWEE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:04:56 -0400
X-AuditID: cbfee68d-b7f786d000005188-53-514d29e53d9d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] of/pci: Provide support for parsing PCI DT ranges property
Date: Sat, 23 Mar 2013 13:04:53 +0900
Message-id: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zvu4zTd9Ag5WsFs3/t7NaLGnKsDgw
	+yGrxaszG9ksLi+8xGrx/YapRe+Cq2wWmx5fY7W4vGsOm8XZecfZLGac38dksaJpK6PF4ovL
	mS12r1zCYnFsxhJGi6cPmpgcBDzWzFvD6NE35Sqbx5NNFxk9Fmwq9bhzbQ+bx+Yl9R7nZyxk
	9Pi+oxeoYMsqRo+fL3U8Pm+SC+CO4rJJSc3JLEst0rdL4Mq42/yMtWDWTMaKu6dOsjcwTivr
	YuTkkBAwkTjWPZ0VwhaTuHBvPVsXIxeHkMAyRok7hyYwdTFygBV9XR0PEZ/OKHFxwXxGCOcX
	o0TjtmdsIN1sAmoSX74cZgexRQT8Ja5dbWUBKWIW+MwisXzyGbCEMFDiwb43YDaLgKrEgyWz
	mUBsXgFbiVO3NrBA2IISPybfA7OZBbQk1u88zgRhy0tsXvOWGeIidYlHf3UhdulJPH53jRmi
	RERi34t3jBDf7OGQmNvHCbFKQOLb5EMsEK2yEpsOMEOUSEocXHGDZQKj2Cwki2chWTwLyeJZ
	SDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRGSGHp3MN4+YH2IMRlo/URmKdHkfGBi
	ySuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY6z3
	Dt6lK4/+0F2pejh/+/6+c3umm/TJfmx4kFURtNtP7mOqZM0Jm9JrL6RUuNpajn8okfyxiXFH
	ZvMnf6dbE0Sqq5/fUJAQNze/1V1xJOiBypFvb/w+rL+Y1WNcyfVz61yWF1F70jI/e7wq/q36
	KqX95+Q1D+ZO2md58nBwauBs/7ydRxLKYpVYijMSDbWYi4oTAXkQ7Z4iAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t9jQd2nmr6BBrO3G1s0/9/OarGkKcPi
	wOyHrBavzmxks7i88BKrxfcbpha9C66yWWx6fI3V4vKuOWwWZ+cdZ7OYcX4fk8WKpq2MFosv
	Lme22L1yCYvFsRlLGC2ePmhichDwWDNvDaNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+x
	kNHj+45eoIItqxg9fr7U8fi8SS6AO6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ
	0sJcSSEvMTfVVsnFJ0DXLTMH6BslhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8bd5mesBbNmMlbcPXWSvYFxWlkXIweHhICJxNfV8V2MnECmmMSFe+vZuhi5OIQEpjNK
	XFwwnxHC+cUo0bjtGRtIFZuAmsSXL4fZQWwRAX+Ja1dbWUCKmAU+s0gsn3wGLCEMlHiw7w2Y
	zSKgKvFgyWwmEJtXwFbi1K0NLBC2oMSPyffAbGYBLYn1O48zQdjyEpvXvGWGuE5d4tFfXYhd
	ehKP311jhigRkdj34h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJEZx6nkntYFzZYHGIUYCDUYmHN6DaJ1CINbGsuDL3EKMEB7OSCO89Dd9AId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HpsW8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamA8c+79Bv7095qyM6vOfrjf0rf+9HcrQz6rDROd+wSM7+jb2Vfkl7bP
	MBd6zfHnaIHlwzoph2PRvBsD3sr95WBIVfh7QWLL6sW+3+8fb3zuHHfw46a7JyuVeXj/eF3x
	8c/UPvfEb2vz1ZOKpydN3nnx8bQtZ26uWZTD7hLuI+2xfrU836fbC6ZPUmIpzkg01GIuKk4E
	ADx5R4CBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Murray <Andrew.Murray@arm.com>

This patch factors out common implementations patterns to reduce overall kernel
code and provide a means for host bridge drivers to directly obtain struct
resources from the DT's ranges property without relying on architecture specific
DT handling. This will make it easier to write archiecture independent host bridge
drivers and mitigate against further duplication of DT parsing code.

This patch can be used in the following way:

	struct of_pci_range_iter iter;
	for_each_of_pci_range(&iter, np) {

		//directly access properties of the address range, e.g.:
		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
		//iter.flags

		//alternatively obtain a struct resource, e.g.:
		//struct resource res;
		//range_iter_fill_resource(iter, np, res);
	}

Additionally the implementation takes care of adjacent ranges and merges them
into a single range (as was the case with powerpc and microblaze).

The modifications to microblaze, mips and powerpc have not been tested.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/microblaze/pci/pci-common.c |  106 ++++++++++++--------------------------
 arch/mips/pci/pci.c              |   44 ++++------------
 arch/powerpc/kernel/pci-common.c |   93 ++++++++++-----------------------
 drivers/of/address.c             |   54 +++++++++++++++++++
 include/linux/of_address.h       |   31 +++++++++++
 5 files changed, 155 insertions(+), 173 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index bdb8ea1..5eabe35 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -657,67 +657,36 @@ void pci_resource_to_user(const struct pci_dev *dev, int bar,
 void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				  struct device_node *dev, int primary)
 {
-	const u32 *ranges;
-	int rlen;
-	int pna = of_n_addr_cells(dev);
-	int np = pna + 5;
 	int memno = 0, isa_hole = -1;
-	u32 pci_space;
-	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
 	unsigned long long isa_mb = 0;
 	struct resource *res;
+	struct of_pci_range_iter iter;
 
 	pr_info("PCI host bridge %s %s ranges:\n",
 	       dev->full_name, primary ? "(primary)" : "");
 
-	/* Get ranges property */
-	ranges = of_get_property(dev, "ranges", &rlen);
-	if (ranges == NULL)
-		return;
-
-	/* Parse it */
 	pr_debug("Parsing ranges property...\n");
-	while ((rlen -= np * 4) >= 0) {
+	for_each_of_pci_range(&iter, dev) {
 		/* Read next ranges element */
-		pci_space = ranges[0];
-		pci_addr = of_read_number(ranges + 1, 2);
-		cpu_addr = of_translate_address(dev, ranges + 3);
-		size = of_read_number(ranges + pna + 3, 2);
-
-		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
-				pci_space, pci_addr);
-		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
-					cpu_addr, size);
-
-		ranges += np;
+		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx "
+				"cpu_addr:0x%016llx size:0x%016llx\n",
+				iter.pci_space, iter.pci_addr, iter.cpu_addr,
+				iter.size);
 
 		/* If we failed translation or got a zero-sized region
 		 * (some FW try to feed us with non sensical zero sized regions
 		 * such as power3 which look like some kind of attempt
 		 * at exposing the VGA memory hole)
 		 */
-		if (cpu_addr == OF_BAD_ADDR || size == 0)
+		if (iter.cpu_addr == OF_BAD_ADDR || iter.size == 0)
 			continue;
 
-		/* Now consume following elements while they are contiguous */
-		for (; rlen >= np * sizeof(u32);
-		     ranges += np, rlen -= np * 4) {
-			if (ranges[0] != pci_space)
-				break;
-			pci_next = of_read_number(ranges + 1, 2);
-			cpu_next = of_translate_address(dev, ranges + 3);
-			if (pci_next != pci_addr + size ||
-			    cpu_next != cpu_addr + size)
-				break;
-			size += of_read_number(ranges + pna + 3, 2);
-		}
-
 		/* Act based on address space type */
 		res = NULL;
-		switch ((pci_space >> 24) & 0x3) {
-		case 1:		/* PCI IO space */
+		if (iter.flags & IORESOURCE_IO) {
 			pr_info("  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr);
+				iter.cpu_addr, iter.cpu_addr + iter.size - 1,
+				iter.pci_addr);
 
 			/* We support only one IO range */
 			if (hose->pci_io_size) {
@@ -725,11 +694,11 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				continue;
 			}
 			/* On 32 bits, limit I/O space to 16MB */
-			if (size > 0x01000000)
-				size = 0x01000000;
+			if (iter.size > 0x01000000)
+				iter.size = 0x01000000;
 
 			/* 32 bits needs to map IOs here */
-			hose->io_base_virt = ioremap(cpu_addr, size);
+			hose->io_base_virt = ioremap(iter.cpu_addr, iter.size);
 
 			/* Expect trouble if pci_addr is not 0 */
 			if (primary)
@@ -738,19 +707,18 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			/* pci_io_size and io_base_phys always represent IO
 			 * space starting at 0 so we factor in pci_addr
 			 */
-			hose->pci_io_size = pci_addr + size;
-			hose->io_base_phys = cpu_addr - pci_addr;
+			hose->pci_io_size = iter.pci_addr + iter.size;
+			hose->io_base_phys = iter.cpu_addr - iter.pci_addr;
 
 			/* Build resource */
 			res = &hose->io_resource;
-			res->flags = IORESOURCE_IO;
-			res->start = pci_addr;
-			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+			iter.cpu_addr = iter.pci_addr;
+		} else if (iter.flags & IORESOURCE_MEM) {
 			pr_info(" MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr,
-			       (pci_space & 0x40000000) ? "Prefetch" : "");
+				iter.cpu_addr, iter.cpu_addr + iter.size - 1,
+				iter.pci_addr,
+				(iter.pci_space & 0x40000000) ?
+				"Prefetch" : "");
 
 			/* We support only 3 memory ranges */
 			if (memno >= 3) {
@@ -758,13 +726,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				continue;
 			}
 			/* Handles ISA memory hole space here */
-			if (pci_addr == 0) {
+			if (iter.pci_addr == 0) {
 				isa_mb = cpu_addr;
 				isa_hole = memno;
 				if (primary || isa_mem_base == 0)
-					isa_mem_base = cpu_addr;
-				hose->isa_mem_phys = cpu_addr;
-				hose->isa_mem_size = size;
+					isa_mem_base = iter.cpu_addr;
+				hose->isa_mem_phys = iter.cpu_addr;
+				hose->isa_mem_size = iter.size;
 			}
 
 			/* We get the PCI/Mem offset from the first range or
@@ -772,30 +740,22 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			 * hole. If they don't match, bugger.
 			 */
 			if (memno == 0 ||
-			    (isa_hole >= 0 && pci_addr != 0 &&
+			    (isa_hole >= 0 && iter.pci_addr != 0 &&
 			     hose->pci_mem_offset == isa_mb))
-				hose->pci_mem_offset = cpu_addr - pci_addr;
-			else if (pci_addr != 0 &&
-				 hose->pci_mem_offset != cpu_addr - pci_addr) {
+				hose->pci_mem_offset = iter.cpu_addr
+							- iter.pci_addr;
+			else if (iter.pci_addr != 0 &&
+				 hose->pci_mem_offset != iter.cpu_addr
+							- iter.pci_addr) {
 				pr_info(" \\--> Skipped (offset mismatch) !\n");
 				continue;
 			}
 
 			/* Build resource */
 			res = &hose->mem_resources[memno++];
-			res->flags = IORESOURCE_MEM;
-			if (pci_space & 0x40000000)
-				res->flags |= IORESOURCE_PREFETCH;
-			res->start = cpu_addr;
-			break;
-		}
-		if (res != NULL) {
-			res->name = dev->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
 		}
+		if (res != NULL)
+			range_iter_fill_resource(iter, dev, res);
 	}
 
 	/* If there's an ISA hole and the pci_mem_offset is -not- matching
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 0872f12..8358cf8 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -122,51 +122,27 @@ static void pcibios_scanbus(struct pci_controller *hose)
 #ifdef CONFIG_OF
 void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
 {
-	const __be32 *ranges;
-	int rlen;
-	int pna = of_n_addr_cells(node);
-	int np = pna + 5;
+	struct of_pci_range_iter iter;
 
 	pr_info("PCI host bridge %s ranges:\n", node->full_name);
-	ranges = of_get_property(node, "ranges", &rlen);
-	if (ranges == NULL)
-		return;
 	hose->of_node = node;
 
-	while ((rlen -= np * 4) >= 0) {
-		u32 pci_space;
+	for_each_of_pci_range(&iter, node) {
 		struct resource *res = NULL;
-		u64 addr, size;
-
-		pci_space = be32_to_cpup(&ranges[0]);
-		addr = of_translate_address(node, ranges + 3);
-		size = of_read_number(ranges + pna + 3, 2);
-		ranges += np;
-		switch ((pci_space >> 24) & 0x3) {
-		case 1:		/* PCI IO space */
+
+		if (iter.flags & IORESOURCE_IO) {
 			pr_info("  IO 0x%016llx..0x%016llx\n",
-					addr, addr + size - 1);
+					iter.addr, iter.addr + iter.size - 1);
 			hose->io_map_base =
-				(unsigned long)ioremap(addr, size);
+				(unsigned long)ioremap(iter.addr, iter.size);
 			res = hose->io_resource;
-			res->flags = IORESOURCE_IO;
-			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+		} else if (iter.flags & IORESOURCE_MEM) {
 			pr_info(" MEM 0x%016llx..0x%016llx\n",
-					addr, addr + size - 1);
+					iter.addr, iter.addr + iter.size - 1);
 			res = hose->mem_resource;
-			res->flags = IORESOURCE_MEM;
-			break;
-		}
-		if (res != NULL) {
-			res->start = addr;
-			res->name = node->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
 		}
+		if (res != NULL)
+			range_iter_fill_resource(iter, node, res);
 	}
 }
 #endif
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index fa12ae4..9230b27 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -676,61 +676,31 @@ void pci_resource_to_user(const struct pci_dev *dev, int bar,
 void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				  struct device_node *dev, int primary)
 {
-	const u32 *ranges;
-	int rlen;
-	int pna = of_n_addr_cells(dev);
-	int np = pna + 5;
 	int memno = 0, isa_hole = -1;
-	u32 pci_space;
-	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
 	unsigned long long isa_mb = 0;
 	struct resource *res;
+	struct of_pci_range_iter iter;
 
 	printk(KERN_INFO "PCI host bridge %s %s ranges:\n",
 	       dev->full_name, primary ? "(primary)" : "");
 
-	/* Get ranges property */
-	ranges = of_get_property(dev, "ranges", &rlen);
-	if (ranges == NULL)
-		return;
-
 	/* Parse it */
-	while ((rlen -= np * 4) >= 0) {
-		/* Read next ranges element */
-		pci_space = ranges[0];
-		pci_addr = of_read_number(ranges + 1, 2);
-		cpu_addr = of_translate_address(dev, ranges + 3);
-		size = of_read_number(ranges + pna + 3, 2);
-		ranges += np;
-
+	for_each_of_pci_range(&iter, dev) {
 		/* If we failed translation or got a zero-sized region
 		 * (some FW try to feed us with non sensical zero sized regions
 		 * such as power3 which look like some kind of attempt at exposing
 		 * the VGA memory hole)
 		 */
-		if (cpu_addr == OF_BAD_ADDR || size == 0)
+		if (iter.cpu_addr == OF_BAD_ADDR || iter.size == 0)
 			continue;
 
-		/* Now consume following elements while they are contiguous */
-		for (; rlen >= np * sizeof(u32);
-		     ranges += np, rlen -= np * 4) {
-			if (ranges[0] != pci_space)
-				break;
-			pci_next = of_read_number(ranges + 1, 2);
-			cpu_next = of_translate_address(dev, ranges + 3);
-			if (pci_next != pci_addr + size ||
-			    cpu_next != cpu_addr + size)
-				break;
-			size += of_read_number(ranges + pna + 3, 2);
-		}
-
 		/* Act based on address space type */
 		res = NULL;
-		switch ((pci_space >> 24) & 0x3) {
-		case 1:		/* PCI IO space */
+		if (iter.flags & IORESOURCE_IO) {
 			printk(KERN_INFO
 			       "  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr);
+			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
+			       iter.pci_addr);
 
 			/* We support only one IO range */
 			if (hose->pci_io_size) {
@@ -740,11 +710,11 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			}
 #ifdef CONFIG_PPC32
 			/* On 32 bits, limit I/O space to 16MB */
-			if (size > 0x01000000)
-				size = 0x01000000;
+			if (iter.size > 0x01000000)
+				iter.size = 0x01000000;
 
 			/* 32 bits needs to map IOs here */
-			hose->io_base_virt = ioremap(cpu_addr, size);
+			hose->io_base_virt = ioremap(iter.cpu_addr, iter.size);
 
 			/* Expect trouble if pci_addr is not 0 */
 			if (primary)
@@ -754,20 +724,18 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			/* pci_io_size and io_base_phys always represent IO
 			 * space starting at 0 so we factor in pci_addr
 			 */
-			hose->pci_io_size = pci_addr + size;
-			hose->io_base_phys = cpu_addr - pci_addr;
+			hose->pci_io_size = iter.pci_addr + iter.size;
+			hose->io_base_phys = iter.cpu_addr - iter.pci_addr;
 
 			/* Build resource */
 			res = &hose->io_resource;
-			res->flags = IORESOURCE_IO;
-			res->start = pci_addr;
-			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+			iter.cpu_addr = iter.pci_addr;
+		} else if (flags & IORESOURCE_MEM) {
 			printk(KERN_INFO
 			       " MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr,
-			       (pci_space & 0x40000000) ? "Prefetch" : "");
+			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
+			       iter.pci_addr,
+			       (iter.pci_space & 0x40000000) ? "Prefetch" : "");
 
 			/* We support only 3 memory ranges */
 			if (memno >= 3) {
@@ -776,13 +744,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				continue;
 			}
 			/* Handles ISA memory hole space here */
-			if (pci_addr == 0) {
+			if (iter.pci_addr == 0) {
 				isa_mb = cpu_addr;
 				isa_hole = memno;
 				if (primary || isa_mem_base == 0)
-					isa_mem_base = cpu_addr;
-				hose->isa_mem_phys = cpu_addr;
-				hose->isa_mem_size = size;
+					isa_mem_base = iter.cpu_addr;
+				hose->isa_mem_phys = iter.cpu_addr;
+				hose->isa_mem_size = iter.size;
 			}
 
 			/* We get the PCI/Mem offset from the first range or
@@ -790,11 +758,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			 * hole. If they don't match, bugger.
 			 */
 			if (memno == 0 ||
-			    (isa_hole >= 0 && pci_addr != 0 &&
+			    (isa_hole >= 0 && iter.pci_addr != 0 &&
 			     hose->pci_mem_offset == isa_mb))
-				hose->pci_mem_offset = cpu_addr - pci_addr;
+				hose->pci_mem_offset = iter.cpu_addr -
+							iter.pci_addr;
 			else if (pci_addr != 0 &&
-				 hose->pci_mem_offset != cpu_addr - pci_addr) {
+				 hose->pci_mem_offset != iter.cpu_addr -
+							iter.pci_addr) {
 				printk(KERN_INFO
 				       " \\--> Skipped (offset mismatch) !\n");
 				continue;
@@ -802,19 +772,10 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 
 			/* Build resource */
 			res = &hose->mem_resources[memno++];
-			res->flags = IORESOURCE_MEM;
-			if (pci_space & 0x40000000)
-				res->flags |= IORESOURCE_PREFETCH;
-			res->start = cpu_addr;
 			break;
 		}
-		if (res != NULL) {
-			res->name = dev->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
-		}
+		if (res != NULL)
+			range_iter_fill_resource(iter, dev, res);
 	}
 
 	/* If there's an ISA hole and the pci_mem_offset is -not- matching
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 04da786..2ab34e2 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -227,6 +227,60 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
 	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
 }
 EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
+
+struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
+						struct device_node *node)
+{
+	const int na = 3, ns = 2;
+	int rlen;
+
+	if (!iter->range) {
+		iter->pna = of_n_addr_cells(node);
+		iter->np = iter->pna + na + ns;
+
+		iter->range = of_get_property(node, "ranges", &rlen);
+		if (iter->range == NULL)
+			return NULL;
+
+		iter->end = iter->range + rlen / sizeof(__be32);
+	}
+
+	if (iter->range + iter->np > iter->end)
+		return NULL;
+
+	iter->pci_space = be32_to_cpup(iter->range);
+	iter->flags = of_bus_pci_get_flags(iter->range);
+	iter->pci_addr = of_read_number(iter->range + 1, ns);
+	iter->cpu_addr = of_translate_address(node, iter->range + na);
+	iter->size = of_read_number(iter->range + iter->pna + na, ns);
+
+	iter->range += iter->np;
+
+	/* Now consume following elements while they are contiguous */
+	while (iter->range + iter->np <= iter->end) {
+		u32 flags, pci_space;
+		u64 pci_addr, cpu_addr, size;
+
+		pci_space = be32_to_cpup(iter->range);
+		flags = of_bus_pci_get_flags(iter->range);
+		pci_addr = of_read_number(iter->range + 1, ns);
+		cpu_addr = of_translate_address(node, iter->range + na);
+		size = of_read_number(iter->range + iter->pna + na, ns);
+
+		if (flags != iter->flags)
+			break;
+		if (pci_addr != iter->pci_addr + iter->size ||
+		    cpu_addr != iter->cpu_addr + iter->size)
+			break;
+
+		iter->size += size;
+		iter->range += iter->np;
+	}
+
+	return iter;
+}
+EXPORT_SYMBOL_GPL(of_pci_process_ranges);
+
 #endif /* CONFIG_PCI */
 
 /*
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 0506eb5..7d5cd11 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -4,6 +4,30 @@
 #include <linux/errno.h>
 #include <linux/of.h>
 
+struct of_pci_range_iter {
+	const __be32 *range, *end;
+	int np, pna;
+
+	u32 pci_space;
+	u64 pci_addr;
+	u64 cpu_addr;
+	u64 size;
+	u32 flags;
+};
+
+#define for_each_of_pci_range(iter, np) \
+	for (memset((iter), 0, sizeof(struct of_pci_range_iter)); \
+	     of_pci_process_ranges(iter, np);)
+
+#define range_iter_fill_resource(iter, np, res) \
+	do { \
+		(res)->flags = (iter).flags; \
+		(res)->start = (iter).cpu_addr; \
+		(res)->end = (iter).cpu_addr + (iter).size - 1; \
+		(res)->parent = (res)->child = (res)->sibling = NULL; \
+		(res)->name = (np)->full_name; \
+	} while (0)
+
 #ifdef CONFIG_OF_ADDRESS
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern bool of_can_translate_address(struct device_node *dev);
@@ -27,6 +51,8 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #define pci_address_to_pio pci_address_to_pio
 #endif
 
+struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
+						struct device_node *node);
 #else /* CONFIG_OF_ADDRESS */
 #ifndef of_address_to_resource
 static inline int of_address_to_resource(struct device_node *dev, int index,
@@ -53,6 +79,11 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
 {
 	return NULL;
 }
+struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
+						struct device_node *node)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF_ADDRESS */
 
 
-- 
1.7.2.5


