Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaI0BAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:00:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:61141 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaI0BAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:00:16 -0400
From: Stefan Wahren <stefan.wahren@i2se.com>
To: lgirdwood@gmail.com, broonie@kernel.org, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 0/2] regulator: add support for mxs regulator
Date: Sat, 27 Sep 2014 00:59:46 +0000
Message-Id: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V02:K0:nqIr9GYks9p3TjRIVdcwiuqds86Me7CLm19rnKuV5IB
 pNlGbXtfmzfulSlNeso3w5tp9x36oFSJbkRJvhKmMfkkE8ia1p
 z3QaTKKXMGeQdxJT95i0GzKP59EtnS2Es2Niv5vdrQsRM7sFrU
 gxPtx8qLv+4s0Xcq2f4T03TCv47VX43swDwWvta0YjBUQubmEF
 qXPup68WNWiVJECHx6w7x6gaUf/BQe9GUAvOdWkVjwz/wz+Rn+
 HEPeMYcRkDdXxnXyOwl4Qm/jqG/dETcz+K+xGwEDg8ljn7pyYE
 hsHeYi+rUO2gWn5MWXelIPS9TD+0oONqRIeo7278tvr2iuQoBq
 4E/lYsKfZ9A0AEO6nK5VgSR8q0ABTqJXdbBE8Vm//mBcLmkvwp
 NXNf9nKS4CuD/UCH8PE4p7MkVUbzOAszK4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Freescale i.MX23, i.xM28
on-chip regulators: vddd, vdda, vddio

This driver based on the Freescale high level [1] and low level 
driver [2], but contains the following changes:

* devicetree support
* fix for regulator modes
* drop support for overall_current and brown out
* replace udelay() with schedule()
* code cleanup

The code has been tested on a I2SE Duckbill.

[1] - http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/tree/drivers/regulator/mxs-regulator.c?h=imx_2.6.35_maintain
[2] - http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/tree/arch/arm/mach-mx28/power.c?h=imx_2.6.35_maintain

Stefan Wahren (2):
  DT: add binding for mxs regulator
  regulator: add mxs regulator driver

 .../bindings/regulator/mxs-regulator.txt           |   36 ++
 drivers/regulator/Kconfig                          |   11 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/mxs-regulator.c                  |  395 ++++++++++++++++++++
 4 files changed, 443 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt
 create mode 100644 drivers/regulator/mxs-regulator.c

-- 
1.7.9.5

