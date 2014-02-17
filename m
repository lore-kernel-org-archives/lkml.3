Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaBQRAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:00:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39990 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbaBQRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:00 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 00/15] Update locking for snd_soc_dapm_xxxx_pin functions
Date: Mon, 17 Feb 2014 16:51:28 +0000
Message-Id: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the locking around the
snd_soc_dapm_xxxx_pin functions. First we add a locked
version of the functions and add locking to the standard
call, this also requires us to remove the few places where
these functions are externally locked. Then we patch usages
of the functions that look like they are expecting to do an
atomic update to do so.

Thanks,
Charles

Charles Keepax (15):
  Input - arizona-haptics: Fix double lock of dapm_mutex
  ASoC: dapm: Add locked version of snd_soc_dapm_xxxx_pin functions
  ASoC: adav80x: Update locking around use of DAPM pin API
  ASoC: wm5100: Update locking around use of DAPM pin API
  ASoC: wm8962: Update locking around use of DAPM pin API
  ASoC: wm8994: Update locking around use of DAPM pin API
  ASoC: wm8996: Update locking around use of DAPM pin API
  ASoC: mfld_machine: Update locking around use of DAPM pin API
  ASoC: ams-delta: Update locking around use of DAPM pin API
  ASoC: omap: n810: Update locking around use of DAPM pin API
  ASoC: omap: rx51: Update locking around use of DAPM pin API
  ASoC: pxa: corgi: Update locking around use of DAPM pin API
  ASoC: pxa: magician: Update locking around use of DAPM pin API
  ASoC: pxa: spitz: Update locking around use of DAPM pin API
  ASoC: pxa: tosa: Update locking around use of DAPM pin API

 drivers/extcon/extcon-arizona.c      |   12 ---
 drivers/input/misc/arizona-haptics.c |   19 -----
 include/sound/soc-dapm.h             |    8 ++
 sound/soc/codecs/adav80x.c           |   14 +++-
 sound/soc/codecs/wm5100.c            |    9 ++-
 sound/soc/codecs/wm8962.c            |   12 ++-
 sound/soc/codecs/wm8994.c            |   40 ++++++----
 sound/soc/codecs/wm8996.c            |    8 ++-
 sound/soc/intel/mfld_machine.c       |   43 ++++++++----
 sound/soc/omap/ams-delta.c           |   38 ++++++----
 sound/soc/omap/n810.c                |   20 +++--
 sound/soc/omap/rx51.c                |   20 +++--
 sound/soc/pxa/corgi.c                |   40 ++++++-----
 sound/soc/pxa/magician.c             |   20 +++--
 sound/soc/pxa/spitz.c                |   49 +++++++------
 sound/soc/pxa/tosa.c                 |   26 ++++---
 sound/soc/soc-dapm.c                 |  133 +++++++++++++++++++++++++++++++---
 17 files changed, 338 insertions(+), 173 deletions(-)

-- 
1.7.2.5

