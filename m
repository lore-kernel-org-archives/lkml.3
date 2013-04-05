Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179Ab3DEEWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:22:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765422Ab3DEEWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:22:01 -0400
From: Nishanth Menon <nm@ti.com>
To: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] cpufreq/regulator: Handle regulators that defer probe with device tree bindings
Date: Thu, 4 Apr 2013 23:21:46 -0500
Message-ID: <1365135708-23886-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Currently get_regulator returns -EPROBE_DEFER in the case of regulator supply
which have no device tree node or even if regulator which are depicted in device
tree node is defering it's registration for valid reasons.

This makes it impossible to use an regulator that registers itself after
cpufreq-cpu0 probe is complete. The reason for the same is regulator framework
fails to return appropriate error value when device tree binding is not actually
present as a node.

Once we fix that, we can then fix cpufreq-cpu0 to make intelligent decisions
based on return value.

Nishanth Menon (2):
  regulator: core: return err value for regulator_get if there is no DT
    binding
  cpufreq: cpufreq-cpu0: defer probe when regulator is not ready

 drivers/cpufreq/cpufreq-cpu0.c |   20 ++++++++++++++------
 drivers/regulator/core.c       |    4 ++--
 2 files changed, 16 insertions(+), 8 deletions(-)

Series is based off tag v3.9-rc5 (also applies on rafael's bleeding-edge branch)

Series is also available at:
https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-regulator-fixing-v1
git link: git://github.com/nmenon/linux-2.6-playground.git
branch: push/cpufreq-regulator-fixing-v1

Test scenarios(performed on 3.9-rc3 on beagle-XM platform):
test #1:  cpu0-supply binding is not present:
	http://pastebin.com/0SSC1HAw
test #2: cpu0-supply binding is present, but regulator defers probing:
	http://pastebin.com/HCSJqtRK
test #3: cpu0-supply binding is present, but regulator never registers (bug in DT binding)
	http://pastebin.com/guUwQcGW
test #4: cpu0-supply binding is present, regulator is available:
	http://pastebin.com/hsbBdxiz
	
Sub Note: This series might not be important for 3.9, considering the regulator
bug has been around since last year, however, it might be nice to have it fixed
up in 3.10 sometime.

Regards,
Nishanth Menon
-- 
1.7.9.5


