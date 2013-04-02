Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3DBQXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:23:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab3DBQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:23:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH V5 0/6] USB: EHCI multiplatform for 3.10
Date: Tue,  2 Apr 2013 18:23:58 +0200
Message-Id: <1364919844-1726-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:exdrIqrxEVJWeo4rw/MQbia1WtGISvLXTWbbrcJeBUI
 buLqQbew1FCjBgnF2ThXriXHUBaGNS1kW99IwJ2+uVkroPwNaA
 xyRCgOk6om58piT4Fyzj1E3W9vfMCq6gd/9e3X2RFgKpa/2x5L
 a3Mm430ZvORaOgIHVIzBoqj4BFkPTad6llOnlV6AJFhrapKGw2
 reT/U4UCEMCrz1y55Jo24Hf55suGymMcOAbklyFijz1R1zjOX7
 GrFHzt5Gwd6d+8+zyr8PcT0pfoQCvQreB0HVdAYLbhX8jmw6om
 rnUkoxQ9YZCLSEdLE08uLyS3JHFuKS8pkiszKid35ugNbTPec2
 E3A86gzI3PkxyXytMpFseP5+GSyxemzwJj5EWLn7Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are the EHCI patches that I think are good for inclusion in 3.10,
I hope you are willing to include them after the debacle over these
patches in 3.9.

The patches are all logically independent but sorted by priority,
so decide for yourself how many you want to take, starting at the
first one. The first six patches all have an Ack from Alan Stern
and from the respective ARM platform maintainers.

* The first patch (Orion) fixes a preexisting bug because the driver
  conflicts with the OMAP and vt8500 back-ends in 3.9. Both of those
  are fixed in usb-next now, but the same problem comes back with
  any other platform we enable for ARM multiplatform support.
* The second patch fixes a problem that will happen in 3.10 as we
  enable SPEAr multiplatform support.
* S5P/Exynos multiplatform support is not yet part of linux-next, but
  I still have hope for 3.10, so the third patch will be needed as well
  then.
* The ehci-atmel patch will not be needed in 3.10 but quite likely
  in 3.11.
* I have no time line for MSM multiplatform support, but we will
  get there eventually and the driver is broken already so there
  is no risk of regressions.
* The final patch is from me and still waiting for an Ack from Alan
  Stern, so please wait for his feedback before applying that one.

There is one more patch coming for ehci-tegra. I've forwarded
Manjunath's work on that driver to the Tegra developers, who
will test it and send it directly to you. The version I had was
incomplete.

	Arnd

Arnd Bergmann (1):
  USB: OHCI: avoid conflicting platform drivers

Manjunath Goudar (5):
  USB: EHCI: make ehci-orion a separate driver
  USB: EHCI: make ehci-spear a separate driver
  USB: EHCI: make ehci-s5p a separate driver
  USB: EHCI: make ehci-atmel a separate driver
  USB: EHCI: make ehci-msm a separate driver

 drivers/usb/host/Kconfig      |  40 +++++++++--
 drivers/usb/host/Makefile     |   5 ++
 drivers/usb/host/ehci-atmel.c |  88 +++++++++++------------
 drivers/usb/host/ehci-hcd.c   |  30 ++------
 drivers/usb/host/ehci-msm.c   |  89 +++++++++++------------
 drivers/usb/host/ehci-orion.c |  82 +++++++++------------
 drivers/usb/host/ehci-s5p.c   | 164 +++++++++++++++++++++---------------------
 drivers/usb/host/ehci-spear.c | 115 +++++++++++++----------------
 drivers/usb/host/ohci-hcd.c   | 136 ++++++++++++++++++++++++++++++-----
 9 files changed, 412 insertions(+), 337 deletions(-)

-- 
1.8.1.2

