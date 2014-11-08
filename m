Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaKHAio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:38:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaKHAim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:38:42 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Date: Sat, 08 Nov 2014 11:38:03 +1100
Subject: [PATCH 0/3] ASoC: twl4030: support routine to external VOICE source.
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108002637.6561.19002.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'voice' port of the twl4030 on my board is connected to
a GSM modem, not to the CPU.  As such it is not visible to ASLA
and normal approaches to configuring the interface (as one end of a
DAI) don't apply.

I need a way to tell the twl4030 that the connected device will
be master of 'clk' and 'FRM', and whether they are inverted.
Using device tree seems the correct approach - I am describing the
properties of the hardware attached the 'voice' port.

Using magic numbers from include/sound/soc-dai.h almost certainly
is not the right way to represent this information, but it isn't clear
to me what a good way would be.

So the current patch uses magic numbers as a proof of concept, and I'm
asking if there is any establish precedent, or any suggestions on
how to record in device tree the 'master' and 'polarity' of CLK and
FRM signals for an external device.
[I currently use (SND_SOC_DAIFMT_IB_NF | SND_SOC_DAIFMT_CBS_CFS)]

This is in the second patch.  The first silences a pointless warning
(when it is pointless) and the last allowed the voice linked to be
turned on or off via ALSA controls.

If the first and last can be applied without finalizing the
device-tree part yet, that would be great.

Thanks,
NeilBrown

---

NeilBrown (3):
      ASoC: twl4030: don't report EBUSY if no change requested.
      ASoC: twl4030: allow voice port to be connected externally.
      ASoC: twl4030: enable routing audio to 'voice' interface.


 .../devicetree/bindings/mfd/twl4030-audio.txt      |    7 ++
 include/linux/i2c/twl.h                            |    3 +
 sound/soc/codecs/twl4030.c                         |   78 ++++++++++++++++++--
 3 files changed, 82 insertions(+), 6 deletions(-)

--
Signature

