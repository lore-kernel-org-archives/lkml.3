Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3CBNZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3CBNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:19 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-e7-5131fdbe3617
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 01/10] usb: phy: Add APIs for runtime power management
Date: Sat, 02 Mar 2013 18:53:02 +0530
Message-id: <1362230590-20960-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWnffX8NAg657khYH79dbNC9ez2bR
	u+Aqm8WFpz1sFpd3zWGzmL2kn8Vixvl9TBaLlrUyWzSfOMXswOkx72Sgx/65a9g9+rasYvQ4
	fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGa93X2MruMVVse33TtYGxk0cXYwcHBICJhJP/8t3
	MXICmWISF+6tZ+ti5OIQEljKKLH+6WxmiISJxLWbB9ghEtMZJb5seMMGkhASmMIkcXtRMIjN
	JqAr0fR2FyOILSIgK3H4ym9mkAZmgUuMEitWbGEBSQgLeEosfdLGBGKzCKhK7Gw7AzaIV8BD
	4uen/4wQ2xQk3tx+BraZE6h++vXNrBDLPCT+3DsOdoWEwDp2iU17v7FCDBKQ+Db5EAvEO7IS
	mw5AXS0pcXDFDZYJjMILGBlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYgSG/el/z/p2MN48
	YH2IMRlo3ERmKdHkfGDc5JXEGxqbmJsam5oZWVpampImrCTOK39JJlBIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QDY+W2Z2pLNjKm233+kfqP5VuRrvp+w9s3rJsaFN5ynxb0Cyp+dvVP5MYX
	wrtrv4s+lxFVqNmysSnMzVp/+sJLnPzJ+hrhpulHX+3ecVGUPUyk6uuJ2BUq4WtreGvUVQRY
	WT0PhIpvm229VM/rzddkef2Dtda21fnLthh35i9MNXz9a3XZMadXSizFGYmGWsxFxYkAn0yy
	vpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd19fw0DDbo3CVocvF9v0bx4PZtF
	74KrbBYXnvawWVzeNYfNYvaSfhaLGef3MVksWtbKbNF84hSzA6fHvJOBHvvnrmH36NuyitHj
	+I3tTB6fN8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4vfsaW8Et
	roptv3eyNjBu4uhi5OSQEDCRuHbzADuELSZx4d56ti5GLg4hgemMEl82vGEDSQgJTGGSuL0o
	GMRmE9CVaHq7ixHEFhGQlTh85TczSAOzwCVGiRUrtrCAJIQFPCWWPmljArFZBFQldradARvE
	K+Ah8fPTf0aIbQoSb24/YwaxOYHqp1/fzAqxzEPiz73j7BMYeRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECI6rZ9I7GFc1WBxiFOBgVOLhDfhoECjEmlhWXJl7iFGCg1lJhPf8VcNA
	Id6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HxnxeSbyhsYm5qbGppYmFiZklacJK4ryMp54E
	CAmkJ5akZqemFqQWwWxh4uCUamBULF/G5vpB4uIk2dKVL3YclLDTmrPn7tI+pTOHlMpKi1es
	6Fec+PnDuZScjpUzXymWiWzfv+bjFRlp9nrjMj5lpQ1Ol989vqewz+fj+sJ1At6W7u0Xjh3u
	3M531qCoqqVu44HrC61d/50ViojXOz059YFUR/JB6S0+d2R36O9dWsz3e4GzQGOdEktxRqKh
	FnNRcSIAha8ZVu8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding  APIs to handle runtime power management on PHY
devices. PHY consumers may need to wake-up/suspend PHYs
when they work across autosuspend.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 include/linux/usb/phy.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 15847cb..0fe7cac 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -276,4 +276,30 @@ static inline const char *usb_phy_type_string(enum usb_phy_type type)
 		return "UNKNOWN PHY TYPE";
 	}
 }
+
+#define USB_PHY_AUTOPM(function)					    \
+static inline int usb_phy_autopm_##function(struct usb_phy *x)		    \
+{									    \
+	if (!x || !x->dev) {						    \
+		dev_err(x->dev, "no PHY or attached device available\n");   \
+		return -ENODEV;						    \
+	}								    \
+									    \
+	pm_runtime_##function(x->dev);					    \
+									    \
+	return 0;							    \
+}
+USB_PHY_AUTOPM(enable)
+USB_PHY_AUTOPM(disable)
+USB_PHY_AUTOPM(get)
+USB_PHY_AUTOPM(get_sync)
+USB_PHY_AUTOPM(put)
+USB_PHY_AUTOPM(put_sync)
+USB_PHY_AUTOPM(allow)
+USB_PHY_AUTOPM(forbid)
+USB_PHY_AUTOPM(suspend)
+USB_PHY_AUTOPM(autosuspend)
+USB_PHY_AUTOPM(resume)
+USB_PHY_AUTOPM(set_active)
+
 #endif /* __LINUX_USB_PHY_H */
-- 
1.7.6.5

