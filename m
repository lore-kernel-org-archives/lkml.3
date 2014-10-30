Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbaJ3Lgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:36:52 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49925 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758803AbaJ3Lgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:36:50 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] usb: chipidea: setup ci_hdrc_platform_data in core driver
Date: Thu, 30 Oct 2014 12:36:41 +0100
Message-Id: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series introduce the ci_hdrc_get_platdata function to help setting up the
ChipIdea internal ci_hdrc_platform_data structure. This helps avoiding
duplicating code.

This series comes from a duscission on Berlin's USB pacthes where it was asked
to move the PHY phandle handling in the ChipIdea core[1].

With the introduction of the ci_hdrc_get_platdata function, the old
ci_get_platdata function is removed. Changes in ChipIdea drivers have also been
made.

This series is needed for the Berlin USB support and has been tested with an
updated version of the USB Berlin driver (not in mainline yet).

Thanks,

Antoine

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292383.html

Antoine Tenart (6):
  usb: chipidea: add a core function to setup ci_hdrc_platform_data
  usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_imx
  usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_msm
  usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_pci
  usb: chipidea: use ci_hdrc_get_platdata in ci_hdrc_zevio
  usb: chipidea: remove obsolete ci_get_platdata function

 drivers/usb/chipidea/ci_hdrc_imx.c   |  14 ++--
 drivers/usb/chipidea/ci_hdrc_msm.c   |  10 ++-
 drivers/usb/chipidea/ci_hdrc_pci.c   |  12 ++-
 drivers/usb/chipidea/ci_hdrc_zevio.c |   8 +-
 drivers/usb/chipidea/core.c          | 146 ++++++++++++++++++++++++++++-------
 include/linux/usb/chipidea.h         |   2 +
 6 files changed, 150 insertions(+), 42 deletions(-)

-- 
2.1.0

