Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEZIal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:30:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40858 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEZIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:30:39 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, dianders@chromium.org,
        swarren@wwwdotorg.org
Subject: [PATCH V2 0/2] ASoC: max98090/max98095: Add master clock handing
Date: Mon, 26 May 2014 13:58:20 +0530
Message-Id: <1401092902-20525-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These CODECs are used on Snow/Peach-pit boards and the master clock
needs to be set at 24MHz.

Adding support in respective codec drivers so that we can update the
master clock frequency from sound card driver through set_sysclk.

Changes for V2:
1. Added PROBE_DEFER if clock driver has not yet been probed
2. Moved clk_prepare_enable from .probe to .set_bias_level
3. Moved clk_disable_unprepare from .remove to .set_bias_level

Tushar Behera (2):
  ASoC: max98090: Add master clock handling
  ASoC: max98095: Add master clock handling

 .../devicetree/bindings/sound/max98090.txt         |    6 +++++
 .../devicetree/bindings/sound/max98095.txt         |    6 +++++
 sound/soc/codecs/max98090.c                        |   23 +++++++++++++++++++
 sound/soc/codecs/max98090.h                        |    1 +
 sound/soc/codecs/max98095.c                        |   24 ++++++++++++++++++++
 5 files changed, 60 insertions(+)

-- 
1.7.9.5

