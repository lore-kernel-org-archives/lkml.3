Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbbAVQrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:47:43 -0500
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:34179 "EHLO
	18.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbAVQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:47:42 -0500
X-Greylist: delayed 3588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 11:47:42 EST
From: clement.perrochaud@effinnov.com
To: linux-nfc@ml01.01.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
	<clement.perrochaud@effinnov.com>,
        sunil.jogi@nxp.com, jerome.pele@nxp.com,
        Charles.Gorand-Effinnov@nxp.com, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        davem@davemloft.net, grant.likely@linaro.org,
        clement.perrochaud@nxp.com, lefrique@marvell.com,
        christophe.ricard@gmail.com, cuissard@marvell.com, bzhao@marvell.com,
        hirent@marvell.com, akarwar@marvell.com,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] NFC: nxp-nci: Add support for NXP-NCI NFC controllers
Date: Thu, 22 Jan 2015 16:27:36 +0100
Message-Id: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1653946963475884841
X-Ovh-Remote: 109.190.171.176 (176-171-190-109.dsl.ovh.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clément Perrochaud <clement.perrochaud@effinnov.com>

This patch brings support for the NXP-NCI NFC controllers family.

It has been successfully tested on the following SoC boards:
 - BeagleBone
 - BeagleBone Black
 - Raspberry Pi B
 - Raspberry Pi B+

The submission is broken into four patches:
 - The first one adds firmware download support to NCI ;
 - The second one adds the NXP-NCI driver's core ;
 - The third one adds I2C support to the driver ;
 - The fourth one allows for module removal during download.

It is based on 767dec21d7f5a9787401ff44568852cb3782de64 (Merge tag
'nfc-next-3.19-1' of nfc-next into wireless-next) from the nfc-next master
branch.

Clément Perrochaud (4):
  NFC: nci: Add FWDL support
  NFC: nxp-nci: Add support for NXP NCI chips
  NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver
  NFC: nxp-nci: Allow module removal during download

 .../devicetree/bindings/net/nfc/nxp-nci.txt        |  35 ++
 MAINTAINERS                                        |   9 +-
 drivers/nfc/Kconfig                                |   2 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/nxp-nci/Kconfig                        |  24 ++
 drivers/nfc/nxp-nci/Makefile                       |  11 +
 drivers/nfc/nxp-nci/core.c                         | 186 ++++++++
 drivers/nfc/nxp-nci/firmware.c                     | 324 ++++++++++++++
 drivers/nfc/nxp-nci/i2c.c                          | 468 +++++++++++++++++++++
 drivers/nfc/nxp-nci/nxp-nci.h                      |  91 ++++
 include/linux/platform_data/nxp-nci.h              |  27 ++
 include/net/nfc/nci_core.h                         |   1 +
 net/nfc/nci/core.c                                 |  11 +
 13 files changed, 1189 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
 create mode 100644 drivers/nfc/nxp-nci/Kconfig
 create mode 100644 drivers/nfc/nxp-nci/Makefile
 create mode 100644 drivers/nfc/nxp-nci/core.c
 create mode 100644 drivers/nfc/nxp-nci/firmware.c
 create mode 100644 drivers/nfc/nxp-nci/i2c.c
 create mode 100644 drivers/nfc/nxp-nci/nxp-nci.h
 create mode 100644 include/linux/platform_data/nxp-nci.h

-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com

