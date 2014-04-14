Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaDNLsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:48:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49805 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaDNLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:48:40 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-96-534bcb179c45
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
Subject: [PATCH v2 06/13] extcon: extcon-class: remove unused functions
Date: Mon, 14 Apr 2014 13:46:17 +0200
Message-id: <1397475984-28001-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTcRgG8P47lx2Hq9PUPGiUDSqSdA5C/pCJkLNDQmVCRF/y5A4qOrc2
	Fd2HnK5ZhjovlGkznffNqbEcOimblw/C1DQhxUsXvKR2kWSlkZec0rcfzwPv8+ElEEEn6kck
	paaxylQmRYjzUOf2HBnk64yODSl44QstSxGw13YG9n7MhhOuLxgsnV9FYPXACAZLTGUI1H8z
	YlDfEQkdm10AauvacTiyYgIwf3gegaMLBThs6GlBoTGvHoXj3QYcPqvXo7C2UYfAeeMQB7YO
	zHJhw8QYB07nNOOw6fsODovLW1H4qd/OhW3L5SjUvR7gwp7RTQy2P/2KRhyjLc8tgB4vKuTQ
	3XYDRhfr1wBtr5zl0qYmF073/zKi9MvmQNpqzsfplZYKjJ55/wqn31RZuHSh9gdOL5f8xWn7
	uoZLF3WYwTWvW7wwKZuSlMEqReFxvMRKxxpQmE9lVv0swTSg5/gjQBAUeY4at+GPgMcuj1Cj
	H9p3zSMEZC2gTPoZjrsQkA84lH4IdRsnz1Id68XAbW8SoWoev90zQi5gVOfGBbe9yEvU1JJ1
	L0fJk9TIwtzeHT4poZocS9j+bgBlKA1zxx5kFNVbsYXsT0koh3YaKQb8GnDADHxYRbxCdSdB
	Jg5WMTJVempCcLxcZgV771z06wImDewDJAGEnvyHhuhYAcZkqLJkfYAiEKE3X2LbjfhSJkvN
	KuW3lekprKoP+BOo0Jfv0J2PEZAJTBqbzLIKVvm/5RAefhqA2v3Dzcagi1PbaH3HPXL4XRVw
	ybvzoo/+kY+JIpd3tny1NSEr0tNpVsow6RT+3sAkbdkZIuKw66b6UGNmtVI0uZNbejfKfiO7
	DGPU2/a4wSufjQFlqfJQm/OJp+SEOEcdoxuSXuYvXg1svn5wsC53mFyNzQzl+iRjYuS+EFUl
	MuJARKli/gEv4kebygIAAA==
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
index cd830b0..40a33e2 100644
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
@@ -923,47 +897,6 @@ void extcon_dev_unregister(struct extcon_dev *edev)
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
index bc680a9..28e60fb 100644
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
@@ -255,11 +253,6 @@ extern int extcon_register_notifier(struct extcon_dev *edev,
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
@@ -284,12 +277,6 @@ static inline int extcon_update_state(struct extcon_dev *edev, u32 mask,
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
@@ -351,10 +338,5 @@ static inline int extcon_unregister_interest(struct extcon_cable_nb
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

