Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3EaGc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:32:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45776 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3EaGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:32:38 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux@arm.linux.org.uk>, <zonque@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <davinci-linux-open-source@linux.davincidsp.com>, <khilman@linaro.org>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>
Subject: [PATCH 0/2] rtc: rtc-omap: add support for DT wakeup & alarm events
Date: Fri, 31 May 2013 12:03:23 +0530
Message-ID: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current rtc-omap driver expects the rtc module wake-up capabilities to
be set up by board specific code. However, in case of DT, this is not
possible.

So, add a DT property "ti,wakeup_capable" to indicate that the module
is wake-up capable.

Also, on some platforms (like AM33xx), a special register
(RTC_IRQWAKEEN) is available to enable Wakeup feature for Alarm Events.

Since new platforms/Boards are now added through DT only, this feature
is supported via DT property only. Platforms using such IP should add
the property "ti,has_irq_wake_enb" in rtc DT node.

Kernel Base for the series is
	> git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/
linux-omap-dt.git
	> linux-omap-git/for_3.11/dts

Hebbar Gururaja (2):
  rtc: omap: add option to indicate wakeup support through DT
  rtc: omap: add rtc wakeup support to alarm events

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    6 +++
 drivers/rtc/rtc-omap.c                             |   50 +++++++++++++++++---
 2 files changed, 49 insertions(+), 7 deletions(-)

-- 
1.7.9.5

