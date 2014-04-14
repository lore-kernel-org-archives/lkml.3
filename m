Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaDNLsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:48:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29889 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaDNLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:48:08 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-50-534bcaf63d8d
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 04/13] extcon: extcon-class: match extcon device by
 devicetree node
Date: Mon, 14 Apr 2014 13:46:15 +0200
Message-id: <1397475984-28001-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRjAcd+dy47DxWGaHhZUjPrgMHMR8UK6LFReMSoRw6SopQeV5m3T
	lX1pYtMc6qYVXvN+d3PhJZ2oOV1FpWZZipiaeDdTCC9FdnFK337P8/y/PRQmaMOFVFRMAquI
	kclFJA9/+2eGPrb5JiDIQ10phoZFb2hpdYWWqXtwdH2BgDmzaxgssQ4SMLvuIQZ1K2UE1LX4
	wJ7tdgBTKkwkHFyuAzB9YBaDQ3MZJKzqbsBhWWolDoc7ikhYWKnDYXm1BoOzZf0caLROcGHV
	6HsOHE+uJWHNt78k1Ocacfilz8yFjUu5ONR0Wbmwe2ibgKa8r7j3QWQoNgA0nJXJQR3mIgLp
	dd8BMhdMcFFdzTqJ+jbKcNRcK0ZN9ekkWm7IJ9DnkU4SPX9i4KLMlFUSLWX/IpF5S81FWS31
	4JJjKM8znJVHqVjFcekNXuTLxQosblNyJ0NXSKhBtVgL7CmGPsnUvB7g7NmZGZo0kVrAowR0
	OWA2O8vB3pDGYYzTz3BbRdJuTMuWHtjsRGNM6eN3u8boOYJp++FlsyMdwoxMm7haQFE4fZSZ
	WmJt5NO+TIl1lwx9mCnK8bTF9rQfY8n/jdks2Cl6UsYxPeCXArt6sJ+NC4tT3oyIlrgrZdHK
	xJgI97DY6Caw+855YTuoU8NeQFNA5MB/UBQQJCBkKmVSdC9gKEzkxPdt3Vnxw2VJd1lF7HVF
	opxV9oIDFC5y4fdoTgcK6AhZAnuLZeNYxf8rh7IXqsH5tAkX3uo5TNV02SF3NF7vJ3Zbs99n
	0eQEZ912eXXkTFL8dkho/EKAweil3vKKufaxyzUPnvpUmDW9sJGqdTZ5SMJKq6+clUl98u2k
	odX3M/wlFl5gz88XJ1RP52fWHg01hq40Sw9dvCq/UCG0pnwI9qr3n0peLZ5UjfW3Jo4ViHBl
	pEwixhRK2T9l3IrQygIAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies extcon_get_edev_by_phandle() function, to match
extcon device by devicetree node. This modification needed to add
field 'node' in extcon_dev structure, and fill it in probe function
of each extcon provider driver.

This patch adds function of_extcon_get_extcon_dev(),
returning extcon device which contains given devicetree node.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |    1 +
 drivers/extcon/extcon-arizona.c  |    1 +
 drivers/extcon/extcon-class.c    |   21 ++++++++++++++++++++-
 drivers/extcon/extcon-gpio.c     |    1 +
 drivers/extcon/extcon-max14577.c |    2 ++
 drivers/extcon/extcon-max77693.c |    1 +
 drivers/extcon/extcon-max8997.c  |    1 +
 drivers/extcon/extcon-palmas.c   |    1 +
 include/linux/extcon.h           |    2 ++
 9 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index e23f1c2..d65915e 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -111,6 +111,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 	}
 
 	data->edev.dev.parent = &pdev->dev;
+	data->edev.node = pdev->dev.of_node;
 	data->edev.supported_cable = pdata->cable_names;
 
 	/* Check the length of array and set num_cables */
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..fc69cca 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1153,6 +1153,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	info->edev.name = "Headset Jack";
 	info->edev.dev.parent = arizona->dev;
+	info->edev.node = pdev->dev.of_node;
 	info->edev.supported_cable = arizona_cable;
 
 	ret = extcon_dev_register(&info->edev);
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 1b98c4e..b0d9c90 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -377,6 +377,25 @@ out:
 }
 EXPORT_SYMBOL_GPL(extcon_get_extcon_dev);
 
+/**
+ * of_extcon_get_extcon_dev() - Get the extcon device instance from the name
+ * @np: The node of extcon device
+ */
+struct extcon_dev *of_extcon_get_extcon_dev(const struct device_node *np)
+{
+	struct extcon_dev *edev;
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_for_each_entry(edev, &extcon_dev_list, entry) {
+		if (edev->node == np)
+			goto out;
+	}
+	edev = NULL;
+out:
+	mutex_unlock(&extcon_dev_list_lock);
+	return edev;
+}
+
 static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 			   void *ptr)
 {
@@ -827,7 +846,7 @@ struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	edev = extcon_get_extcon_dev(node->name);
+	edev = of_extcon_get_extcon_dev(node);
 	if (!edev) {
 		dev_err(dev, "unable to get extcon device : %s\n", node->name);
 		return ERR_PTR(-ENODEV);
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..fc90b7a 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -100,6 +100,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 
 	extcon_data->edev.name = pdata->name;
 	extcon_data->edev.dev.parent = &pdev->dev;
+	extcon_data->edev.node = pdev->dev.of_node;
 	extcon_data->gpio = pdata->gpio;
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 7a947d3..b017a0d 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -676,6 +676,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->edev->name = DEV_NAME;
+	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max14577_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 7a014cd..2cd8892 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1200,6 +1200,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max77693_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index a3df70d..c071588 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -718,6 +718,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max8997_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 26c0619..153a40e 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -199,6 +199,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	palmas_usb->edev.supported_cable = palmas_extcon_cable;
 	palmas_usb->edev.dev.parent = palmas_usb->dev;
+	palmas_usb->edev.node = pdev->dev.of_node;
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
 	status = extcon_dev_register(&palmas_usb->edev);
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index ed4a47b..573dd1f 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -77,6 +77,7 @@ struct extcon_cable;
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name:		The name of this extcon device. Parent device name is
+ * @node:		Devicetree node of parent device.
  *			used if NULL.
  * @supported_cable:	Array of supported cable names ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
@@ -113,6 +114,7 @@ struct extcon_cable;
 struct extcon_dev {
 	/* Optional user initializing data */
 	const char *name;
+	const struct device_node *node;
 	const char **supported_cable;
 	const u32 *mutually_exclusive;
 
-- 
1.7.9.5

