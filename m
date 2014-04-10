Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161193AbaDJNTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:19:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161024AbaDJNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:19:03 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-e3-53469a44440c
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 06/13] extcon: extcon-class: remove unused functions
Date: Thu, 10 Apr 2014 15:16:44 +0200
Message-id: <1397135811-12866-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRgH8N6dy47W5HRadtKkXClotbIsXkhCQuXglxLpgn2wqYcpOpVN
	JSVoIVZaujlbonmb9+nUMsVteHdUZtrC0kAto6UpWmTTga6Lx+jbj+f//Hk+PARCPUY9iITk
	NFaeLEkS4a7oyO/P5NHQ0rDI45ZnKDR8DYYDnX5w4ONNOGmfx6DG9h2BlZYxDBbqixCoWtJh
	UNURAvudRgCza9pwOLaoBzB31IZA65f7OKzrbUah7nYtCsfNZTh8VKtCYXV9DgJtulc8WDf5
	hgenbjXisGH5Dw7VxS0onB0y8WHrQjEKc3osfNhrdWKw7214sBdjqDAAZm1VgzLjBfk8xmwq
	wxi1agUwptIZPqNvsOPM0KoOZZ42+jPtTbk4s9hcgjHTE90401du4DP52d9wZqFwA2dMDiX/
	gjDKNSiOTUrIYOXHzl5zjX/u2J7a5Hs9u2yGrwS9+/OAC0GTgfRwnhn9Z3fa+qENzwOuBEVW
	A/qHpgDjAoq8w6ONDy9xxskjdIdDDTgLSYSu0r4GXAEhhzG6aaAP4YJdZAi94jRtlVHSh35g
	H+VzFpCh9LtOx+ac2Lx2gC7TBHF0IcPonvGDHKnNDW2LSA0EVWBbE9jNpsamKmKksgCxQiJT
	pCdLxbEpsnaw9cc5DyPQK+EgIAkg2iHorw+NpDBJhiJTNghoAhEJBU+0YZGUIE6SmcXKU6Ll
	6UmsYhB4Eqhoj6A/50wERUolaWwiy6ay8v8pj3DxUAKZv7PGUBSl3rnh5nZvxNgtb53vcVsf
	vtL407r6/upIjFY8a+m6UakUZ4WLPCOmHQXyUGm68FzwvruHsl56Ay8WI83DS/YU43lKcDg6
	fv3ERW93n8SuubXZy7O2F3T3YgK9d0rmW1F+6lOXHkNXOk9OlOTqpapAv+XT4b90UIQq4iUB
	/ohcIfkLwMrBLsMCAAA=
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two functions, extcon_find_cable_index() and
extcon_get_edev_by_phandle(). They are not longer needed, since
extcon client API has changed to be oriented on extcon_cable instead
of extcon_dev.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-class.c |   67 -----------------------------------------
 include/linux/extcon.h        |   18 -----------
 2 files changed, 85 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 708b352..2be0ac9 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -283,32 +283,6 @@ int extcon_set_state(struct extcon_dev *edev, u32 state)
 EXPORT_SYMBOL_GPL(extcon_set_state);
 
 /**
- * extcon_find_cable_index() - Get the cable index based on the cable name.
- * @edev:	the extcon device that has the cable.
- * @cable_name:	cable name to be searched.
- *
- * Note that accessing a cable state based on cable_index is faster than
- * cable_name because using cable_name induces a loop with strncmp().
- * Thus, when get/set_cable_state is repeatedly used, using cable_index
- * is recommended.
- */
-int extcon_find_cable_index(struct extcon_dev *edev, const char *cable_name)
-{
-	int i;
-
-	if (edev->supported_cable) {
-		for (i = 0; edev->supported_cable[i]; i++) {
-			if (!strncmp(edev->supported_cable[i],
-				cable_name, CABLE_NAME_MAX))
-				return i;
-		}
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(extcon_find_cable_index);
-
-/**
  * extcon_get_cable_state_() - Get the status of a specific cable.
  * @edev:	the extcon device that has the cable.
  * @index:	cable index that can be retrieved by extcon_find_cable_index().
@@ -876,47 +850,6 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
-#ifdef CONFIG_OF
-/*
- * extcon_get_edev_by_phandle - Get the extcon device from devicetree
- * @dev - instance to the given device
- * @index - index into list of extcon_dev
- *
- * return the instance of extcon device
- */
-struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
-{
-	struct device_node *node;
-	struct extcon_dev *edev;
-
-	if (!dev->of_node) {
-		dev_err(dev, "device does not have a device node entry\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	node = of_parse_phandle(dev->of_node, "extcon", index);
-	if (!node) {
-		dev_err(dev, "failed to get phandle in %s node\n",
-			dev->of_node->full_name);
-		return ERR_PTR(-ENODEV);
-	}
-
-	edev = of_extcon_get_extcon_dev(node);
-	if (!edev) {
-		dev_err(dev, "unable to get extcon device : %s\n", node->name);
-		return ERR_PTR(-ENODEV);
-	}
-
-	return edev;
-}
-#else
-struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
-{
-	return ERR_PTR(-ENOSYS);
-}
-#endif /* CONFIG_OF */
-EXPORT_SYMBOL_GPL(extcon_get_edev_by_phandle);
-
 static int __init extcon_class_init(void)
 {
 	return create_extcon_class();
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index a571cad..939a7b0 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -210,8 +210,6 @@ extern int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
  * They are used to access the status of each cable based on the cable_name
 tt or cable_index, which is retrieved by extcon_find_cable_index
  */
-extern int extcon_find_cable_index(struct extcon_dev *sdev,
-				   const char *cable_name);
 extern int extcon_get_cable_state_(struct extcon_dev *edev, int cable_index);
 extern int extcon_set_cable_state_(struct extcon_dev *edev,
 				  int cable_index, bool cable_state);
@@ -252,11 +250,6 @@ extern int extcon_register_notifier(struct extcon_dev *edev,
 extern int extcon_unregister_notifier(struct extcon_dev *edev,
 				      struct notifier_block *nb);
 
-/*
- * Following API get the extcon device from devicetree.
- * This function use phandle of devicetree to get extcon device directly.
- */
-extern struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index);
 #else /* CONFIG_EXTCON */
 static inline int extcon_dev_register(struct extcon_dev *edev)
 {
@@ -281,12 +274,6 @@ static inline int extcon_update_state(struct extcon_dev *edev, u32 mask,
 	return 0;
 }
 
-static inline int extcon_find_cable_index(struct extcon_dev *edev,
-					  const char *cable_name)
-{
-	return 0;
-}
-
 static inline int extcon_get_cable_state_(struct extcon_dev *edev,
 					  int cable_index)
 {
@@ -341,10 +328,5 @@ static inline int extcon_unregister_interest(struct extcon_cable_nb
 	return 0;
 }
 
-static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
-							    int index)
-{
-	return ERR_PTR(-ENODEV);
-}
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.7.9.5

