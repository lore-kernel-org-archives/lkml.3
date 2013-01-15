Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3AON35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:29:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46181 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab3AON3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:29:55 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 00/10] video: da8xx-fb: runtime timing configuration
Date: Tue, 15 Jan 2013 19:00:50 +0530
Message-ID: <cover.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series makes da8xx-fb driver (device found on DaVinci and AM335x)
capable of handling runtime timing configuration by adding fb_set_par.

The last change adds actual fb_set_par support. Other preceeding
changes makes the way clear for it as well as does certain cleanup's
on the way.

This has been tested on da850 evm as is. This was also tested on
am335x-evm & am335x-evmsk with a series that adds DT support.

This is based on v3.8-rc3, this is the only change in this revision.
The new version of this series is being posted so that this series can
be applied easily (as __dev* are removed, there would be merge
conflicts with v2, which was based on -rc2).
series

Regards
Afzal

v3: rebased over -rc3, no functional changes
v2: disable raster in fb_set_par properly

Afzal Mohammed (10):
  video: da8xx-fb: fb_check_var enhancement
  video: da8xx-fb: simplify lcd_reset
  video: da8xx-fb: use modedb helper to update var
  video: da8xx-fb: remove unneeded "var" initialization
  video: da8xx-fb: store current display information
  video: da8xx-fb: store clk rate even if !CPUFREQ
  video: da8xx-fb: pix clk and clk div handling cleanup
  video: da8xx-fb: store struct device *
  video: da8xx-fb: report correct pixclock
  video: da8xx-fb: fb_set_par support

 drivers/video/da8xx-fb.c |  185 ++++++++++++++++++++++++++--------------------
 1 file changed, 105 insertions(+), 80 deletions(-)

-- 
1.7.9.5

