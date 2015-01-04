Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbbADMnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 07:43:19 -0500
Received: from mout.web.de ([212.227.17.11]:55238 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbADMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 07:43:17 -0500
Message-ID: <54A9355F.4050102@users.sourceforge.net>
Date: Sun, 04 Jan 2015 13:43:11 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/13] ALSA: Deletion of some unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:DAlSvQ90SOcaQmdXwetT3IF2n7l1E5fspXnDlfP2M0R22BaN3Pm
 ecoQI3pU1oyhnqno7J95QQJYy/YhPB0TIMQA0DMp9oYQFxLLSy8Otam9Vt9osUOdFFQhHyB
 cHWxZCsxcktgDwNRFBrQcTqF+sieNSSx5nxIX/Z/os4b7/PiTFoGo9jygr/tEwi2J9mfjDO
 PXozC6FCCbaXtWN43kz4g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Jan 2015 11:50:12 +0100

Further update suggestions were taken into account after several patches
were applied from static source code analysis.

Markus Elfring (3):
  seq: Deletion of unnecessary checks before the function call "snd_midi_event_free"
  oss: Deletion of unnecessary checks before the function call "vfree"
  emu10k1: Delete an unnecessary check before the function call "kfree"
  oxygen: Delete an unnecessary check before the function call "snd_pcm_suspend"
  emux: Delete an unnecessary check before the function call "snd_sf_free"
  ASoC: Intel: Delete an unnecessary check before the function call "sst_dma_free"
  ASoC: fsi: Deletion of unnecessary checks before the function call "clk_enable"
  ASoC: Intel: Delete an unnecessary check before the function call "release_firmware"
  i2sbus: Delete an unnecessary check before the function call "snd_pcm_suspend_all"
  sb: Delete an unnecessary check before the function call "snd_emux_free"
  Deletion of checks before the function call "iounmap"
  msnd: One function call less in snd_msnd_attach() after error detection
  msnd: Fix centralized exiting from snd_msnd_attach()

 sound/aoa/soundbus/i2sbus/core.c | 13 ++++++-------
 sound/arm/aaci.c                 |  4 ++--
 sound/drivers/ml403-ac97cr.c     |  3 +--
 sound/isa/msnd/msnd_pinnacle.c   | 31 ++++++++++++++++---------------
 sound/parisc/harmony.c           |  4 +---
 sound/pci/ad1889.c               |  5 +----
 sound/pci/asihpi/hpioctl.c       |  6 ++----
 sound/pci/atiixp.c               |  3 +--
 sound/pci/atiixp_modem.c         |  3 +--
 sound/pci/aw2/aw2-alsa.c         |  4 +---
 sound/pci/bt87x.c                |  3 +--
 sound/pci/cs4281.c               |  6 ++----
 sound/pci/cs46xx/cs46xx_lib.c    |  4 ++--
 sound/pci/ctxfi/cthw20k1.c       |  5 +----
 sound/pci/ctxfi/cthw20k2.c       |  5 +----
 sound/pci/echoaudio/echoaudio.c  |  6 +-----
 sound/pci/hda/hda_intel.c        |  3 +--
 sound/pci/lola/lola.c            |  6 ++----
 sound/pci/mixart/mixart.c        |  7 +++----
 sound/pci/nm256/nm256.c          |  6 ++----
 sound/pci/rme9652/hdsp.c         |  4 +---
 sound/pci/rme9652/hdspm.c        |  4 +---
 sound/pci/rme9652/rme9652.c      |  3 +--
 sound/pci/sis7019.c              |  5 +----
 sound/pci/ymfpci/ymfpci_main.c   |  3 +--
 sound/ppc/pmac.c                 | 15 +++++----------
 26 files changed, 58 insertions(+), 103 deletions(-)

-- 
2.2.1

