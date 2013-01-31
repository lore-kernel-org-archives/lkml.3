Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3AaLXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:23:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45078 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab3AaLWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:22:39 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <rob@landley.net>,
        <grant.likely@secretlab.ca>
Subject: [PATCH v3 0/4] ASoC davinci/tlv320aic3x updates, fixes & DT support
Date: Thu, 31 Jan 2013 16:53:09 +0530
Message-ID: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Convert tlv320aic3x mic bias to a supply widget and related machine driver
2. Add DT support for Davinci machine platform
3. remove __dev* attributes

This patch-set is tested on Davinci platform (DA850 EVM). This series applies on
top of tag next-20130128 git tree
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

These patches cannot be tested directly on mainline kernel (DT based).
This is because dma is not yet completely ported to Davinci ASoC. I had to add
few hacks to get Audio working on Davinci DA850 platform.

For reference, I have placed the entire working tree @ 
Tree :  https://github.com/ghebbar/linux.git
Branch : dev_next-20130128_davinci_asoc_dt_v3

changes in v3
	- drop mcasp pinctrl handler patch from seried as it is now handled
	  centrally.
	- Convert tlv320aic3x mic bias to a supply widget and related machine
	  driver
	- remove __dev* attributes

Changes in V2
	 - Remove reference to Linux & software details from DT binding

Hebbar Gururaja (3):
  ASoC: tlv320aic3x: Convert mic bias to a supply widget
  ASoC: davinci: update machine driver dapm routes
  ASoC: davinci: remove __dev* attributes

Hebbar, Gururaja (1):
  ASoC: davinci: machine: Add device tree binding

 .../bindings/sound/davinci-evm-audio.txt           |   53 ++++++
 .../devicetree/bindings/sound/tlv320aic3x.txt      |    6 +
 include/sound/tlv320aic3x.h                        |   10 ++
 sound/soc/codecs/tlv320aic3x.c                     |   83 ++++++++-
 sound/soc/codecs/tlv320aic3x.h                     |    4 +
 sound/soc/davinci/davinci-evm.c                    |  185 +++++++++++++++++---
 6 files changed, 312 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/davinci-evm-audio.txt

-- 
1.7.9.5

