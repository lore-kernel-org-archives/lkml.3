Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3FLH6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:58:11 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35754 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3FLH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:58:10 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/3] DMA fixes for ux500 ASoC driver
Date: Wed, 12 Jun 2013 09:57:56 +0200
Message-Id: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

The DMA driver used on ux500 has been recently reworked to make it
device-tree capable, but the rework required to drop some "features",
such as opportunistic channel allocation and hardcoded addresses, that
the ASoC driver was relying upon.

This series fixes the audio driver to make it work with the current
dma40 implementation, and works fine even when booting with device-tree.

Would you consider merging these for asoc/topic/ux500?

Thanks,
Fabio


Fabio Baltieri (3):
  ASoC: ux500: Move DMA parameters into ux500_msp
  ASoC: ux500: Set DMA address during device init
  ASoC: ux500: Add DMA slave config prepare routine

 sound/soc/ux500/ux500_msp_dai.c | 11 ++++-------
 sound/soc/ux500/ux500_msp_dai.h |  2 --
 sound/soc/ux500/ux500_msp_i2s.c | 13 +++++++++----
 sound/soc/ux500/ux500_msp_i2s.h | 15 ++++++++-------
 sound/soc/ux500/ux500_pcm.c     | 30 ++++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 20 deletions(-)

-- 
1.8.2

