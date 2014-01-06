Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaAFOhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:37:06 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49447 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAFOhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:03 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, monstr@monstr.eu,
        devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>
Subject: [PATCH 0/7] Xilinx Zynq SLCR changes
Date: Mon,  6 Jan 2014 15:36:36 +0100
Message-Id: <cover.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32302-1389019004-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32302-1389019004-0001

Hi,

I have rebased and added together patches I have got from Steffen some time ago.
Steffen: I kept there your SoB. Please let me know if there is any problem
with it.

The point of this series is to use slcr as system controller
to be able to create other drivers like pinmux, etc.

These patches are based on zynq/cleanup and zynq/dt branches merged
together. (They are available in arm-soc git tree).
Let me know if you want to add the branch somewhere.

Arnd: We talked at KS about syscon early initialization which
will be really helpful for this case. Has someone done any work
around it?

Thanks,
Michal


Michal Simek (4):
  ARM: zynq: Split slcr in two parts
  ARM: zynq: Map I/O memory on clkc init
  ARM: zynq: Add and use zynq_slcr_read/write() helper functions
  ARM: zynq: Introduce zynq_slcr_unlock()

Steffen Trumtrar (3):
  ARM: zynq: Move clock_init from slcr to common
  ARM: zynq: Hang iomapped slcr address on device_node
  ARM: zynq: Make zynq_slcr_base static

 .../devicetree/bindings/clock/zynq-7000.txt        |  4 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   | 42 +++++-----
 arch/arm/mach-zynq/Kconfig                         |  1 +
 arch/arm/mach-zynq/common.c                        |  6 +-
 arch/arm/mach-zynq/common.h                        |  2 +-
 arch/arm/mach-zynq/slcr.c                          | 98 +++++++++++++++++++---
 drivers/clk/zynq/clkc.c                            | 89 ++++++++++++++------
 include/linux/clk/zynq.h                           |  2 +-
 8 files changed, 179 insertions(+), 65 deletions(-)

--
1.8.2.3


--=_mimegpg-monstr-desktop-32302-1389019004-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv3wACgkQykllyylKDCF1pwCeNySfIo9zcwe7IhHgi/cAf1IV
ArsAniuWV3paqeg5k7jHrhSHmLocv5IU
=ZFvb
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32302-1389019004-0001--
