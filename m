Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaEVJe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:34:57 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64745 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbaEVJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:34:54 -0400
Message-ID: <1400751291.16832.27.camel@x220>
Subject: [PATCH] MIPS: MSP71xx: remove checks for two macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mips@linux-mips.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 11:34:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 09:34:51.0858 (UTC) FILETIME=[14F15B20:01CF75A1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v2.6.39 there are checks for CONFIG_MSP_HAS_DUAL_USB and checks
for CONFIG_MSP_HAS_TSMAC in the code. The related Kconfig symbols have
never been added. These checks have evaluated to false for three years
now. Remove them and the code they have been hiding.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h |  4 -
 arch/mips/pmcs-msp71xx/msp_eth.c                  | 76 -------------------
 arch/mips/pmcs-msp71xx/msp_usb.c                  | 90 -----------------------
 drivers/usb/host/ehci-pmcmsp.c                    | 40 ----------
 4 files changed, 210 deletions(-)

diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
index aa45e6a07126..fe1566f2913e 100644
--- a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
@@ -25,11 +25,7 @@
 #ifndef MSP_USB_H_
 #define MSP_USB_H_
 
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-#define NUM_USB_DEVS   2
-#else
 #define NUM_USB_DEVS   1
-#endif
 
 /* Register spaces for USB host 0 */
 #define MSP_USB0_MAB_START	(MSP_USB0_BASE + 0x0)
diff --git a/arch/mips/pmcs-msp71xx/msp_eth.c b/arch/mips/pmcs-msp71xx/msp_eth.c
index c584df393de2..15679b427f44 100644
--- a/arch/mips/pmcs-msp71xx/msp_eth.c
+++ b/arch/mips/pmcs-msp71xx/msp_eth.c
@@ -38,73 +38,6 @@
 #define MSP_ETHERNET_GPIO1	15
 #define MSP_ETHERNET_GPIO2	16
 
-#ifdef CONFIG_MSP_HAS_TSMAC
-#define MSP_TSMAC_SIZE	0x10020
-#define MSP_TSMAC_ID	"pmc_tsmac"
-
-static struct resource msp_tsmac0_resources[] = {
-	[0] = {
-		.start	= MSP_MAC0_BASE,
-		.end	= MSP_MAC0_BASE + MSP_TSMAC_SIZE - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSP_INT_MAC0,
-		.end	= MSP_INT_MAC0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct resource msp_tsmac1_resources[] = {
-	[0] = {
-		.start	= MSP_MAC1_BASE,
-		.end	= MSP_MAC1_BASE + MSP_TSMAC_SIZE - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSP_INT_MAC1,
-		.end	= MSP_INT_MAC1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-static struct resource msp_tsmac2_resources[] = {
-	[0] = {
-		.start	= MSP_MAC2_BASE,
-		.end	= MSP_MAC2_BASE + MSP_TSMAC_SIZE - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSP_INT_SAR,
-		.end	= MSP_INT_SAR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-
-static struct platform_device tsmac_device[] = {
-	[0] = {
-		.name	= MSP_TSMAC_ID,
-		.id	= 0,
-		.num_resources = ARRAY_SIZE(msp_tsmac0_resources),
-		.resource = msp_tsmac0_resources,
-	},
-	[1] = {
-		.name	= MSP_TSMAC_ID,
-		.id	= 1,
-		.num_resources = ARRAY_SIZE(msp_tsmac1_resources),
-		.resource = msp_tsmac1_resources,
-	},
-	[2] = {
-		.name	= MSP_TSMAC_ID,
-		.id	= 2,
-		.num_resources = ARRAY_SIZE(msp_tsmac2_resources),
-		.resource = msp_tsmac2_resources,
-	},
-};
-#define msp_eth_devs	tsmac_device
-
-#else
-/* If it is not TSMAC assume MSP_ETH (100Mbps) */
 #define MSP_ETH_ID	"pmc_mspeth"
 #define MSP_ETH_SIZE	0xE0
 static struct resource msp_eth0_resources[] = {
@@ -152,7 +85,6 @@ static struct platform_device mspeth_device[] = {
 };
 #define msp_eth_devs	mspeth_device
 
-#endif
 int __init msp_eth_setup(void)
 {
 	int i, ret = 0;
@@ -161,14 +93,6 @@ int __init msp_eth_setup(void)
 	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO0);
 	msp_gpio_pin_hi(MSP_ETHERNET_GPIO0);
 
-#ifdef CONFIG_MSP_HAS_TSMAC
-	/* 3 phys on boards with TSMAC */
-	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO1);
-	msp_gpio_pin_hi(MSP_ETHERNET_GPIO1);
-
-	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO2);
-	msp_gpio_pin_hi(MSP_ETHERNET_GPIO2);
-#endif
 	for (i = 0; i < ARRAY_SIZE(msp_eth_devs); i++) {
 		ret = platform_device_register(&msp_eth_devs[i]);
 		printk(KERN_INFO "device: %d, return value = %d\n", i, ret);
diff --git a/arch/mips/pmcs-msp71xx/msp_usb.c b/arch/mips/pmcs-msp71xx/msp_usb.c
index 4dab915696e7..c87c5f810cd1 100644
--- a/arch/mips/pmcs-msp71xx/msp_usb.c
+++ b/arch/mips/pmcs-msp71xx/msp_usb.c
@@ -75,47 +75,6 @@ static struct mspusb_device msp_usbhost0_device = {
 		.resource	= msp_usbhost0_resources,
 	},
 };
-
-/* MSP7140/MSP82XX has two USB2 hosts. */
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-static u64 msp_usbhost1_dma_mask = 0xffffffffUL;
-
-static struct resource msp_usbhost1_resources[] = {
-	[0] = { /* EHCI-HS operational and capabilities registers */
-		.start	= MSP_USB1_HS_START,
-		.end	= MSP_USB1_HS_END,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSP_INT_USB,
-		.end	= MSP_INT_USB,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = { /* MSBus-to-AMBA bridge register space */
-		.start	= MSP_USB1_MAB_START,
-		.end	= MSP_USB1_MAB_END,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = { /* Identification and general hardware parameters */
-		.start	= MSP_USB1_ID_START,
-		.end	= MSP_USB1_ID_END,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct mspusb_device msp_usbhost1_device = {
-	.dev	= {
-		.name	= "pmcmsp-ehci",
-		.id	= 1,
-		.dev	= {
-			.dma_mask = &msp_usbhost1_dma_mask,
-			.coherent_dma_mask = 0xffffffffUL,
-		},
-		.num_resources	= ARRAY_SIZE(msp_usbhost1_resources),
-		.resource	= msp_usbhost1_resources,
-	},
-};
-#endif /* CONFIG_MSP_HAS_DUAL_USB */
 #endif /* CONFIG_USB_EHCI_HCD */
 
 #if defined(CONFIG_USB_GADGET)
@@ -157,46 +116,6 @@ static struct mspusb_device msp_usbdev0_device = {
 		.resource	= msp_usbdev0_resources,
 	},
 };
-
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-static struct resource msp_usbdev1_resources[] = {
-	[0] = { /* EHCI-HS operational and capabilities registers */
-		.start	= MSP_USB1_HS_START,
-		.end	= MSP_USB1_HS_END,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= MSP_INT_USB,
-		.end	= MSP_INT_USB,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = { /* MSBus-to-AMBA bridge register space */
-		.start	= MSP_USB1_MAB_START,
-		.end	= MSP_USB1_MAB_END,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = { /* Identification and general hardware parameters */
-		.start	= MSP_USB1_ID_START,
-		.end	= MSP_USB1_ID_END,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-/* This may need to be converted to a mspusb_device, too. */
-static struct mspusb_device msp_usbdev1_device = {
-	.dev	= {
-		.name	= "msp71xx_udc",
-		.id	= 0,
-		.dev	= {
-			.dma_mask = &msp_usbdev_dma_mask,
-			.coherent_dma_mask = 0xffffffffUL,
-		},
-		.num_resources	= ARRAY_SIZE(msp_usbdev1_resources),
-		.resource	= msp_usbdev1_resources,
-	},
-};
-
-#endif /* CONFIG_MSP_HAS_DUAL_USB */
 #endif /* CONFIG_USB_GADGET */
 
 static int __init msp_usb_setup(void)
@@ -231,10 +150,6 @@ static int __init msp_usb_setup(void)
 #if defined(CONFIG_USB_EHCI_HCD)
 		msp_devs[0] = &msp_usbhost0_device.dev;
 		ppfinit("platform add USB HOST done %s.\n", msp_devs[0]->name);
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-		msp_devs[1] = &msp_usbhost1_device.dev;
-		ppfinit("platform add USB HOST done %s.\n", msp_devs[1]->name);
-#endif
 #else
 		ppfinit("%s: echi_hcd not supported\n", __FILE__);
 #endif	/* CONFIG_USB_EHCI_HCD */
@@ -244,11 +159,6 @@ static int __init msp_usb_setup(void)
 		msp_devs[0] = &msp_usbdev0_device.dev;
 		ppfinit("platform add USB DEVICE done %s.\n"
 					, msp_devs[0]->name);
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-		msp_devs[1] = &msp_usbdev1_device.dev;
-		ppfinit("platform add USB DEVICE done %s.\n"
-					, msp_devs[1]->name);
-#endif
 #else
 		ppfinit("%s: usb_gadget not supported\n", __FILE__);
 #endif	/* CONFIG_USB_GADGET */
diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
index af3974a5e7c2..7d75465d97c7 100644
--- a/drivers/usb/host/ehci-pmcmsp.c
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -68,9 +68,6 @@ static void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
 
 	/* set TWI GPIO USB_HOST_DEV pin high */
 	gpio_direction_output(MSP_PIN_USB0_HOST_DEV, 1);
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-	gpio_direction_output(MSP_PIN_USB1_HOST_DEV, 1);
-#endif
 }
 
 /* called during probe() after chip reset completes */
@@ -248,33 +245,6 @@ void usb_hcd_msp_remove(struct usb_hcd *hcd, struct platform_device *dev)
 	usb_put_hcd(hcd);
 }
 
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-/*
- * Wrapper around the main ehci_irq.  Since both USB host controllers are
- * sharing the same IRQ, need to first determine whether we're the intended
- * recipient of this interrupt.
- */
-static irqreturn_t ehci_msp_irq(struct usb_hcd *hcd)
-{
-	u32 int_src;
-	struct device *dev = hcd->self.controller;
-	struct platform_device *pdev;
-	struct mspusb_device *mdev;
-	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
-	/* need to reverse-map a couple of containers to get our device */
-	pdev = to_platform_device(dev);
-	mdev = to_mspusb_device(pdev);
-
-	/* Check to see if this interrupt is for this host controller */
-	int_src = ehci_readl(ehci, &mdev->mab_regs->int_stat);
-	if (int_src & (1 << pdev->id))
-		return ehci_irq(hcd);
-
-	/* Not for this device */
-	return IRQ_NONE;
-}
-#endif /* DUAL_USB */
-
 static const struct hc_driver ehci_msp_hc_driver = {
 	.description =		hcd_name,
 	.product_desc =		"PMC MSP EHCI",
@@ -283,11 +253,7 @@ static const struct hc_driver ehci_msp_hc_driver = {
 	/*
 	 * generic hardware linkage
 	 */
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-	.irq =			ehci_msp_irq,
-#else
 	.irq =			ehci_irq,
-#endif
 	.flags =		HCD_MEMORY | HCD_USB2 | HCD_BH,
 
 	/*
@@ -334,9 +300,6 @@ static int ehci_hcd_msp_drv_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	gpio_request(MSP_PIN_USB0_HOST_DEV, "USB0_HOST_DEV_GPIO");
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-	gpio_request(MSP_PIN_USB1_HOST_DEV, "USB1_HOST_DEV_GPIO");
-#endif
 
 	ret = usb_hcd_msp_probe(&ehci_msp_hc_driver, pdev);
 
@@ -351,9 +314,6 @@ static int ehci_hcd_msp_drv_remove(struct platform_device *pdev)
 
 	/* free TWI GPIO USB_HOST_DEV pin */
 	gpio_free(MSP_PIN_USB0_HOST_DEV);
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-	gpio_free(MSP_PIN_USB1_HOST_DEV);
-#endif
 
 	return 0;
 }
-- 
1.9.0

