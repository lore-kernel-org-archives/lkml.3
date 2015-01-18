Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbbARMUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:20:30 -0500
Received: from smtp-4.sys.kth.se ([130.237.48.193]:36501 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbARMU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:20:26 -0500
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linus.walleij@linaro.org
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCH v2 0/4] Add emev2 pinmux support
Date: Sun, 18 Jan 2015 13:20:00 +0100
Message-Id: <1421583604-27256-1-git-send-email-niso@kth.se>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is v2 of a patchset that introduces pinmux support for the EMMA
Mobile EV2 board to the sh-pfc pin-controller driver. Devicetree
bindings for gpio and the populated serial connector are also defined in
3/4 and 4/4.

Changes since v1:

* GPIOs numbered linearly instead of using a bank_number schema
* Group pins in larger groups instead of one group per pin
* Only define the actual 159 GPIOs instead of 160
* There are 23 pins per row not 25, correct PIN_NUMBER macro
* Define one larger reg entry in dts for pfc instead of four small

Niklas Söderlund (4):
  sh-pfc: add macro to define pinmux without function
  sh-pfc: Add emev2 pinmux support
  ARM: shmobile: emev2: Add PFC information to emev2.dtsi
  ARM: shmobile: emev2-kzm9d: Add PFC information for uart1

 .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |    1 +
 arch/arm/boot/dts/emev2-kzm9d.dts                  |   13 +
 arch/arm/boot/dts/emev2.dtsi                       |   10 +
 drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
 drivers/pinctrl/sh-pfc/Makefile                    |    1 +
 drivers/pinctrl/sh-pfc/core.c                      |    9 +
 drivers/pinctrl/sh-pfc/core.h                      |    1 +
 drivers/pinctrl/sh-pfc/pfc-emev2.c                 | 1774 ++++++++++++++++++++
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |    2 +
 9 files changed, 1816 insertions(+)
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-emev2.c

--
2.2.1

