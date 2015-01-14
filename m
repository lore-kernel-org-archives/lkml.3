Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbbANJ45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:56:57 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48883 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbbANJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:56:54 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 0/3] Enable myphy28lp support
Date: Wed, 14 Jan 2015 10:54:56 +0100
Message-Id: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_04:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to enable the support of MiPHY28lp Generic PHY.

The first patch is to update miphy28lp phy driver to access sysconfig register
offsets via syscfg dt property. It's based on Arnds review comments here
https://lkml.org/lkml/2014/11/13/161
I have updated the miphy28lp phy driver same way as Peter's implementation.

Gabriel Fernandez (3):
  phy: miphy28lp: Pass sysconfig register offsets via syscfg dt
    property.
  ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
  ARM: multi_v7_defconfig: Enable MiPHY28lp - ST's Generic (SATA, PCIe &
    USB3) PHY

 .../devicetree/bindings/phy/phy-miphy28lp.txt      | 43 ++++++---------
 arch/arm/boot/dts/stih407-family.dtsi              | 53 +++++++++++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi               | 11 ++++
 arch/arm/configs/multi_v7_defconfig                |  1 +
 drivers/phy/phy-miphy28lp.c                        | 61 ++++++++++++----------
 5 files changed, 113 insertions(+), 56 deletions(-)

-- 
1.9.1

