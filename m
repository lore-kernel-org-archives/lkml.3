Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaJMIFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:05:36 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:60843 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaJMIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:05:29 -0400
X-ASG-Debug-ID: 1413187525-0759e7482868d810002-xx1T2L
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
        Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 0/2] Add support for ltc2952 poweroff
Date: Mon, 13 Oct 2014 10:05:11 +0200
X-ASG-Orig-Subj: [PATCH v5 0/2] Add support for ltc2952 poweroff
Message-ID: <1413187513-11178-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413187525
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10508
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 5 of the series that adds support for the ltc2952 powerpath chip.

I haven't gotten any further comments on the previous run, so here's a small update.

This series adds a driver for the LTC2952, an external power control chip, which
signals the OS to shut down. Additionally this driver lets the kernel power
down the board.

This driver was tested with:
  - kernel version 3.15.8, 3.17
  - ARM based processor (TI AM335x series)

v4..v5
  - Remove some unused headers
  - Rephrase documentation to something platform independent
  - Revert some doc changes from v4 (chips -> chip's, must be -> should contain) 
  - Ensure utf8 encoding in ltc2952-poweroff.c

v3..v4:
  - Rename *kill to *poweroff
  - Use managed resources (devm_*) where possible
  - Handle irq failures on trigger gpio as if no trigger input was defined
  - Drop no-op suspend/resume functions
  - Check value before starting timer - it may be possible that the timer fails
    to start on first pass, but starts on second pass. While this is unlikely,
    it will throw off the entire system. Just check the actual gpio value to be
    sure. 
  - Reduce, almost eliminate, use of globals (I dislike them)
  - Fix some style issues
  - Now also tested on v3.17

v2..v3:
  - Allow absence of button input pin (and document that)
  - Fix some whitespace issues
  - Straighten out control flow here and there
  - Get rid of gpio array. This was only used in setup/cleanup cases. It never mattered elsewhere
  - Add some explanation to the commit message that introduces the driver
  - Add other contributors
  - Update René's e-mail; his Xsens e-mail is no longer valid
  - Now also tested on v3.17-rc7

René Moll (2):
  power: reset: add LTC2952 poweroff support
  power: reset: document LTC2952 poweroff support

 .../bindings/power/reset/ltc2952-poweroff.txt      |  30 ++
 drivers/power/reset/Kconfig                        |  10 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/ltc2952-poweroff.c             | 324 +++++++++++++++++++++
 4 files changed, 365 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
 create mode 100644 drivers/power/reset/ltc2952-poweroff.c

-- 
2.1.0

