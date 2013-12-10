Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3LJK5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:57:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3LJK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:56:11 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-7e-52a6f3435f8e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: [PATCH RFC 2/4] xhci: Add quirk for DWC3-Exynos controller
Date: Tue, 10 Dec 2013 16:25:24 +0530
Message-id: <1386672926-26885-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSrev8eVmQwbyj+hYH79dbNC9ez2Zx
	eeElVouOQ4+ZLHoXXGWzuPC0Byi2aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB26P2Q0XWTzm
	nQz02D93DbtH35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjfLoEr4/76l0wF+wUrttw/xtLA
	OJGvi5GTQ0LAROJrQxcThC0mceHeejYQW0hgKaPE6iZBmJqPj5qB4lxA8emMEj1ft7JAOFOY
	JBa/uc4OUsUmoCvR9HYXI4gtIuAgsWTpHbAOZoFbjBItUztYQRLCAs4Sa/vXg9ksAqoSndPe
	gq3jFfCQ+Px/PhvEOgWJN7efMYPYnAKeEsu7DrBCnOQh0XX/PjPIUAmBXewSn97NZoEYJCDx
	bfIhIJsDKCErsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMj
	MC5O/3vWv4Px7gHrQ4zJQOMmMkuJJucD4yqvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTA2arR93faIPXnzb/eKr17Lyo63FNUeC+VN3Pz93ber
	l/Vq5J2u5X/jC9qhcqPo3tqiM2o90Ze5g7l1z2dLS4faLw2c1il/P/1UoZdIelyH123foCXz
	F1/vM/94LeR16dotc7851jaKfFihnBZ54WfU6zMH5thLvXp8Xn7u2S1RbyRs3MwYWLyVWIoz
	Eg21mIuKEwF2cq3+oQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQV3nz8uCDHbtV7M4eL/eonnxejaL
	ywsvsVp0HHrMZNG74CqbxYWnPUCxXXPYLGYv6WexmHF+H5PFomWtzBbNJ04xO3B7zG64yOIx
	72Sgx/65a9g9+rasYvQ4fmM7k8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDPur3/JVLBfsGLL/WMsDYwT+boYOTkkBEwkPj5qZoOwxSQu3FsPZHNxCAlMZ5To
	+bqVBcKZwiSx+M11dpAqNgFdiaa3uxhBbBEBB4klS++AdTAL3GKUaJnawQqSEBZwlljbvx7M
	ZhFQleic9hZsBa+Ah8Tn//Oh1ilIvLn9jBnE5hTwlFjedQCsXgiopuv+feYJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgTH3TPpHYyrGiwOMQpwMCrx8Er8WxokxJpYVlyZe4hR
	goNZSYR324tlQUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wJeSXxhsYm5qbGppYmFiZm
	lqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGFA1iWNXqsm+Zbpq5xf1Sp9YofYmNMFz
	bRmr4MQ36v8ko1r/vb50UThMptHNoPZj9psNq8r+Fs6arhLtxifItSDlgXqn4qTWelHLNq7Z
	Zpa9D/sZP6YXTY/+N/VWxVnfdZoX3CdUnY0OXzIn8LX342uf3ZskdJSKT/k9YJnX/HwV05k9
	LslPlFiKMxINtZiLihMBq9WV3f8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DWC3-exynos eXtensible host controller on Exynos5420 SoC
is quirky in a way that the PHY needs to be tuned to get it
working at SuperSpeed.
By default this PHY works as High-speed phy and therefore
detects even Super-speed devices as high-speed ones.
So, the PHY needs to be tuned after controller has been reset.

Adding a xHCI quirk for this purpose.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/xhci-plat.c |   19 +++++++++++++++++++
 drivers/usb/host/xhci.h      |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d9c169f..395c9e9 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -21,6 +21,25 @@
 
 static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
+	struct device *parent_dev;
+	struct device *vendor_parent_dev;
+
+	parent_dev = dev->parent;
+	vendor_parent_dev = parent_dev->parent;
+
+	/*
+	 * The DWC3-exynos host controller on Exynos5420 SoC is quirky
+	 * in a way that the PHY needs to be tuned to get it working
+	 * at SuperSpeed. By default this PHY works as High-speed phy
+	 * and so detects even Super-speed devices as high-speed ones.
+	 * Therefor the PHY needs to be tuned after controller
+	 * has been reset, since a controller reset actually forces the
+	 * PHY to fall back to its default state wherein it works as
+	 * High-Speed PHY only.
+	 */
+	if (!strstr(dev_name(vendor_parent_dev), "exynos"))
+		xhci->quirks |= XHCI_DWC3_EXYNOS;
+
 	/*
 	 * As of now platform drivers don't provide MSI support so we ensure
 	 * here that the generic code does not try to make a pci_dev from our
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7807f62..f69af8c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1560,6 +1560,7 @@ struct xhci_hcd {
 #define XHCI_PLAT		(1 << 16)
 #define XHCI_SLOW_SUSPEND	(1 << 17)
 #define XHCI_SPURIOUS_WAKEUP	(1 << 18)
+#define XHCI_DWC3_EXYNOS	(1 << 19)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.7.6.5

