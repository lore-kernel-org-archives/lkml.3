Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaCRK6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:58:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaCRK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:58:51 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-72-532826eac6cd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] ARM: SPEAr1340: static-ize SATA functions
Date: Tue, 18 Mar 2014 11:58:27 +0100
Message-id: <1678906.b5uh0Nm7QE@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd1XahrBBksW81rMWb+GzeJs0xt2
	i02Pr7FaHNvxiMni8q45bBYN3T3sFnNmbGa1WHnxL7MDh8fOWXfZPU7M+M3icfLCSRaPzUvq
	Pfq2rGL0ePpjL7PH501yAexRXDYpqTmZZalF+nYJXBlT5j9hKljNVbF2yy7mBsabHF2MnBwS
	AiYSHacnsELYYhIX7q1n62Lk4hASmM4o8ezjYXYIp4VJYsG91ywgVWwCVhIT21cxgtgiApoS
	/zZdYwEpYhb4wyixvvUCG0hCWMBR4v7yo8wgNouAqsT1vtlAkzg4eIEafvaKg4RFBTwldmxf
	CVbOKyAo8WPyPbD5zALyEvv2T2WFsLUk1u88zjSBkW8WkrJZSMpmISlbwMi8ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4pJ9J72Bc1WBxiFGAg1GJh/cFm3qwEGtiWXFl7iFGCQ5mJRHe
	EyIawUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYZeVb
	PDZOm3P2yw2L1SKFCu+Zn3w/4ar/a30dv1fU7Qkfk31DhdarChkp7dayM1OeIsWgkHT7h2hl
	YbGQltkmsxlHrr3XLGUW9Su8YdDA8XruopUlvrs+ZvB1ua+M3FiV8P4809NDXFJnjK8XKk8J
	TebiPdHwjrG75WHCj6Rv9f1Tkm7/KuhQYinOSDTUYi4qTgQAX68BVmUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sata_miphy_exit(), sata_suspend() and sata_resume() static.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Previous submission:
https://lkml.org/lkml/2013/10/4/369

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


