Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3J0VZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:25:05 -0400
Received: from ring0.de ([91.143.88.219]:59998 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3J0VZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:25:01 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@debian.org>
Subject: [RFC 0/4] DT support for rx51-audio
Date: Sun, 27 Oct 2013 22:24:42 +0100
Message-Id: <1382909086-10493-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds DT support in rx51-audio. I tested it on the Nokia N900
and was able to play sound with aplay using earphones and earspeaker. The
Loudspeakers did not work. I don't know the reason.

The patchset consists of 4 patches:

1. convert rx51-audio to snd_soc_register_card()
2. init audio in rx51 platform file
3. add some DT helpers to ASoC core
4. add DT support to rx51-audio

Please note, that the patch is RFC level for now. For example non DT boot
does not work, because I did not yet add pdata in boardcode.

Proposed DTS node would look like this:

sound: rx51-audio {
       compatible = "nokia,rx51-audio";

       ti,mcbsp = <&mcbsp2>;
       ti,codec = <&tlv320aic3x>;
       ti,codec_aux = <&tlv320aic3x_aux>;
       ti,headset_amp = <&tpa6130a2>;

       tvout-selection-gpio = <&gpio2 8 GPIO_ACTIVE_HIGH>; /* 40 */
       jack-detection-gpio = <&gpio6 17 GPIO_ACTIVE_HIGH>; /* 177 */
       eci-sw-gpio = <&gpio6 22 GPIO_ACTIVE_HIGH>; /* 182 */
       speaker-amp-gpio = <&twl_gpio 7 GPIO_ACTIVE_HIGH>;
};

-- Sebastian

Pali Rohár (2):
  ASoC: omap: rx51: Use snd_soc_register_card
  ARM: OMAP: rx51: Register audio device

Sebastian Reichel (2):
  ASoC: Allow Aux Codecs to be specified using DT
  ASoC: RX-51: Add DT support to sound driver

 .../devicetree/bindings/sound/nokia,rx51.txt       |  28 +++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  11 ++
 include/sound/rx51.h                               |  18 ++
 include/sound/soc.h                                |  13 +-
 sound/soc/omap/omap-mcbsp.c                        |   5 +-
 sound/soc/omap/omap-mcbsp.h                        |   2 +-
 sound/soc/omap/rx51.c                              | 212 +++++++++++++++------
 sound/soc/soc-core.c                               |  68 +++++--
 9 files changed, 277 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/nokia,rx51.txt
 create mode 100644 include/sound/rx51.h

-- 
1.8.4.rc3

