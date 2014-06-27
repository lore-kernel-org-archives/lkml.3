Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaF0T4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:56:50 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45092 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaF0T4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:56:46 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH 0/3] Add support for limited i2c tunnel for exynos5250-spring
Date: Fri, 27 Jun 2014 12:56:10 -0700
Message-Id: <1403898973-19571-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches series possibly adds support for getting to the battery
and tps65090 device on exynos5250-spring.  I have simulated things on
exynos5420-peach-pit and found that this seems to work OK and I can
talk to both the battery and tps65090.  I have simulated this on
exynos5250-snow and found that it properly detects that the full I2C
passhtrough isn't available.  I don't have a Spring (or Skate) setup
for upstream testing right now but I figured possibly Andreas would be
interested in testing this.

As discussed in patch #3 this code path on the EC is not actually
exercised on production kernels but I think it should be solid and get
us up and running quickly.  I think this is also a cleaner solution
than what's in production kernels but possibly folks will be able to
come up with benefits of and arguments for using the specialized
regulator and battery commands to talk to the EC.

Someone interested in using this should add the cros ec tunnel to
their spring device tree and see what happens.  Note that this limited
tunnel doesn't actually export anything that's useful for i2cdetect to
use so to test you pretty much just need to add an sbs_battery and see
if it works.

I may not have tons of time for spinning this series so possibly
someone in the community who is interested in getting
exynos5250-spring supported would be interested in following up with
any needed review feedback.  I certainly wouldn't be offended.

As is probably obvious this patch series is based atop all of the
existing posted (and ACKed) cros_ec cleanups that I've sent up.


Doug Anderson (3):
  regmap: cache: regcache_hw_init() should use regmap_bulk_read()
  mfd: cros_ec: Use the proper size when looking at the cros_ec_i2c
    result
  i2c: cros_ec: Support a limited i2c tunnel for exynos5250-spring

 drivers/base/regmap/regcache.c          |  2 +-
 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 92 ++++++++++++++++++++++++++++++++-
 drivers/mfd/cros_ec_i2c.c               | 15 ++++--
 3 files changed, 104 insertions(+), 5 deletions(-)

-- 
2.0.0.526.g5318336

