Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaJGNXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:23:47 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47454 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbaJGNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:23:45 -0400
From: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>
To: <b29396@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lee.jones@linaro.org>, <maxime.coquelin@st.com>
Cc: <sameo@linux.intel.com>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <arnd@arndb.de>, <seraphin.bonnaffe@st.com>
Subject: [RFC PATCH 1/2] mfd: syscon: Document new DT binding "holes"
Date: Tue, 7 Oct 2014 15:22:27 +0200
Message-ID: <1412688148-20835-2-git-send-email-seraphin.bonnaffe@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
References: <54244655.1090801@st.com>
 <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-07_05:2014-10-07,2014-10-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT bindings to declare holes in syscon register maps.

Signed-off-by: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>
---
 Documentation/devicetree/bindings/mfd/syscon.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
index fe8150b..80ab9ca 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.txt
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -13,8 +13,13 @@ Required properties:
 - compatible: Should contain "syscon".
 - reg: the register region can be accessed from syscon
 
+Optional properties:
+- holes: Register regions that cannot be accessed within reg range.
+	 Each hole is described with its offset address, followed by its size.
+
 Examples:
 gpr: iomuxc-gpr@020e0000 {
 	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
 	reg = <0x020e0000 0x38>;
+	holes = <0x000c 0x8 0x020 0x4>;
 };
-- 
1.9.1

