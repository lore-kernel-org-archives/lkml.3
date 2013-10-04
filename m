Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3JDRmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:42:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3JDRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:42:38 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ca-524efe0c233d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: SPEAr1340: static-ize SATA functions
Date: Fri, 04 Oct 2013 19:42:31 +0200
Message-id: <2240706.IfNdWNvgId@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAV2ef35BBof/WVicbXrDbrHp8TVW
	i2M7HjFZXN41h82iobuH3WLOjM2sFisv/mV2YPfYOesuu8fJCydZPDYvqffo27KK0ePpj73M
	Hp83yQWwRXHZpKTmZJalFunbJXBl/OuZwFzwjrPi+5GlLA2Mizm6GDk5JARMJG4+ecgCYYtJ
	XLi3nq2LkYtDSGARo8SiP3+ZIZwWJol/776yg1SxCVhJTGxfxQhiiwhoSvzbdI0FpIhZ4Dyj
	xLrZU1hBEsJARUevTGcCsVkEVCW2zfnNDGLzAjUcv/cJbJ2ogKfEp0lLoeKCEj8m3wOLMwvI
	S+zbP5UVwtaSWL/zONMERr5ZSMpmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgAH4mvYNxVYPFIUYBDkYlHl6LM35BQqyJZcWVuYcYJTiYlUR4Q38BhXhTEiurUovy44tK
	c1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTCynUma8mOtmNFEgf/LTW/IZrBn
	ZSWznH0Y0l49L+0pU8D/PdPSVObL1POwib4Ulv6qIblh+5vTq+KfqBw+IpSzIOrJhhsbzT2n
	mfUlFyqar8pJvOlxojDn+4IOOxady1/6bWMmCPWkLdB9FHNYTprNpUI+wrx7qfb/JuWdS5ff
	usFzd/efLBYlluKMREMt5qLiRABmGG8nXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_miphy_exit(), sata_suspend() and sata_resume() static.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-spear/spear1340.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index 3fb6834..e0e4251 100644
--- a/arch/arm/mach-spear/spear1340.c
+++ b/arch/arm/mach-spear/spear1340.c
@@ -93,7 +93,7 @@ static int sata_miphy_init(struct device *dev, void __iomem *addr)
 	return 0;
 }
 
-void sata_miphy_exit(struct device *dev)
+static void sata_miphy_exit(struct device *dev)
 {
 	writel(0, SPEAR1340_PCIE_SATA_CFG);
 	writel(0, SPEAR1340_PCIE_MIPHY_CFG);
@@ -107,7 +107,7 @@ void sata_miphy_exit(struct device *dev)
 	msleep(20);
 }
 
-int sata_suspend(struct device *dev)
+static int sata_suspend(struct device *dev)
 {
 	if (dev->power.power_state.event == PM_EVENT_FREEZE)
 		return 0;
@@ -117,7 +117,7 @@ int sata_suspend(struct device *dev)
 	return 0;
 }
 
-int sata_resume(struct device *dev)
+static int sata_resume(struct device *dev)
 {
 	if (dev->power.power_state.event == PM_EVENT_THAW)
 		return 0;
-- 
1.8.2.3


