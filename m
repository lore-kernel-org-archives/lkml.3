Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbaEEVq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:46:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52256 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbaEEVq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:46:26 -0400
Message-ID: <5368068C.3090403@ti.com>
Date: Mon, 5 May 2014 17:45:48 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>	<1398353407-2345-4-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqKmf-OCf_-J06ztHWS0iRaMHAVxV0bOFGnY4Ci3fPgLow@mail.gmail.com>
In-Reply-To: <CAL_JsqKmf-OCf_-J06ztHWS0iRaMHAVxV0bOFGnY4Ci3fPgLow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2014 08:56 PM, Rob Herring wrote:
> On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> The of_dma_is_coherent() helper parses the given DT device
>> node to see if the "dma-coherent" property is supported and
>> returns true or false accordingly.
>>
>> If the arch is always coherent or always noncoherent, then the default
>> DMA ops has to be specified accordingly.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>  drivers/of/platform.c       |   23 +++++++++++++++++++++++
>>  include/linux/of_platform.h |    6 ++++++
> 
> I thought I said this already, but this does not belong in these files
> as the function does not deal with platform devices. Probably
> address.c/of_address.h would be the best place.
> 
Updated patch with functions now moved to of_address.h/address.c

>From 08fb70715afe4adf203d24f1737dba7123c6713b Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Thu, 24 Apr 2014 11:30:03 -0400
Subject: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper

The of_dma_is_coherent() helper parses the given DT device
node to see if the "dma-coherent" property is supported and
returns true or false accordingly.

If the arch is always coherent or always noncoherent, then the default
DMA ops has to be specified accordingly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/of/address.c       |   23 +++++++++++++++++++++++
 include/linux/of_address.h |    6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index c54baee..d244b28 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -808,3 +808,26 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(of_dma_get_range);
+
+/**
+ * of_dma_is_coherent - Check if device is coherent
+ * @np:	device node
+ *
+ * It returns true if "dma-coherent" property was found
+ * for this device in DT.
+ */
+bool of_dma_is_coherent(struct device_node *np)
+{
+	struct device_node *node = of_node_get(np);
+
+	while (node) {
+		if (of_property_read_bool(node, "dma-coherent")) {
+			of_node_put(node);
+			return true;
+		}
+		node = of_get_next_parent(node);
+	}
+	of_node_put(node);
+	return false;
+}
+EXPORT_SYMBOL_GPL(of_dma_is_coherent);
\ No newline at end of file
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 4d7b325..839a352 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -65,6 +65,7 @@ extern struct of_pci_range *of_pci_range_parser_one(
 					struct of_pci_range *range);
 extern int of_dma_get_range(struct device_node *np, u64 *dma_addr,
 				u64 *paddr, u64 *size);
+extern bool of_dma_is_coherent(struct device_node *np);
 #else /* CONFIG_OF_ADDRESS */
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
@@ -98,6 +99,11 @@ static inline int of_dma_get_range(struct device_node *np, u64 *dma_addr,
 {
 	return -ENODEV;
 }
+
+static inline bool of_dma_is_coherent(struct device_node *np)
+{
+	return false;
+}
 #endif /* CONFIG_OF_ADDRESS */
 
 #ifdef CONFIG_OF
-- 
1.7.9.5

