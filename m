Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbaFIPAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:00:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54850 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbaFIPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:00:21 -0400
Date: Mon, 9 Jun 2014 16:00:13 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 0/4] arizona: Improvements to codec DVFS control
Message-ID: <20140609150013.GA5229@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of changes cleans up the way the drivers handle
the control of internal subsystem clocks for codecs with
DVFS. This previously relied on the clock control happening
as a side-effect of changing the regulator voltage, rather
than explicitly, which assumed that you were uusing the
built-int regulator. Also DVFS control was being done from
the ADSP driver despite that driver supposedly being codec-
agnostic.
There are other cases on some codecs where DVFS control is
needed so this sequence of patches cleans up the way DVFS
is implemented and adds the extra case of DVFS boost for
higher sample rates on WM8997 and WM5102

Richard Fitzgerald (4):
  mfd: arizona: Export function to control subsystem DVFS
  ASoC: wm_adsp: Move DVFS control into codec driver
  ASoC: arizona: Add DVFS handling for sample rate control
  regulator: arizona-ldo1: Do not control clocking from regulator

 drivers/mfd/arizona-core.c       |   84 ++++++++++++++++++++++++++++++++++++++
 drivers/regulator/arizona-ldo1.c |    5 --
 include/linux/mfd/arizona/core.h |   12 +++++
 sound/soc/codecs/arizona.c       |   22 +++++++++-
 sound/soc/codecs/wm5102.c        |   47 ++++++++++++++++++++-
 sound/soc/codecs/wm5110.c        |    2 +-
 sound/soc/codecs/wm_adsp.c       |   76 +---------------------------------
 sound/soc/codecs/wm_adsp.h       |   11 +++--
 8 files changed, 170 insertions(+), 89 deletions(-)

-- 
1.7.2.5

