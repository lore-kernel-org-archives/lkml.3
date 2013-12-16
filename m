Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3LPE33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:29:29 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54966 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3LPE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:29:27 -0500
Message-ID: <52AE81B3.4010203@linaro.org>
Date: Sun, 15 Dec 2013 22:29:39 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tim Kryger <tim.kryger@linaro.org>
CC: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] clk: bcm281xx: add initial clock framework support
References: <529F4B0F.2020801@linaro.org> <529F4B4F.4020405@linaro.org> <20131214235731.26321.53050@quantum> <52ADE93B.3070907@linaro.org> <E566434B-F630-4AD3-91EC-BD5599767F2E@linaro.org>
In-Reply-To: <E566434B-F630-4AD3-91EC-BD5599767F2E@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 06:22 PM, Alex Elder wrote:
> I think I can prepare a series that puts my changes
> before Tim's. Unless I have trouble doing that
> I will send that out in a few hours.
. . .


I got started on doing this but then I decided to go
check on the status of Tim's series.  It looks like
Christian is on the verge of taking his series in,
and is planning to coordinate with the affected
maintainers to do so.

I'm going to assume that is going to happen quite
soon--I hope in the next day or two.  So rather than
muddy the waters even further, it might be best to
just wait for Tim's series to be accepted and then
you take mine in on top of that.

In any case this is a small mess that's going to
require some coordination to get resolved.  Let
me know if there's something else specific you
would recommend.

In the mean time, I have created a new branch that
is based on v3.13-rc4 (and includes Tim's prerequisite
patches).  Pull request (still wrapped my my mailer)
is below.

Thanks.

					-Alex

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  ssh://git@git.linaro.org/people/alex.elder/linux.git
review/bcm-kona-clocks-v4

for you to fetch changes up to deebd4ea75c159697d1e43416683d6068821b431:

  ARM: dts: bcm281xx: define real clocks (2013-12-15 22:23:13 -0600)

----------------------------------------------------------------
Alex Elder (3):
      clk: bcm281xx: define kona clock binding
      clk: bcm281xx: add initial clock framework support
      ARM: dts: bcm281xx: define real clocks

Tim Kryger (8):
      ARM: dts: Declare clocks as fixed on bcm11351
      ARM: dts: Specify clocks for UARTs on bcm11351
      Documentation: dt: kona-sdhci: Add clocks property
      ARM: dts: Specify clocks for SDHCIs on bcm11351
      mmc: sdhci-bcm-kona: Add basic use of clocks
      Documentation: dt: kona-timer: Add clocks property
      clocksource: kona: Add basic use of external clock
      ARM: dts: Specify clocks for timer on bcm11351

 .../devicetree/bindings/arm/bcm/kona-timer.txt     |    7 +-
 .../devicetree/bindings/clock/bcm-kona-clock.txt   |   93 ++
 .../devicetree/bindings/mmc/kona-sdhci.txt         |    4 +
 arch/arm/boot/dts/bcm11351.dtsi                    |  199 +++-
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Kconfig                            |    8 +
 drivers/clk/bcm/Makefile                           |    3 +
 drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
 drivers/clk/bcm/clk-kona-setup.c                   |  769 +++++++++++++++
 drivers/clk/bcm/clk-kona.c                         | 1033
++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h                         |  414 ++++++++
 drivers/clocksource/bcm_kona_timer.c               |   14 +-
 drivers/mmc/host/sdhci-bcm-kona.c                  |   37 +-
 include/dt-bindings/clock/bcm281xx.h               |   65 ++
 15 files changed, 3053 insertions(+), 11 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
 create mode 100644 drivers/clk/bcm/Kconfig
 create mode 100644 drivers/clk/bcm/Makefile
 create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
 create mode 100644 drivers/clk/bcm/clk-kona-setup.c
 create mode 100644 drivers/clk/bcm/clk-kona.c
 create mode 100644 drivers/clk/bcm/clk-kona.h
 create mode 100644 include/dt-bindings/clock/bcm281xx.h

