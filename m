Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaDPEnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:43:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11223 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaDPEm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:42:57 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-d4-534e0a50387e
From: Jingoo Han <jg1.han@samsung.com>
To: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
In-reply-to: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
Subject: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
Date: Wed, 16 Apr 2014 13:42:56 +0900
Message-id: <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZLjB5lnZMYwshRiWF5lDNQlfulQAABPiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zI90ALr9gg2sNFhZ/Jx1jt1jSlGFx
	eeElVoveBVfZLN4fesZssenxNVaLy7vmsFmcnXeczeLA0nYWB06PNfPWMHr8/jWJ0WPBplKP
	zUvqPW7/e8zs0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBnbPv9kLlggVjHjeT9LA+NqoS5G
	Dg4JAROJM+uyuhg5gUwxiQv31rN1MXJxCAksY5RYtfo3C0TCROL86ktMEInpjBIbFvxjgXB+
	M0q0bTrODlLFJqAm8eXLYTBbRCBE4vfd22CjmAX+MErsPHmPGSQhJGAr8f3iKyYQm1PATuL7
	8udgK4QF7CWOLj7ICGKzCKhKLJpxA8zmBapfebWLFcIWlPgx+R5YPbOAlsT6nceZIGx5ic1r
	3jJDvKMu8eivLsQNRhLvjl5ihigRkdj34h0jyD0SAq0cEnOXdjNB7BKQ+Db5EAtEr6zEpgPM
	EB9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJ
	ERLhE3cw3j9gfYgxGWj9RGYp0eR8YILIK4k3NDYzsjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQZGBuVdfm53ec4ZbZjO+qEkKHzWs7QLXbzcreum/Zj/T9zj
	ZYVJcd7E7OVihxbc4nYx11+1w0SzaIF8Q6xqnVVKjMXjf39vFM79ZaJhNuX9lourxC5fXSFy
	Vkfskewr19rUHx1i7cc2zKk/rv/v+Bbho033Tzs3lT6rFomLND4tfJLXYGOt7cXDSizFGYmG
	WsxFxYkAMCPg1gYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd0ALr9ggw2/jSz+TjrGbrGkKcPi
	8sJLrBa9C66yWbw/9IzZYtPja6wWl3fNYbM4O+84m8WBpe0sDpwea+atYfT4/WsSo8eCTaUe
	m5fUe9z+95jZo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmbPv8k7lggVjFjOf9LA2Mq4W6GDk5JARMJM6vvsQEYYtJXLi3nq2LkYtDSGA6o8SGBf9Y
	IJzfjBJtm46zg1SxCahJfPlyGMwWEQiR+H33NlgHs8AfRomdJ+8xgySEBGwlvl98BTaWU8BO
	4vvy5ywgtrCAvcTRxQcZQWwWAVWJRTNugNm8QPUrr3axQtiCEj8m3wOrZxbQkli/8zgThC0v
	sXnNW6D5HECnqks8+qsLcYORxLujl5ghSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5BnUjsYVzZYHGIU4GBU4uGdkeMbLMSaWFZcmXuI
	UYKDWUmE98sXoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA5NbXkm8obGJmZGlkZmFkYm5
	OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwdmluWMSUyfL816LePQlGjCb8Ya5hB97J
	vn14zr914zoBDpf6B5FqGkZJyd85vDMsE4u3qG7fOvdN19lL8z59tPq/7AVLf7//WY/OEw+2
	M7fdFtjfMi1kqniymc4qv56a3VfL7m1YqHZPp913+s1HIZNKWxPeSZ/NUZDd9+r1gcILCR5M
	V013KrEUZyQaajEXFScCAGoVmHlkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ARM64 PCI support for Synopsys designware PCIe, by using
pcie arm64 arch support and creating generic pcie bridge from
device tree.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pci/host/pcie-designware.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 6d23d8c..fac0440 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -65,14 +65,27 @@
 #define PCIE_ATU_FUNC(x)		(((x) & 0x7) << 16)
 #define PCIE_ATU_UPPER_TARGET		0x91C
 
+#ifdef CONFIG_ARM
 static struct hw_pci dw_pci;
+#endif
 
 static unsigned long global_io_offset;
 
+#ifdef CONFIG_ARM
 static inline struct pcie_port *sys_to_pcie(struct pci_sys_data *sys)
 {
 	return sys->private_data;
 }
+#endif
+
+#ifdef CONFIG_ARM64
+static inline struct pcie_port *sys_to_pcie(struct pcie_port *pp)
+{
+	return pp;
+}
+
+static struct pci_ops dw_pcie_ops;
+#endif
 
 int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
 {
@@ -381,7 +394,9 @@ static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
 {
 	irq_set_chip_and_handler(irq, &dw_msi_irq_chip, handle_simple_irq);
 	irq_set_chip_data(irq, domain->host_data);
+#ifdef CONFIG_ARM
 	set_irq_flags(irq, IRQF_VALID);
+#endif
 
 	return 0;
 }
@@ -397,6 +412,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	struct of_pci_range_parser parser;
 	u32 val;
 	int i;
+#ifdef CONFIG_ARM64
+	struct pci_host_bridge *bridge;
+	resource_size_t lastbus;
+#endif
 
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pp->dev, "missing ranges property\n");
@@ -489,6 +508,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 	val |= PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
 
+#ifdef CONFIG_ARM
 	dw_pci.nr_controllers = 1;
 	dw_pci.private_data = (void **)&pp;
 
@@ -497,6 +517,16 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 #ifdef CONFIG_PCI_DOMAINS
 	dw_pci.domain++;
 #endif
+#endif
+
+#ifdef CONFIG_ARM64
+	bridge = of_create_pci_host_bridge(pp->dev, &dw_pcie_ops, pp);
+	if (IS_ERR_OR_NULL(bridge))
+		return PTR_ERR(bridge);
+
+	lastbus = pci_rescan_bus(bridge->bus);
+	pci_bus_update_busn_res_end(bridge->bus, lastbus);
+#endif
 
 	return 0;
 }
@@ -695,6 +725,7 @@ static struct pci_ops dw_pcie_ops = {
 	.write = dw_pcie_wr_conf,
 };
 
+#ifdef CONFIG_ARM
 static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
 {
 	struct pcie_port *pp;
@@ -758,6 +789,7 @@ static struct hw_pci dw_pci = {
 	.map_irq	= dw_pcie_map_irq,
 	.add_bus	= dw_pcie_add_bus,
 };
+#endif /* CONFIG_ARM */
 
 void dw_pcie_setup_rc(struct pcie_port *pp)
 {
-- 
1.7.10.4


