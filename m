Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbANI3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:29:35 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:42329 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbbANI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:29:33 -0500
X-ASG-Debug-ID: 1421223465-0759e7543ba831f0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH RESEND 00/13] ltc2952 modernization and new functionality
Date: Wed, 14 Jan 2015 09:15:33 +0100
X-ASG-Orig-Subj: [PATCH RESEND 00/13] ltc2952 modernization and new functionality
Message-ID: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.149]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1421223465
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: https://filter1.ibarracuda.nl:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.14271
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Here's a resend of an earlier cleanup and improvement series for the ltc2952
driver.

This series implements devm_* usage, reduction of globals, some cleanup and
finally makes the input trigger optional.

>From the changes to the previous submissions I did not include renaming kill to
poweroff. The name poweroff is already used a lot. Besides that, the control
is referred to as kill in the ltc2952 datasheet.

Thanks,
Frans

Frans Klaver (13):
  power: reset: ltc2952: prefer devm_kzalloc over kzalloc
  power: reset: ltc2952: prefer devm_request_irq over request_irq
  power: reset: ltc2952: unroll gpio_desc array
  power: reset: ltc2952: prefer devm_gpiod_get over gpiod_get
  power: reset: ltc2952: reduce dependency on global variables
  power: reset: ltc2952: remove global variable poweroff_panic
  power: reset: ltc2952: drop empty suspend/resume functions
  power: reset: ltc2952: cleanup control flow in poweroff_handler
  power: reset: ltc2952: remove C++ style function pointers
  power: reset: ltc2952: disable timers in _remove
  power: reset: ltc2952: check trigger value before starting timer
  power: reset: ltc2952: make trigger input optional
  power: reset: ltc2952: document optional trigger behavior

 .../bindings/power/reset/ltc2952-poweroff.txt      |  13 +-
 drivers/power/reset/ltc2952-poweroff.c             | 290 +++++++++------------
 2 files changed, 129 insertions(+), 174 deletions(-)

-- 
2.1.0

