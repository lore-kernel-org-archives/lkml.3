Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaACN2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48549 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaACN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:08 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] ASoC/MFD: twl4030 codec local register cache removal
Date: Fri, 3 Jan 2014 15:27:45 +0200
Message-ID: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After the twl6040 codec, now it is time for the twl4030 codec driver to loose
it's local reg cache and let the MFD core's regmap to take care of the caching.

We have different functions behind of the 0x49 i2c address in twl (where the
audio registers can be found between 0x01 - 0x49). I mark all non audio
registers as volatile for now to avoid any side effect of the caching. Gradually
other functionalities can also move their caching to regmap to simplify the code.

I have included couple of clean up patches after the local regcache removal to
the series to freshen up the code a bit.

Regards,
Peter
---
Peter Ujfalusi (11):
  MFD: twl-core: Simplify IO wrapper functions by moving common code out
  MFD: twl-core: API to set the regcache bypass for a given regmap in
    twl
  MFD: twl-core: Enable regcache for audio registers
  ASoC: twl4030: Separate write condition checking from I/O function
  ASoC: twl4030: Remove check defaults functionality
  ASoC: twl4030: Remove reset registers functionality
  ASoC: twl4030: Introduce local ctl register cache
  ASoC: twl4030: Remove local reg cache
  ASoC: twl4030: Parameter alignment fixes (for code consistency)
  ASoC: twl4030: Move the ctl cache update local to twl4030_write()
    function
  ASoC: twl4030: Pass the twl4030_priv directly to
    twl4030_can_write_to_chip()

 drivers/mfd/twl-core.c     | 190 +++++++++++++++++++----
 include/linux/i2c/twl.h    |   5 +-
 sound/soc/codecs/twl4030.c | 376 ++++++++++++++++-----------------------------
 3 files changed, 300 insertions(+), 271 deletions(-)

-- 
1.8.5.2

