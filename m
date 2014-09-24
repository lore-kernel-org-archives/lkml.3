Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIXNLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:11:39 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:37299 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIXNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:11:37 -0400
X-ASG-Debug-ID: 1411564294-0759e70b7385810002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <linux-kernel@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [RFC PATCH 0/2] explicitly instantiate battery from device tree
Date: Wed, 24 Sep 2014 15:11:16 +0200
X-ASG-Orig-Subj: [RFC PATCH 0/2] explicitly instantiate battery from device tree
Message-ID: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411564295
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9824
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Here's some patches that make it possible to instantiate an sbs battery without
it being present yet.

i2c devices are more or less presumed to be persistent. This is a fair
assumption, except for the case of batteries. It is perfectly sensible for a
device to boot up using wall power, but no battery attached. While later
attaching a battery and dropping the wall power. Detecting the device from
userspace is tedious requires you to scan for device presence yourself, or you
can ask the kernel to probe again, cluttering your logs with failed probes.

I'd like to hear what you think about this.

Thanks,
Frans

Frans Klaver (2):
  sbs-battery: add forced instantiation from device tree
  sbs-battery: dts: document always-present property

 .../devicetree/bindings/power_supply/sbs_sbs-battery.txt      |  2 ++
 drivers/power/sbs-battery.c                                   | 11 +++++++++--
 include/linux/power/sbs-battery.h                             |  3 +++
 4 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.1.0

