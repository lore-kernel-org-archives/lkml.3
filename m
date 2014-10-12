Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaJLUEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:04:14 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37180 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaJLUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:04:12 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/3] media: rc: add support for Amlogic Meson IR receiver
Date: Sun, 12 Oct 2014 22:01:52 +0200
Message-Id: <1413144115-23188-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a driver for the IR receiver available in Amlogic Meson6 and
Meson8 SoCs. The device can operate in two modes: in "NEC" mode the
hardware can decode frames using the NEC IR protocol, while in
"general" mode the receiver simply reports the duration of pulses and
spaces for software decoding.

In order to have the maximum compatibility with different protocols
the driver implements software decoding.

The third patch (dts files) depends on some other patchsets [1][2]
that are still under review, so at the moment is not meant to be
merged.

[1] https://lkml.org/lkml/2014/10/5/162
[2] https://lkml.org/lkml/2014/10/7/712

Beniamino Galvani (3):
  media: rc: add driver for Amlogic Meson IR remote receiver
  media: rc: meson: document device tree bindings
  ARM: dts: meson: add dts nodes for IR receiver

 .../devicetree/bindings/media/meson-ir.txt         |  14 ++
 arch/arm/boot/dts/meson.dtsi                       |   7 +
 arch/arm/boot/dts/meson8-vega-s89e.dts             |   6 +
 arch/arm/boot/dts/meson8.dtsi                      |   7 +
 drivers/media/rc/Kconfig                           |  11 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/meson-ir.c                        | 214 +++++++++++++++++++++
 7 files changed, 260 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ir.txt
 create mode 100644 drivers/media/rc/meson-ir.c

-- 
1.9.1

