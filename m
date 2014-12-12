Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbaLLJ0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:26:07 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35667 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933200AbaLLJ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:26:04 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] ASoC: dwc: Add device tree support to designware I2S
Date: Fri, 12 Dec 2014 09:24:59 +0000
Message-Id: <cover.1418372910.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

This patch set extends the DesignWare I2S driver to provide device
tree support and fixes a couple of small faults.

Changes v1->v2
  + Drop negative use count patch [Mark Brown]
  + Remove unnecessary debug print messages [Lars-Peter Clausen]
  + Rewrite iteration as for loop rather than do...while [Mark Brown]
  + Reorder patches to send fixes first [Mark Brown]
  + Simplify device tree code [Mark Brown]
  + Split device tree patch in two [Mark Brown]
  + Expand explanatory comment on channel configuration [Rajeev Kumar]

Arnd: I've not forgotten about updating the spear entries

Andrew Jackson (6):
  ASoC: dwc: Remove unnecessary debug messages and tests
  ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap
  ASoC: dwc: Iterate over all channels
  ASoC: dwc: Reorder code in preparation for DT support
  ASoC: dwc: Add devicetree support for Designware I2S
  ASoC: dwc: Add documentation for I2S DT

 .../devicetree/bindings/sound/designware-i2s.txt   |   32 +++
 sound/soc/dwc/Kconfig                              |    1 +
 sound/soc/dwc/designware_i2s.c                     |  294 ++++++++++++++------
 3 files changed, 248 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/designware-i2s.txt

