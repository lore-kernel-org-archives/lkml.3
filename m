Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaDOUV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:21:29 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:39574 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaDOUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:21:28 -0400
From: Doug Anderson <dianders@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, devicetree@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@kernel.org>,
        Simon Glass <sjg@chromium.org>, linux-doc@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Pawel Moll <pawel.moll@arm.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Sean Paul <seanpaul@chromium.org>, Michael Spang <spang@chromium.org>
Subject: [PATCH 0/3] Fixes for tps65090 for Samsung ARM Chromebook
Date: Tue, 15 Apr 2014 13:14:33 -0700
Message-Id: <1397592876-5741-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches bring tps65090 up to speed with what's currently
in the Chromium OS kernel 3.8 tree and running on the Samsung ARM
Chromebook.  Changes were tested atop the current linux tree
(v3.15-rc1).  FET retries were tested on a machine with a known flaky
tps65090.  Since display isn't working on pure upstream, I augmented
the code to turn FET1 (vcd_led) on/off 500 times at bootup.  When
testing I included <https://patchwork.kernel.org/patch/3980731/> to
make sure tps65090 was in exynos5250-snow's device tree.


Doug Anderson (3):
  mfd: tps65090: Allow charger module to be used when no irq
  mfd: tps65090: Stop caching registers
  regulator: tps65090: Make FETs more reliable

 .../devicetree/bindings/regulator/tps65090.txt     |   4 +
 drivers/mfd/tps65090.c                             |  24 ++-
 drivers/power/tps65090-charger.c                   |  76 ++++++--
 drivers/regulator/tps65090-regulator.c             | 197 +++++++++++++++++++--
 include/linux/mfd/tps65090.h                       |   5 +
 5 files changed, 264 insertions(+), 42 deletions(-)

-- 
1.9.1.423.g4596e3a

