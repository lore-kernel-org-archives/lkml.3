Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3AWLsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:48:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43238 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab3AWLsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:48:05 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 00/12] video: da8xx-fb: am335x DT support
Date: Wed, 23 Jan 2013 17:17:48 +0530
Message-ID: <cover.1358937685.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds DT support to da8xx-fb driver (device found on
DaVinci and AM335x SoC's). It does certain cleanup's in the process.

This series as compared to previous version uses new registration
interface for clock divider that has constraints on minimum divider
value.

This makes use of Steffen Trumtrar's v16 of display timing DT support.

Testing has been done on AM335x SoC based boards like AM335x EVM. It
has also been verified that display on DA850 EVM (non-DT boot) works
as earlier.

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
2. Series "HWMOD fixes for AM33xx PWM submodules and device tree nodes" by,
        Philip, Avinash <avinashphilip@ti.com>
3. Series v2 "clk: divider: prepare for minimum divider" by,
        me (Afzal Mohammed <afzal@ti.com>),
4. Series v2 "ARM: AM335x: LCDC platform support" by,
        me (Afzal Mohammed <afzal@ti.com>),
would be needed.

All above dependencies along with those required for testing is available
@ git://gitorious.org/x0148406-public/linux-kernel.git tags/da8xx-fb-dt-v4

Regards
Afzal

v4: use new registration for clock divider having minimum divider
    requirement and have ifdef'ery in a better way
v3: model CCF clock divider with parent propogation if CCF selected
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
  video: da8xx-fb: CCF clock divider handling

Manjunathappa, Prakash (1):
  video: da8xx-fb: fix 24bpp raster configuration

 .../devicetree/bindings/video/fb-da8xx.txt         |  37 ++++
 drivers/video/da8xx-fb.c                           | 222 ++++++++++++++++-----
 2 files changed, 206 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/fb-da8xx.txt

-- 
1.7.12

