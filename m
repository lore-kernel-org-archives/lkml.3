Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3IWDjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:39:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39894 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3IWDjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:39:37 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-67-523fb7f79b24
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [PATCH] usb: dwc3: Remove additional delay of 100ms when resuming
Date: Mon, 23 Sep 2013 09:08:28 +0530
Message-id: <1379907508-22492-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkWvf7dvsggy/PVSwO3q+3aF68ns3i
	8q45bBazl/SzWMw4v4/JYtGyVmYHNo/9c9ewexy/sZ3J4/MmuQDmKC6blNSczLLUIn27BK6M
	Y+f3sRRs56g4uHoDcwPjL7YuRk4OCQETiUWX17NC2GISF+6tB4pzcQgJLGWU+N2xhQmm6Myy
	OywQiUWMEktWT4WqmsIksWTaYxaQKjYBXYmmt7sYQWwRAVmJw1d+M4MUMQt0M0qs/fIZaAcH
	h7CAl8SLbrB1LAKqEpuaF4Ft4BXwkGjbMY8RYpuCxJvbz8B6JQRes0lsPb+BBaJBQOLb5EMs
	IHMkgBZsOsAMUS8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgQG5ul/
	zybsYLx3wPoQYzLQuInMUqLJ+cDAziuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo/t0y2Wucf3/l12xn8Uxs2cDxx0vl+7ag9o2vX/6xPYycm96
	MvuWVaHJzhOq03nsj4jy9AvfZD4bNU999gbX/Bn3tmatEUlqrY/YJbAnMfTRJM2t50S224X0
	XA07Xyf9LPnRfm+O+sWn9Qwcvn2v7PaQWBFofufIr/tRR8WerHq8lk8n/XKNixJLcUaioRZz
	UXEiAF20NJdiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd3v2+2DDJZMlrE4eL/eonnxejaL
	y7vmsFnMXtLPYjHj/D4mi0XLWpkd2Dz2z13D7nH8xnYmj8+b5AKYoxoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCWsYM46d38dSsJ2j4uDqDcwNjL/Yuhg5OSQETCTOLLvDAmGL
	SVy4tx4ozsUhJLCIUWLJ6qlQzhQmiSXTHoNVsQnoSjS93cUIYosIyEocvvKbGaSIWaCbUWLt
	l8+sXYwcHMICXhIvullBalgEVCU2NS9iArF5BTwk2nbMY4TYpiDx5vYz5gmM3AsYGVYxiqYW
	JBcUJ6XnGuoVJ+YWl+al6yXn525iBIf9M6kdjCsbLA4xCnAwKvHwRiTaBwmxJpYVV+YeYpTg
	YFYS4W3qBArxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5HxiTeSXxhsYm5qbGppYmFiZmlqQJ
	K4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyGvOYcYSMNuAZ1v5nIeSwi6xR4on9+7qXPBY
	S2nrO62qv9XxcRZFZYsdTTc5buXzeip7rWTev5UKX88+m5DMkleXHrXc69i6BfprKu0aipxd
	a22rQu+uCjIx3l0mOC30alBuis2l4JVNXCrmAd9umVnNdQgWkxK2U/m7XzmRKWfx9jc/bE4p
	sRRnJBpqMRcVJwIAz16pnb8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This delay got introduced in:
"7415f17 usb: dwc3: core: add power management support"
which reflected similar code in dwc3_core_soft_reset() function.
However, originally the delay of 100ms in dwc3_core_soft_reset() was
meant to assist USB2PHY and USB3PHY reset, not for usb_phy_init()
sequence.

We should get rid of this delay, since things will still work
fine without this.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Hi Felipe,

I remember this change for phy_init including msleep(100) was
suggested by me, after testing the patch-series for PM support
to dwc3.
Sorry for that !!

 drivers/usb/dwc3/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 474162e..e88ffae 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -691,7 +691,6 @@ static int dwc3_resume(struct device *dev)
 
 	usb_phy_init(dwc->usb3_phy);
 	usb_phy_init(dwc->usb2_phy);
-	msleep(100);
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-- 
1.7.6.5

