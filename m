Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaBSLES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:04:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43773 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaBSLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:04:16 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Cc: Mike Turquette <mturquette@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Michal Simek <monstr@monstr.eu>, Felipe Pena <felipensp@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Warren <swarren@nvidia.com>, devicetree@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH v2 0/2] Syscon early initialization
Date: Wed, 19 Feb 2014 12:04:03 +0100
Message-Id: <cover.1392807832.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32437-1392807845-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32437-1392807845-0001

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

Mark already applied the first part to his regmap repo
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev

Thanks for your comments,
Michal

Changes in v2:
- Fix bad logic in early_syscon_probe
- Fix compilation failure for x86_64 reported by zero day testing system
- Regmap change available here
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev

Michal Simek (2):
  mfd: syscon: Support early initialization
  ARM: zynq: Use early syscon initialization

 arch/arm/boot/dts/zynq-7000.dtsi |   1 +
 arch/arm/mach-zynq/common.c      |   6 +-
 arch/arm/mach-zynq/slcr.c        |  42 +------------
 drivers/clk/zynq/clkc.c          |  57 ++++++-----------
 drivers/mfd/syscon.c             | 128 +++++++++++++++++++++++++++++++++------
 include/linux/mfd/syscon.h       |  11 ++++
 6 files changed, 145 insertions(+), 100 deletions(-)

--
1.8.2.3


--=_mimegpg-monstr-desktop-32437-1392807845-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMEj6UACgkQykllyylKDCGb6wCfdne+g60RLdXb6xSWPWFQL/zt
wMsAni+3jNNwl+yzcHbjcwOl7W5Im97x
=4NI8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32437-1392807845-0001--
