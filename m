Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3CWEGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:06:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10849 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3CWEF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:05:59 -0400
X-AuditID: cbfee68d-b7f786d000005188-9d-514d2a25e64f
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
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
In-reply-to: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
Subject: [PATCH 2/6] of/pci: Add of_pci_parse_bus_range() function
Date: Sat, 23 Mar 2013 13:05:56 +0900
Message-id: <00c101ce277b$b8835b00$298a1100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrgAAAt+Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t8zQ11VLd9Ag+UzxC2a/29ntVjSlGFx
	YPZDVotXZzayWVxeeInV4vsNU4veBVfZLDY9vsZqcXnXHDaLs/OOs1nMOL+PyWJF01ZGi8UX
	lzNb7F65hMXi2IwljBZPHzQxOQh4rJm3htGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9Y
	yOjxfUcvUMGWVYweP1/qeHzeJBfAHcVlk5Kak1mWWqRvl8CVMWPTCtaCX3wVm1dsYGlg3M/T
	xcjJISFgIvFv/wwWCFtM4sK99WwgtpDAMkaJrwsqYGpa+xcB1XABxaczSqw/eg7K+cUo8WH9
	dCaQKjYBNYkvXw6zg9giAv4S1662ghUxC3xmkVg++Qw7xFhbibsn5zKD2JwCdhKPW1vBVgsL
	OEnM2D8TbBCLgKpE//7VjCA2L1D910ePmSFsQYkfk++B1TMLaEms33mcCcKWl9i85i1QDQfQ
	qeoSj/7qQtxgJPHyRzs7RImIxL4X7xhB7pEQuMIhcfbKRxaIXQIS3yYfYoHolZXYdIAZ4mNJ
	iYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQlJJ
	7w7G2wesDzEmA62fyCwlmpwPTEV5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamA8fW9F6WF93VC9N8tczlpc5dkl5dbO0qIVvcPml/y6P4umf281
	OyRaX3dcm9lR4FDGvjXcy8rsvdTOXO5/3Gnw+X3GUa48Vmb2ndxH5myIExBcfn/pxe0Of4oN
	prTkyz8OmfFa5jnj46p5nhOfXdi9YtEOLtuLW44+2CC5KsVwv+vUrU0FqcxuSizFGYmGWsxF
	xYkAI9UbszsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42I5/e+xoK6qlm+gwaLDAhbN/7ezWixpyrA4
	MPshq8WrMxvZLC4vvMRq8f2GqUXvgqtsFpseX2O1uLxrDpvF2XnH2SxmnN/HZLGiaSujxeKL
	y5ktdq9cwmJxbMYSRounD5qYHAQ81sxbw+jRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52cs
	ZPT4vqMXqGDLKkaPny91PD5vkgvgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wB+kZJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmDFj0wrWgl98FZtXbGBpYNzP08XIySEhYCLR2r+IBcIWk7hwbz1bFyMXh5DAdEaJ9UfP
	sUA4vxglPqyfzgRSxSagJvHly2F2EFtEwF/i2tVWsCJmgc8sEssnnwFLCAnYStw9OZcZxOYU
	sJN43NoKtkJYwElixv6ZYINYBFQl+vevZgSxeYHqvz56zAxhC0r8mHwPrJ5ZQEti/c7jTBC2
	vMTmNW+BajiATlWXePRXF+IGI4mXP9rZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYx
	iqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeqZ1I7GFc2WBxiFOBgVOLhDaj2CRRiTSwrrsw9
	xCjBwawkwntPwzdQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBaTSvJN7Q2MTMyNLIzMLI
	xNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjlClPv+76s+rBhY1J29z7GFL3436K1
	zB0ad19MEGWbsalKRo/revbWid3uS+pKuL6wuhXEfH71+MWin392buat3H86YfPKpod+kfK9
	zH0MLksfuEitmN7xOjXCzciu0G5V0ryn6lUVH5z35qV8Oqx16d/Ev6e2JP3+NTt+4pmdn18/
	bdFk2GipxFKckWioxVxUnAgApAixTpkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>

This function can be used to parse a bus-range property as specified by
device nodes representing PCI bridges.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/of/of_pci.c    |   25 +++++++++++++++++++++++++
 include/linux/of_pci.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 13e37e2..4ca7837 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -40,3 +40,28 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(of_pci_find_child_device);
+
+/**
+ * of_pci_parse_bus_range() - parse the bus-range property of a PCI device
+ * @node: device node
+ * @res: address to a struct resource to return the bus-range
+ *
+ * Returns 0 on success or a negative error-code on failure.
+ */
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
+{
+	const __be32 *values;
+	int len;
+
+	values = of_get_property(node, "bus-range", &len);
+	if (!values || len < sizeof(*values) * 2)
+		return -EINVAL;
+
+	res->name = node->name;
+	res->start = be32_to_cpup(values++);
+	res->end = be32_to_cpup(values);
+	res->flags = IORESOURCE_BUS;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index bb115de..178a5cc 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -10,5 +10,6 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 
 #endif
-- 
1.7.2.5


