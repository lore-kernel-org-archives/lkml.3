Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3G2OZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:25:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:47130 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3G2OZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:25:18 -0400
Date: Mon, 29 Jul 2013 16:25:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: George Cherian <george.cherian@ti.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v2 1/4] usb: phy: phy-omap-control: Add API to power
 and wakeup
Message-ID: <20130729142517.GA827@linutronix.de>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
 <1374237277-17769-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374237277-17769-2-git-send-email-george.cherian@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian | 2013-07-19 18:04:34 [+0530]:

>diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
>index 1419ced..4f2502c 100644
>--- a/drivers/usb/phy/phy-omap-control.c
>+++ b/drivers/usb/phy/phy-omap-control.c
>@@ -46,6 +46,73 @@ struct device *omap_get_control_dev(void)
> EXPORT_SYMBOL_GPL(omap_get_control_dev);
> 
> /**
>+ * omap_control_am335x_phy_wkup - PHY wakeup on/off  using control
>+ *	module
>+ * @dev: the control module device
>+ * @on: 0 to off and 1 to on PHY wakeup feature
>+ * @id: phy id 0 or 1 for phy instance 0 and 1 repectively
>+ *
>+ * AMXXXX PHY driver should call this API to enable or disable PHY wakeup.
>+ */
>+void omap_control_am335x_phy_wkup(struct device *dev, bool on, u8 id)
>+{
>+	u32 val;
>+	u32 *phy_wkup_reg;
>+	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
>+
>+	if (control_usb->type != OMAP_CTRL_DEV_TYPE3 || id < 0 || id > 1)
>+		return;
>+
>+	phy_wkup_reg = control_usb->dev_conf + AM335X_USB_WKUP_OFFSET;
>+	val = readl(phy_wkup_reg);

Where do you get the memory from? In the DT patches I've made I export
one memory space of 8 bytes for each phy. This memory space applies
directly to the on/off register. I didn't export the register for wakeup
so far since I had no idea how this will be used.
So how do you get your re-mapped memory here?

>+
>+	if (on)
>+		val |= id ? AM335X_USB1_WKUP_CTRL_ENABLE :
>+				AM335X_USB0_WKUP_CTRL_ENABLE;
>+	 else
>+		val &= id ? ~AM335X_USB1_WKUP_CTRL_ENABLE :
>+				~AM335X_USB0_WKUP_CTRL_ENABLE;
>+
>+
>+	writel(val, phy_wkup_reg);
>+}
>+EXPORT_SYMBOL_GPL(omap_control_am335x_phy_wkup);

Sebastian
