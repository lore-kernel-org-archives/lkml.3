Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaKYNTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:19:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaKYNQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:32 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 13/19] usb: dwc3: core: Add DWC3 OTG specific register defines
Date: Tue, 25 Nov 2014 18:41:49 +0530
Message-ID: <1416921115-10467-14-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OTG reggister defines to DWC3 core.h

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/core.h | 68 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 7fbe736..eb2e970 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -381,6 +381,74 @@
 #define DWC3_DEPCMD_TYPE_BULK		2
 #define DWC3_DEPCMD_TYPE_INTR		3
 
+/* OTG Configuration Register */
+#define DWC3_OCFG_DISPWRCUTTOFF                (1 << 5)
+#define DWC3_OCFG_HIBDISMASK           (1 << 4)
+#define DWC3_OCFG_SFTRSTMASK           (1 << 3)
+#define DWC3_OCFG_OTGVERSION           (1 << 2)
+#define DWC3_OCFG_HNPCAP               (1 << 1)
+#define DWC3_OCFG_SRPCAP               (1 << 0)
+
+/* OTG CTL Register */
+#define DWC3_OCTL_OTG3GOERR            (1 << 7)
+#define DWC3_OCTL_PERIMODE             (1 << 6)
+#define DWC3_OCTL_PRTPWRCTL            (1 << 5)
+#define DWC3_OCTL_HNPREQ               (1 << 4)
+#define DWC3_OCTL_SESREQ               (1 << 3)
+#define DWC3_OCTL_TERMSELIDPULSE       (1 << 2)
+#define DWC3_OCTL_DEVSETHNPEN          (1 << 1)
+#define DWC3_OCTL_HOSTSETHNPEN         (1 << 0)
+
+/* OTG Event Register */
+#define DWC3_OEVT_DEVICEMODE           (1 << 31)
+#define DWC3_OEVT_XHCIRUNSTPSET                (1 << 27)
+#define DWC3_OEVT_DEVRUNSTPSET         (1 << 26)
+#define DWC3_OEVT_HIBENTRY             (1 << 25)
+#define DWC3_OEVT_IDSTSCHNG            (1 << 24)
+#define DWC3_OEVT_HRRCONFNOTIF         (1 << 23)
+#define DWC3_OEVT_HRRINITNOTIF         (1 << 22)
+#define DWC3_OEVT_ADEVIDLE             (1 << 21)
+#define DWC3_OEVT_ADEVBHOSTEND         (1 << 20)
+#define DWC3_OEVT_ADEVHOST             (1 << 19)
+#define DWC3_OEVT_ADEVHNPCHNG          (1 << 18)
+#define DWC3_OEVT_ADEVSRPDET           (1 << 17)
+#define DWC3_OEVT_ADEVSESSENDDET       (1 << 16)
+#define DWC3_OEVT_BDEVBHOSTEND         (1 << 11)
+#define DWC3_OEVT_BDEVHNPCHNG          (1 << 10)
+#define DWC3_OEVT_BDEVSESSVLDDET       (1 << 9)
+#define DWC3_OEVT_BDEVVBUSCHNG         (1 << 8)
+#define DWC3_OEVT_BSESSVLD             (1 << 3)
+#define DWC3_OEVT_HOSTNEGSTS           (1 << 2)
+#define DWC3_OEVT_SESSREQSTS           (1 << 1)
+#define DWC3_OEVT_ERR                  (1 << 0)
+
+/* OTG Event Enable Register */
+#define DWC3_OEVTEN_XHCIRUNSTPSETEN    (1 << 27)
+#define DWC3_OEVTEN_DEVRUNSTPSETEN     (1 << 26)
+#define DWC3_OEVTEN_HIBENTRYEN         (1 << 25)
+#define DWC3_OEVTEN_CONIDSTSCHNGEN     (1 << 24)
+#define DWC3_OEVTEN_HRRCONFNOTIFEN     (1 << 23)
+#define DWC3_OEVTEN_HRRINITNOTIFEN     (1 << 22)
+#define DWC3_OEVTEN_ADEVIDLEEN         (1 << 21)
+#define DWC3_OEVTEN_ADEVBHOSTENDEN     (1 << 20)
+#define DWC3_OEVTEN_ADEVHOSTEN         (1 << 19)
+#define DWC3_OEVTEN_ADEVHNPCHNGEN      (1 << 18)
+#define DWC3_OEVTEN_ADEVSRPDETEN       (1 << 17)
+#define DWC3_OEVTEN_ADEVSESSENDDETEN   (1 << 16)
+#define DWC3_OEVTEN_BDEVHOSTENDEN      (1 << 11)
+#define DWC3_OEVTEN_BDEVHNPCHNGEN      (1 << 10)
+#define DWC3_OEVTEN_BDEVSESSVLDDETEN   (1 << 9)
+#define DWC3_OEVTEN_BDEVVBUSCHNGEVNTEN (1 << 8)
+
+/* OTG Status Register */
+#define DWC3_OSTS_DEVRUNSTP            (1 << 13)
+#define DWC3_OSTS_XHCIRUNSTP           (1 << 12)
+#define DWC3_OSTS_PERIPHERALSTATE      (1 << 4)
+#define DWC3_OSTS_XHCIPORTPOWER                (1 << 3)
+#define DWC3_OSTS_BSESVLD              (1 << 2)
+#define DWC3_OSTS_VBUSVLD              (1 << 1)
+#define DWC3_OSTS_CONIDSTS             (1 << 0)
+
 /* Structures */
 
 struct dwc3_trb;
-- 
1.8.3.1

