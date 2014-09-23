Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaIWKMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:12:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55671 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326AbaIWKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:12:05 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/7] usb: add support for the generic PHY framework
Date: Tue, 23 Sep 2014 12:11:55 +0200
Message-Id: <1411467122-21440-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches can also be found at:
git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy

The series applies on top of Sergei generic PHY support in HCD[1]
and on top of Peter Chen's ci-for-usb-next branch[2].

Thanks a lot!

Antoine

Changes since v5:
	- rebased on the latest version of Sergei's series[1]
	- fixed one modifiaction made in the wrong patch

Changes since v4:
        - reworked the PHY handling in ci_hdrc_probe()
        - fixed a rebase error
        - rebased on top of [3]

Changes since v3:
        - moved phy_exit() after phy_power_on()
        - fixed the PHY handling in ci_hdrc_probe()
        - some little fixes

Changes since v2:
        - rebased the series on top of v3.17-rc1 (and [2])
        - switched to devm_phy_get() to handle non DT cases
        - moved usb_otg into the ci_hdrc structure

Changes since v1:
        - rebased the series on top of [2] (generic PHY support for HCD)
        - split s/phy/usb_phy/ renaming and generic PHY support in separate
          patches

[1] https://www.mail-archive.com/linux-usb%40vger.kernel.org/msg48068.html
[2] git://github.com/hzpeterchen/linux-usb.git ci-for-usb-next

Antoine Tenart (7):
  usb: move the OTG state from the USB PHY to the OTG structure
  usb: rename phy to usb_phy in OTG
  usb: add support to the generic PHY framework in OTG
  usb: allow to supply the PHY in the drivers when using HCD
  usb: rename transceiver and phy to usb_phy in ChipIdea
  usb: chipidea: move usb_otg into struct ci_hdrc
  usb: chipidea: add support to the generic PHY framework in ChipIdea

 drivers/phy/phy-omap-usb2.c         | 14 ++----
 drivers/usb/chipidea/ci.h           |  8 +++-
 drivers/usb/chipidea/ci_hdrc_imx.c  |  2 +-
 drivers/usb/chipidea/ci_hdrc_msm.c  |  8 ++--
 drivers/usb/chipidea/core.c         | 89 ++++++++++++++++++++++++++--------
 drivers/usb/chipidea/debug.c        |  2 +-
 drivers/usb/chipidea/host.c         | 10 ++--
 drivers/usb/chipidea/otg_fsm.c      | 30 +++++-------
 drivers/usb/chipidea/udc.c          |  4 +-
 drivers/usb/common/usb-otg-fsm.c    |  8 ++--
 drivers/usb/core/hcd.c              |  7 +--
 drivers/usb/host/ohci-omap.c        |  2 +-
 drivers/usb/musb/am35x.c            | 28 +++++------
 drivers/usb/musb/blackfin.c         | 18 +++----
 drivers/usb/musb/da8xx.c            | 28 +++++------
 drivers/usb/musb/davinci.c          | 18 +++----
 drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++------------------
 drivers/usb/musb/musb_dsps.c        | 26 +++++-----
 drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
 drivers/usb/musb/musb_host.c        |  8 ++--
 drivers/usb/musb/musb_virthub.c     | 22 ++++-----
 drivers/usb/musb/omap2430.c         | 30 ++++++------
 drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
 drivers/usb/musb/ux500.c            | 10 ++--
 drivers/usb/phy/phy-ab8500-usb.c    | 16 +++----
 drivers/usb/phy/phy-fsl-usb.c       | 23 ++++-----
 drivers/usb/phy/phy-generic.c       |  6 +--
 drivers/usb/phy/phy-gpio-vbus-usb.c | 14 +++---
 drivers/usb/phy/phy-isp1301-omap.c  | 10 ++--
 drivers/usb/phy/phy-msm-usb.c       | 95 +++++++++++++++++++------------------
 drivers/usb/phy/phy-mv-usb.c        | 50 +++++++++----------
 drivers/usb/phy/phy-samsung-usb2.c  |  2 +-
 drivers/usb/phy/phy-tahvo.c         |  8 ++--
 drivers/usb/phy/phy-ulpi.c          |  6 +--
 include/linux/usb/chipidea.h        |  4 +-
 include/linux/usb/otg.h             |  7 ++-
 include/linux/usb/phy.h             |  1 -
 37 files changed, 421 insertions(+), 363 deletions(-)

-- 
1.9.1

