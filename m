Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3AONlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:41:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46776 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab3AONk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:40:58 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 00/12] video: da8xx-fb: DT support
Date: Tue, 15 Jan 2013 19:11:38 +0530
Message-ID: <cover.1358251447.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds DT support to da8xx-fb driver (device found on
DaVinci and AM335x SoC's). It does certain cleanup's in the process.

This series as compared to previous version handles configuration of
the LCDC input clock to required value if clock divider in IP cannot
take care of required pixel clock. In the case of AM335x (where there
is requirement of configuring input clock), it's clock tree has to be
updated with proper flags, relevant patch is,

"ARM: AM33XX: clock: SET_RATE_PARENT in lcd path".

There is an additional patch in this new series to make io operations
safe.

This makes use of Steffen Trumtrar's v16 of display timing DT support.

Testing has been done on AM335x SoC based boards like AM335x EVM and
AM335x EVM-SK. It has also been verified that display on DA850 EVM
(non-DT boot) works as earlier.

This series is based on v3.8-rc3,
 and is dependent on,
1. Series v16 "of: add display helper" by,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
2. Patch "da8xx: Allow use by am33xx based devices" by,
	Pantelis Antoniou <panto@antoniou-consulting.com>
3. Series v3 "video: da8xx-fb: runtime timing configuration" by,
	me (Afzal Mohammed <afzal@ti.com>)

To test this series on AM335x based boards,
1. Series v2 "ARM: dts: AM33XX: lcdc support" by,
	me (Afzal Mohammed <afzal@ti.com>),
2. Patch "ARM: AM33XX: clock: SET_RATE_PARENT in lcd path" by,
	me (Afzal Mohammed <afzal@ti.com>),
3. Series "HWMOD fixes for AM33xx PWM submodules and device tree nodes" by,
	Philip, Avinash <avinashphilip@ti.com>
would be needed.

All above dependencies along with those required for testing is available
 @git://gitorious.org/x0148406-public/linux-kernel.git tags/da8xx-fb-dt-v3.8-rc3

Regards
Afzal

v2: 2 new patches - one to configure clock rate properly (12/12)and
    other to make io operations safe (1/12)

Afzal Mohammed (11):
  video: da8xx-fb: make io operations safe
  video: da8xx-fb: enable sync lost intr for v2 ip
  video: da8xx-fb: use devres
  video: da8xx-fb: ensure non-null cfg in pdata
  video: da8xx-fb: reorganize panel detection
  video: da8xx-fb: minimal dt support
  video: da8xx-fb: invoke platform callback safely
  video: da8xx-fb: obtain fb_videomode info from dt
  video: da8xx-fb: ensure pdata only for non-dt
  video: da8xx-fb: setup struct lcd_ctrl_config for dt
  video: da8xx-fb: set upstream clock rate (if reqd)

Manjunathappa, Prakash (1):
  video: da8xx-fb: fix 24bpp raster configuration

 .../devicetree/bindings/video/fb-da8xx.txt         |   37 ++++
 drivers/video/da8xx-fb.c                           |  226 ++++++++++++++------
 2 files changed, 194 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/fb-da8xx.txt

-- 
1.7.9.5

