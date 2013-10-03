Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3JCUNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:13:55 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3329 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab3JCUNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:13:51 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Subject: [PATCH 0/6] Update Kona drivers to use clocks
Date: Thu, 3 Oct 2013 13:13:08 -0700
Message-ID: <1380831194-27238-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E5310732L891340982-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series declares the clocks present on bcm11351 (aka bcm281xx) SoCs
to be fixed at the rates configured by development bootloaders and then
updates the Kona drivers to make use of clock calls where appropriate.

This patch series depends on the following three commits being present:

https://lkml.org/lkml/2013/9/18/409
https://lkml.org/lkml/2013/9/20/305
http://www.spinics.net/lists/arm-kernel/msg274973.html

Tim Kryger (6):
  ARM: dts: Declare clocks as fixed on bcm11351
  ARM: dts: Specify clocks for UARTs on bcm11351
  ARM: dts: Specify clocks for SDHCIs on bcm11351
  clocksource: kona: Add basic use of external clock
  ARM: dts: Specify clocks for timer on bcm11351
  mmc: sdhci-bcm-kona: Add basic use of clocks

 arch/arm/boot/dts/bcm11351.dtsi      | 111 +++++++++++++++++++++++++++++++++--
 drivers/clocksource/bcm_kona_timer.c |  14 ++++-
 drivers/mmc/host/sdhci-bcm-kona.c    |  30 +++++++++-
 3 files changed, 145 insertions(+), 10 deletions(-)

-- 
1.8.0.1


