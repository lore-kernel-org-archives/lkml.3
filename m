Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaBJPW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:22:57 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41991 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBJPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:22:56 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Cc: Mike Turquette <mturquette@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Michal Simek <monstr@monstr.eu>, Felipe Pena <felipensp@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, devicetree@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 0/3] Syscon early initialization
Date: Mon, 10 Feb 2014 16:22:32 +0100
Message-Id: <cover.1392045742.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-27070-1392045755-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-27070-1392045755-0001

Hi,

this series come from my discussion with Arnd at KS and then
on some other threads/IRCs(Arnd and Mark) that SoC vendors
are more and more try to add misc functionality to
one memory region. For this purpose syscon driver is in the kernel.
But regular syscon driver is initialized too late
and platforms are trying to create specific code to handle it.

For this purpose the series have been created to provide
early syscon initialization and regmap creation first
and then attaching device.

The last patch is zynq specific patch to clear slcr driver
and clock driver can profit from it too when clk regmap is ready.

Also moving syscon driver from mfs should be consider.

Thanks for your comments,
Michal


Michal Simek (3):
  regmap: Separate regmap dev initialization
  mfd: syscon: Support early initialization
  ARM: zynq: Use early syscon initialization

 arch/arm/boot/dts/zynq-7000.dtsi |   1 +
 arch/arm/mach-zynq/common.c      |   6 +-
 arch/arm/mach-zynq/slcr.c        |  42 +------------
 drivers/base/regmap/regmap.c     |  41 +++++++++----
 drivers/clk/zynq/clkc.c          |  57 ++++++------------
 drivers/mfd/syscon.c             | 126 +++++++++++++++++++++++++++++++++------
 include/linux/mfd/syscon.h       |  11 ++++
 include/linux/regmap.h           |   2 +
 8 files changed, 173 insertions(+), 113 deletions(-)

--
1.8.2.3


--=_mimegpg-monstr-desktop-27070-1392045755-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL47rsACgkQykllyylKDCHNlwCeJZDKdIvWVtpIym3PobzdOuut
X+gAn0QxMBEPBpjidSLTCINWWPWAmdka
=Vq2x
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-27070-1392045755-0001--
