Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3K2OD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:03:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38345 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab3K2OD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:03:57 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 0/5] ASoC/MFD: twl6040: Remove codec driver local reg cache
Date: Fri, 29 Nov 2013 16:03:42 +0200
Message-ID: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

It was not straight forward task to remove the local reg cache from the twl6040
codec driver. I also needed to change the MFD part so it will take over the
caching of registers via regmap.
So far I have the following patches working on top of mainline kernel.

Is this close enough of what you had in mind when asked me to look at this?

twl4030 codec is going to be a bit more complicated AFAIK but it will come
eventually.

Regards,
Peter
---
Peter Ujfalusi (5):
  ASoC: twl6040: Rename twl6040_is_path_unmuted ->
    twl6040_can_write_to_chip
  ASoC: twl6040: Custom caching for sensitive DL1/2 path registers
  MFD: twl6040: reg_defaults support for regmap
  ASoC: twl6040: Remove register restore functionality
  ASoC: twl6040: Remove self managed local reg_cache support

 drivers/mfd/twl6040.c      |  92 +++++++++++++++++-
 sound/soc/codecs/twl6040.c | 227 +++++++++++++--------------------------------
 2 files changed, 155 insertions(+), 164 deletions(-)

-- 
1.8.4.2

