Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaLIVqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:46:35 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64577 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaLIVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:46:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 9/9] ARM64: SoC changes for 3.19
Date: Tue, 09 Dec 2014 22:46:21 +0100
Message-ID: <2482441.CQUhI8rqR1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:41hJgnFgp1FlCHITYIILC3nC4hrRIX+1PCwzlw3dvb8SQKdt1yj
 y5qqgEGgk2pUe7Hojkd1z9aU4UU+c6knnoJI+uC4Xx1pOGiV0zScNV6jOqk9ML6tmAveFKQ
 OSDvNCBjWlQ0uVbkjd7G05HI9vtW5glTqMRXzv8j4X7j7tQuZmT5P0QsK4RpKkPM9MhBtnq
 HJ+Sf9m47pkL9tl033D7g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/arm64-for-linus

for you to fetch changes up to 70bcc9ba15690f1e616fd5f60831f4602dd39670:

  arm64: amd-seattle: Fix PCI bus range due to SMMU limitation (2014-12-04 17:10:34 +0100)

----------------------------------------------------------------
ARM64: SoC changes for 3.19

This adds support for two new ARM64 platforms:

* ARM Juno
* AMD Seattle

We had submissions for a number of additional platforms
from Samsung, Freescale and Spreadtrum but are still working
out the best process for getting these merged.

----------------------------------------------------------------

I forgot to mention in my introductory mail that there are a couple more pull
requests queued up in the arm-soc tree that are waiting for dependencies or
were added very late before the merge window and are given more time for
things to settle down. I plan to submit them in a few days, but there is not
much missing at this point.

Arnd Bergmann (1):
      Merge branch 'cleanup/dts-subdirs' into next/arm64

Liviu Dudau (3):
      arm64: Create link to include/dt-bindings to enable C preprocessor use.
      arm64: Add Juno board device tree.
      arm64: ARM: Fix the Generic Timers interrupt active level description

Suravee Suthikulpanit (2):
      arm64: amd-seattle: Adding device tree for AMD Seattle platform
      arm64: amd-seattle: Fix PCI bus range due to SMMU limitation

 arch/arm/Makefile                                  |   8 +-
 arch/arm/boot/dts/Makefile                         |  12 +-
 arch/arm64/Kconfig                                 |   5 +
 arch/arm64/Makefile                                |  10 +-
 arch/arm64/boot/dts/Makefile                       |  16 +-
 arch/arm64/boot/dts/amd/Makefile                   |   5 +
 arch/arm64/boot/dts/amd/amd-overdrive.dts          |  66 +++++++
 arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi      |  54 +++++
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi       | 172 ++++++++++++++++
 arch/arm64/boot/dts/apm/Makefile                   |   5 +
 arch/arm64/boot/dts/{ => apm}/apm-mustang.dts      |   0
 arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi       |   0
 arch/arm64/boot/dts/arm/Makefile                   |   7 +
 arch/arm64/boot/dts/{ => arm}/foundation-v8.dts    |   8 +-
 arch/arm64/boot/dts/arm/juno-clocks.dtsi           |  44 +++++
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi      | 129 ++++++++++++
 arch/arm64/boot/dts/arm/juno.dts                   | 218 +++++++++++++++++++++
 arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts   |   8 +-
 .../boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi    |   0
 arch/arm64/boot/dts/cavium/Makefile                |   5 +
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dts  |   0
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dtsi |   0
 arch/arm64/boot/dts/include/dt-bindings            |   1 +
 scripts/Kbuild.include                             |   6 +
 scripts/Makefile.dtbinst                           |  51 +++++
 scripts/Makefile.lib                               |  12 --
 26 files changed, 799 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm64/boot/dts/amd/Makefile
 create mode 100644 arch/arm64/boot/dts/amd/amd-overdrive.dts
 create mode 100644 arch/arm64/boot/dts/amd/amd-seattle-clks.dtsi
 create mode 100644 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
 create mode 100644 arch/arm64/boot/dts/apm/Makefile
 rename arch/arm64/boot/dts/{ => apm}/apm-mustang.dts (100%)
 rename arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi (100%)
 create mode 100644 arch/arm64/boot/dts/arm/Makefile
 rename arch/arm64/boot/dts/{ => arm}/foundation-v8.dts (98%)
 create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno.dts
 rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts (97%)
 rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi (100%)
 create mode 100644 arch/arm64/boot/dts/cavium/Makefile
 rename arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dts (100%)
 rename arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dtsi (100%)
 create mode 120000 arch/arm64/boot/dts/include/dt-bindings
 create mode 100644 scripts/Makefile.dtbinst

