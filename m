Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaD1OHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:07:41 -0400
Received: from ring0.de ([5.45.105.125]:51741 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaD1OHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:07:38 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 0/9] DT support for N900 soundcard (rx51-audio)
Date: Mon, 28 Apr 2014 16:07:18 +0200
Message-Id: <1398694047-28596-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds DT support in rx51-audio. I tested it on my
Nokia N900 and was able to play a wav file using aplay. I have
not tested the whole functionality, but output via speakers,
headphones and the related enable controls seem to work.

Changes since PATCHv1 [0]:
 * drop "ASoC: tlv320aic3x: fix shared reset pin for DT"
   (already applied)
 * drop "ASoC: RX-51: Convert to table based DAPM setup"
   (similar patch was applied to -next)
 * remove useless "card->dev = NULL;" from first patch
 * split patches from into smaller chunks
 * introduce new patch, which fixes a checkpatch warning
 * use gpiod API, which reduces the DT specific bits of
   the driver
 * rebase to newer -next checkout

[0] https://lkml.org/lkml/2014/4/5/92

-- Sebastian

Sebastian Reichel (9):
  ASoC: omap: rx51: Use static const char * const arrays
  ASoC: omap: rx51: Add module alias
  ASoC: omap: rx51: Use devm_snd_soc_register_card
  ASoC: Allow Aux Codecs to be specified using DT
  ASoC: omap: rx51: omap_mcbsp_st_add_controls: add id parameter
  ASoC: omap: rx51: get GPIO numbers via gpiod API
  ASoC: omap: rx51: Add some error messages
  ASoC: omap: rx51: Add DT support
  DTS: OMAP3-N900: Add sound support

 .../devicetree/bindings/sound/nokia,rx51.txt       |  27 +++
 arch/arm/boot/dts/omap3-n900.dts                   |  17 ++
 include/sound/soc.h                                |  13 +-
 sound/soc/omap/omap-mcbsp.c                        |   5 +-
 sound/soc/omap/omap-mcbsp.h                        |   2 +-
 sound/soc/omap/rx51.c                              | 226 +++++++++++++++------
 sound/soc/soc-core.c                               |  68 ++++---
 7 files changed, 271 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/nokia,rx51.txt

-- 
1.9.2

