Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaBWXu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:50:26 -0500
Received: from ring0.de ([5.45.105.125]:59827 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaBWXuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:50:21 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 0/6] OMAP SSI driver
Date: Mon, 24 Feb 2014 00:49:55 +0100
Message-Id: <1393199401-27197-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fifth round of the OMAP SSI driver patches. I think the OMAP SSI
driver is ready for mainline and should be included in 3.15. I haven't heard
anything from DT binding maintainers since some months though and would like
to get some feedback about the binding from them.

Changes since RFCv4 [0]:
 * Removed patches for nokia-cmt and ssi-protocol, those are still WIP
 * tested with CONFIG_DEBUG_ATOMIC_SLEEP
 * tested with Russel's "OMAP dma engine rework" patchset
 * acquire clocks from DT
 * minor cleanups
  - removed unused include of omap specific dma header
 * updated patch subjects

TODO:
* Central Message Queue
  I did not yet implement a central message queue in the HSI framework.
  I will do this after Nokia N900 modem is working in the mainline kernel.
* Remove the hwmod DT hack
  This depends on some future work merging hwmod data into DT.

P.S.: It would be nice if I get some Reviewed-By/Acked-By.

[0] http://marc.info/?l=linux-kernel&m=138715030530931&w=2

-- Sebastian

Sebastian Reichel (6):
  HSI: add Device Tree support for HSI clients
  HSI: method to unregister clients from an hsi port
  HSI: hsi-char: add Device Tree support
  HSI: hsi-char: fix driver for multiport scenarios
  HSI: Introduce OMAP SSI driver
  Documentation: DT: omap-ssi binding documentation

 Documentation/devicetree/bindings/hsi/omap_ssi.txt |   82 ++
 .../devicetree/bindings/hsi/trivial-devices.txt    |   36 +
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/hsi_char.c                     |   13 +-
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  618 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1401 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |   80 +-
 include/dt-bindings/hsi/hsi.h                      |   17 +
 include/linux/hsi/hsi.h                            |    3 +
 14 files changed, 2612 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap_ssi.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/trivial-devices.txt
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h
 create mode 100644 include/dt-bindings/hsi/hsi.h

-- 
1.8.5.3

