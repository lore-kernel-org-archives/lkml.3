Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3LJK4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:56:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3LJK4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:56:08 -0500
X-AuditID: cbfee690-b7f676d00000310d-3f-52a6f3412729
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: [PATCH RFC 1/4] phy: Add provision for tuning phy.
Date: Tue, 10 Dec 2013 16:25:23 +0530
Message-id: <1386672926-26885-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSrev4eVmQQeciE4uD9+stmhevZ7O4
	vPASq0XHocdMFr0LrrJZXHjaAxTbNYfNYvaSfhaLGef3MVksWtbKbNF84hSzA7fH7IaLLB7z
	TgZ67J+7ht2jb8sqRo/jN7YzeXzeJBfAFsVlk5Kak1mWWqRvl8CVsbNxEnPBBIGKN1/a2BsY
	u3m7GDk5JARMJE4tn8gKYYtJXLi3nq2LkYtDSGApo8SXvQvZYYp2zt/PCGILCUxnlDjaLANR
	NIVJ4vqrnywgCTYBXYmmt7vAikQEHCSWLL0DNolZ4BajRMvUDrAVwgLWEp9vPgKbyiKgKjHj
	/AIgm4ODV8BD4u7KFIhlChJvbj9jBrE5BTwllncdYIVY7CHRdf8+M8hMCYFD7BLXpz1ihpgj
	IPFt8iEWkDkSArISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNz
	NzECo+L0v2cTdjDeO2B9iDEZaNxEZinR5HxgVOWVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyMb+82VbLNKj0c0lpuWhH0LW3OE6+VJSau+SI+E
	SaYGjw9+TE7zf2D9jXGr8v9YjuuT97F+fP6Rp61XKW01k+aqDerdpfaVDh8zuebsbFTN1Wqp
	VVQ0POY3x/hLy9fnG27cuxHj4v/S8/+0pY7r9fJ62c4FfFZbMFeDcYFb+MdNnmIXcjkCG5VY
	ijMSDbWYi4oTAQZ3s4agAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQV3Hz8uCDF7f17I4eL/eonnxejaL
	ywsvsVp0HHrMZNG74CqbxYWnPUCxXXPYLGYv6WexmHF+H5PFomWtzBbNJ04xO3B7zG64yOIx
	72Sgx/65a9g9+rasYvQ4fmM7k8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDN2Nk5iLpggUPHmSxt7A2M3bxcjJ4eEgInEzvn7GSFsMYkL99azgdhCAtMZJY42
	y3QxcgHZU5gkrr/6yQKSYBPQlWh6uwusQUTAQWLJ0jtsIEXMArcYJVqmdrCCJIQFrCU+33zE
	DmKzCKhKzDi/AMjm4OAV8JC4uzIFYpmCxJvbz5hBbE4BT4nlXQdYIRZ7SHTdv888gZF3ASPD
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgmHsmvYNxVYPFIUYBDkYlHl6Jf0uDhFgTy4or
	cw8xSnAwK4nwbnuxLEiINyWxsiq1KD++qDQntfgQYzLQUROZpUST84HpIK8k3tDYxNzU2NTS
	xMLEzJI0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGNdO/83xeFm/xwm50AliC7fJbrIU
	Vp+i5P2Kv5QjbsN72z3s/gdPexwJt24snXfExC3uvi5Hft7ynZOWdgpWOS86yjt9TzXL6rht
	y0MNLN89Tz3/NmhC1i8phZ8KWbOzcsXPPVxxr/fZkgk7Nu69NJ9R1zW/VeFqx5q4egnlg9z1
	W0+8f+EtxK3EUpyRaKjFXFScCAA6ha2V/QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PHY controllers may need to tune PHY post-initialization,
so that the PHY consumers can call phy-tuning at appropriate
point of time.

Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-core.c  |   20 ++++++++++++++++++++
 include/linux/phy/phy.h |    7 +++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..68dbb90 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -239,6 +239,26 @@ out:
 }
 EXPORT_SYMBOL_GPL(phy_power_off);
 
+int phy_tune(struct phy *phy)
+{
+	int ret = -ENOTSUPP;
+
+	mutex_lock(&phy->mutex);
+	if (phy->ops->tune) {
+		ret =  phy->ops->tune(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy tuning failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_tune);
+
 /**
  * of_phy_get() - lookup and obtain a reference to a phy by phandle
  * @dev: device that requests this phy
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..d3b32b0 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -34,6 +34,7 @@ struct phy_ops {
 	int	(*exit)(struct phy *phy);
 	int	(*power_on)(struct phy *phy);
 	int	(*power_off)(struct phy *phy);
+	int	(*tune)(struct phy *phy);
 	struct module *owner;
 };
 
@@ -127,6 +128,7 @@ int phy_init(struct phy *phy);
 int phy_exit(struct phy *phy);
 int phy_power_on(struct phy *phy);
 int phy_power_off(struct phy *phy);
+int phy_tune(struct phy *phy);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
@@ -199,6 +201,11 @@ static inline int phy_power_off(struct phy *phy)
 	return -ENOSYS;
 }
 
+static inline int phy_tune(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
 static inline struct phy *phy_get(struct device *dev, const char *string)
 {
 	return ERR_PTR(-ENOSYS);
-- 
1.7.6.5

