Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLCQjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:39:24 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:42719 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518AbaLCQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:39:22 -0500
Message-ID: <547F3C8C.5000607@arm.com>
Date: Wed, 03 Dec 2014 16:38:36 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [PATCH 0/5] ASoC: dwc: Add device tree support to designware I2S
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set extends the DesignWare I2S driver to provide device
tree support and fixes a couple of small faults.

Andrew Jackson (5):
  ASoC: dwc: Allocate resources with devm_ioremap_resource
  ASoC: dwc: Don't allow negative use counts
  ASoC: dwc: Iterate over all channels
  ASoC: dwc: Add devicetree support for Designware I2S
  ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

 .../devicetree/bindings/sound/designware-i2s.txt   |   32 ++
 sound/soc/dwc/Kconfig                              |    1 +
 sound/soc/dwc/designware_i2s.c                     |  313 ++++++++++++++------
 3 files changed, 260 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/designware-i2s.txt
