Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaBRPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:30:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640AbaBRPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:44 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 00/17 v2] Update locking for snd_soc_dapm_xxxx_pin functions
Date: Tue, 18 Feb 2014 15:22:11 +0000
Message-Id: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the locking around the
snd_soc_dapm_xxxx_pin functions. First we add an unlocked
version of the functions and add locking to the standard
call, this also requires us to remove the few places where
these functions are externally locked. Then we patch usages
of the functions that look like they are expecting to do an
atomic update to do so, using external locking.

Thanks,
Charles

Updates since v1:
 - Added helper functions to lock/unlock the dapm mutex
 - Added an unlocked version of snd_soc_dapm_sync, so it can
   be called under the same mutex lock as the pin functions,
   this is not required just saves a mutex lock

Charles Keepax (17):
  Input - arizona-haptics: Fix double lock of dapm_mutex
  ASoC: dapm: Add helpers to lock/unlock DAPM mutex
  ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions
  ASoC: dapm: Add unlocked version of snd_soc_dapm_sync
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
 drivers/input/misc/arizona-haptics.c |   19 ----
 include/sound/soc-dapm.h             |    9 ++
 include/sound/soc.h                  |    9 ++
 sound/soc/codecs/adav80x.c           |   17 +++--
 sound/soc/codecs/wm5100.c            |   12 ++-
 sound/soc/codecs/wm8962.c            |   13 ++-
 sound/soc/codecs/wm8994.c            |   45 ++++++----
 sound/soc/codecs/wm8996.c            |    9 ++-
 sound/soc/intel/mfld_machine.c       |   65 +++++++++-----
 sound/soc/omap/ams-delta.c           |   45 ++++++----
 sound/soc/omap/n810.c                |   22 +++--
 sound/soc/omap/rx51.c                |   22 +++--
 sound/soc/pxa/corgi.c                |   42 +++++----
 sound/soc/pxa/magician.c             |   22 +++--
 sound/soc/pxa/spitz.c                |   51 ++++++-----
 sound/soc/pxa/tosa.c                 |   28 ++++---
 sound/soc/soc-dapm.c                 |  160 ++++++++++++++++++++++++++++++---
 18 files changed, 399 insertions(+), 203 deletions(-)

-- 
1.7.2.5

