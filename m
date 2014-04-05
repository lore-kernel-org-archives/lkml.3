Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaDEVgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:36:42 -0400
Received: from ring0.de ([5.45.105.125]:47043 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaDEVgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:36:39 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
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
Subject: [PATCH 0/5] DT support for N900 soundcard (rx51-audio)
Date: Sat,  5 Apr 2014 23:35:48 +0200
Message-Id: <1396733753-9820-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
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

The patches can be applied cleanly to torvalds/linux.git:master
and broonie/sound.git:for-next.

-- Sebastian

Pali Rohár (1):
  ASoC: omap: rx51: Use devm_snd_soc_register_card

Sebastian Reichel (4):
  ASoC: Allow Aux Codecs to be specified using DT
  ASoC: RX-51: Add DT support to sound driver
  ASoC: RX-51: Convert to table based DAPM setup
  ASoC: tlv320aic3x: fix shared reset pin for DT

 .../devicetree/bindings/sound/nokia,rx51.txt       |  27 +++
 include/sound/rx51.h                               |  18 ++
 include/sound/soc.h                                |  13 +-
 sound/soc/codecs/tlv320aic3x.c                     |   9 +-
 sound/soc/omap/omap-mcbsp.c                        |   5 +-
 sound/soc/omap/omap-mcbsp.h                        |   2 +-
 sound/soc/omap/rx51.c                              | 248 +++++++++++++--------
 sound/soc/soc-core.c                               |  68 +++---
 8 files changed, 266 insertions(+), 124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/nokia,rx51.txt
 create mode 100644 include/sound/rx51.h

-- 
1.9.1

