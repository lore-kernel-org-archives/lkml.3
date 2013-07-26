Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3GZSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:25:59 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61273 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3GZSZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:25:58 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 0/4] ALSA: Implement core jack support for kcontrol
Date: Fri, 26 Jul 2013 11:25:29 -0700
Message-Id: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This patch series enable KControl support for core Jack and update current
codecs. This will will enable moderns user-space daemons, such as
PulseAudio(>=2.0), to have jack detection support via newer ALSA KControl
interface.

Patch 1: Actually implementation using KControl.

Patch 2: It also ensures HDA drivers to use properly this new ALSA Jack
implementation.

Patches 3-4: This patch makes sure that all users of ALSA Jack uses this
new standard way to report detections to user-space.

Felipe F. Tonello (4):
  ALSA: Added jack detection kcontrol support
  ALSA: HDA: Updating jack implementation according new ALSA Jacks
  ALSA: SoC: Updating jack implementation according new ALSA Jacks
  ALSA: oxygen: Updating jack implementation according new ALSA Jacks

 include/sound/jack.h               |  6 ++++--
 include/sound/soc.h                |  2 +-
 sound/core/Kconfig                 |  1 +
 sound/core/ctljack.c               |  3 ++-
 sound/core/jack.c                  | 29 +++++++++++++++++++++++++++--
 sound/pci/hda/Kconfig              |  8 --------
 sound/pci/hda/hda_codec.h          |  2 --
 sound/pci/hda/hda_jack.c           | 38 +++++++++++++++++---------------------
 sound/pci/hda/hda_jack.h           |  4 +---
 sound/pci/oxygen/xonar_wm87x6.c    |  2 +-
 sound/soc/fsl/wm1133-ev1.c         |  4 ++--
 sound/soc/mid-x86/mfld_machine.c   |  6 +++---
 sound/soc/omap/ams-delta.c         |  2 +-
 sound/soc/omap/omap-abe-twl6040.c  |  4 ++--
 sound/soc/omap/omap-twl4030.c      |  4 ++--
 sound/soc/omap/rx51.c              |  6 +++---
 sound/soc/pxa/hx4700.c             |  4 ++--
 sound/soc/pxa/palm27x.c            |  4 ++--
 sound/soc/pxa/ttc-dkb.c            |  8 ++++----
 sound/soc/pxa/z2.c                 |  4 ++--
 sound/soc/samsung/goni_wm8994.c    |  4 ++--
 sound/soc/samsung/h1940_uda1380.c  |  4 ++--
 sound/soc/samsung/littlemill.c     | 10 +++++-----
 sound/soc/samsung/lowland.c        |  6 +++---
 sound/soc/samsung/rx1950_uda1380.c |  4 ++--
 sound/soc/samsung/smartq_wm8987.c  |  4 ++--
 sound/soc/samsung/speyside.c       |  6 +++---
 sound/soc/samsung/tobermory.c      |  4 ++--
 sound/soc/soc-jack.c               |  4 ++--
 sound/soc/tegra/tegra_alc5632.c    |  4 ++--
 sound/soc/tegra/tegra_rt5640.c     |  2 +-
 sound/soc/tegra/tegra_wm8903.c     |  8 ++++----
 32 files changed, 107 insertions(+), 94 deletions(-)

-- 
1.8.1.4

