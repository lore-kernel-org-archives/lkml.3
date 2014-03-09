Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaCIW0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:26:11 -0400
Received: from ring0.de ([5.45.105.125]:60050 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaCIW0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:26:09 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 0/6] OMAP SSI driver
Date: Sun,  9 Mar 2014 23:25:50 +0100
Message-Id: <1394403956-17297-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393199401-27197-1-git-send-email-sre@debian.org>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the sixth round of the OMAP SSI driver patches. I think the OMAP SSI
driver is ready for mainline and should be included in 3.15. This round updates
the patchset according to the comments from Mark Rutland and Rob Herring.

Changes since PATCHv1 [0]:
 * add a general description of what HSI is (Documentation/hsi.txt)
 * remove generic HSI client binding for now. I will send a separate
   patchset to discuss the HSI client binding.
 * Replace (*struct->func)(args) by struct->func(args)
 * Replace platform_get_resource_byname by platform_get_irq_byname
 * omap-ssi: only count childs compatible with "ti,omap3-ssi-port"
 * omap-ssi: only populate subdevices compatible with "ti,omap3-ssi-port"

TODO:
* Central Message Queue
  I did not yet implement a central message queue in the HSI framework.
  I will do this after Nokia N900 modem is working in the mainline kernel.
* Remove the hwmod DT hack
  This depends on some future work merging hwmod data into DT.
* Implement proper context loss detection

P.S.: It would be nice if I get some Reviewed-By/Acked-By.

[0] https://lkml.org/lkml/2014/2/23/173

-- Sebastian

Sebastian Reichel (6):
  Documentation: HSI: Add some general description for the HSI subsystem
  HSI: Add function to register HSI clients from DT
  HSI: method to unregister clients from an hsi port
  HSI: hsi-char: fix driver for multiport scenarios
  HSI: Introduce OMAP SSI driver
  Documentation: DT: omap-ssi binding documentation

 Documentation/devicetree/bindings/hsi/omap-ssi.txt |   82 ++
 Documentation/hsi.txt                              |   75 ++
 drivers/hsi/Kconfig                                |    1 +
 drivers/hsi/Makefile                               |    1 +
 drivers/hsi/clients/hsi_char.c                     |    2 +-
 drivers/hsi/controllers/Kconfig                    |   19 +
 drivers/hsi/controllers/Makefile                   |    6 +
 drivers/hsi/controllers/omap_ssi.c                 |  621 +++++++++
 drivers/hsi/controllers/omap_ssi.h                 |  166 +++
 drivers/hsi/controllers/omap_ssi_port.c            | 1401 ++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h            |  171 +++
 drivers/hsi/hsi.c                                  |   42 +-
 include/linux/hsi/hsi.h                            |    3 +
 13 files changed, 2588 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
 create mode 100644 Documentation/hsi.txt
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h

-- 
1.9.0

