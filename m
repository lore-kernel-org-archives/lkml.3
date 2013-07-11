Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3GKQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:16:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:63525 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:16:27 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v5 0/7] Sound support for at91sam9x5-wm8731 based boards
Date: Thu, 11 Jul 2013 18:15:52 +0200
Message-Id: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset add sound on the at91sam9x5ek board.
It's based on Nicolas Ferre's work in the 2.6.39 atmel patch for sam9x5:
https://github.com/linux4sam/linux-at91/commit/0aa157c9e71ccccf3abc30fa37eb5c95b392978d

It needs Bo Chen's patchset on the generic dmaengine (topic/atmel branch
on Mark's sound tree) and the SSC interrupts disabled (cf
http://www.spinics.net/lists/arm-kernel/msg256901.html)

Outstanding issue:
If this machine driver will support more SoCs maybe we should name it differently.


It has been tested on at91sam9g35ek, and should work on g15, g25, x25 and x35 also.

patches applies on next-20130711

[I let the original signed-off from Nicolas and Uwe in place, I don't
know if I should replace them by something like "originaly-signed-off-by"
since the code has been changed.]

Changes from v4:
 * Move the rates constraints into the codec
 * Hard code the DAI format since it cannot be changed anyway (and
remove the DT bindings accordingly)
 * Add some consistency in the functions naming (sam9x5ek/at91sam9x5ek/sam9x5)
 * Retrieve the SSC id from the SSC controller phandle
 * Clarify the atmel-ssc.txt documentation
 * Develop audio-routing documentation
 * Tidy up the includes in the machine driver

Changes from v3:
 * Remove the use of macros in device tree documentation.

Changes from v2:
 * Change atmel,sam9x5-audio-wm8731 to atmel,sam9x5-wm8731-audio for
consistency with sam9g20 machine driver.
 * Use the snd_pcm_hw_constraint() API as suggested by Mark and Lars-Peter.
 * Remove the unnecessary snd_soc_dapm_sync() call as Lars-Peter suggested.
 * Add documentation for machine driver DT binding.
 * Update atmel-ssc DT binding documentation.
 * Add GPL license instead of just the "GPL" word (hope that's ok !)

Changes from v1-RFC:
 * drop patches on SSC since Bo Chen already did the work
 * reorder patches to have the machine driver first
 * drop code already handled by the ASoC framework
 * drop unneeded SND_ATMEL_SOC_PDC config selection
 * use static snd_soc_card and  snd_soc_dai_link structures.

Best regards,
Richard.

Nicolas Ferre (1):
  sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards

Richard Genoud (6):
  sound: codec: wm8731: add rates constraints
  Documentation: DT: update atmel SSC with DMA binding
  ARM: AT91: DTS: sam9x5: add SSC DMA parameters
  ARM: AT91: DTS: sam9x5ek: add WM8731 codec
  ARM: AT91: DTS: sam9x5ek: enable SSC
  ARM: AT91: DTS: sam9x5ek: add sound configuration

 .../devicetree/bindings/misc/atmel-ssc.txt         |   23 ++-
 .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |   41 ++++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    3 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   24 +++
 sound/soc/atmel/Kconfig                            |   10 +
 sound/soc/atmel/Makefile                           |    2 +
 sound/soc/atmel/sam9x5_wm8731.c                    |  207 ++++++++++++++++++++
 sound/soc/codecs/wm8731.c                          |   57 +++++-
 8 files changed, 363 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
 create mode 100644 sound/soc/atmel/sam9x5_wm8731.c

-- 
1.7.10.4

