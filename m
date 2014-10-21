Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaJUSPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:15:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:15:11 -0400
Date: Tue, 21 Oct 2014 20:15:04 +0200
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>,
        Andrew Bresticker <abrestic@google.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Subject: [GIT PULL] dts, kbuild: Implement support for dtb vendor subdirs
Message-ID: <20141021181504.GV20170@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409899692-1455-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 05.09.14 08:48:06, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> For arm64 we want to put dts files into vendor's subdirectories from
> the beginning. This patch set implements this. As this is a generic
> kbuild implementation, vendor subdirs will be also available for
> arch/arm and other architectures. The subdirectory tree is also
> reflected in the install path.
> 
> A new makefile variable dts-dirs is introduced to point to dts
> subdirs. This variable is used by kbuild for building and installation
> of dtb files.
> 
> A dts Makefile looks now as follows:
> 
> ----
> dtb-$(CONFIG_...) += some_file_1.dtb
> dtb-$(CONFIG_...) += some_file_2.dtb
> 
> dts-dirs          += dir_vendor_a
> dts-dirs          += dir_vendor_b
> 
> # come always afterwards:
> always         := $(dtb-y)
> subdir-y       := $(dts-dirs)
> clean-files    := *.dtb
> ----
> 
> This patches also introduces the dtbs_install make target for
> arm64. Install rules are moved to Makefile.dtbinst using the same
> style and calling convention like for modinst and fwinst.
> 
> Robert Richter (6):
>   dts, arm64: Add dtbs_install make target
>   dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
>   dts, arm/arm64: Remove dtbs build rules in sub-makes
>   dts, kbuild: Implement support for dtb vendor subdirs
>   dts, arm64: Move dts files to vendor subdirs
>   dts, arm: Remove $(MACHINE) variable from dtbs make recipes

please pull this series for inclusion into v3.19 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git dts-subdirs-for-arm-soc-v3.19

I have updated and rebased the patches to v3.18-rc1. No changes except
conflict resolution of patch 5/6.

Thanks,

-Robert



The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git dts-subdirs-for-arm-soc-v3.19

for you to fetch changes up to 6f889d8ba125693778e05f0166b963cf08fed930:

  dts, arm: Remove $(MACHINE) variable from dtbs make recipes (2014-10-21 18:07:00 +0200)

----------------------------------------------------------------
dts, kbuild: Implement support for dtb vendor subdirs

----------------------------------------------------------------
Robert Richter (6):
      dts, arm64: Add dtbs_install make target
      dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
      dts, arm/arm64: Remove dtbs build rules in sub-makes
      dts, kbuild: Implement support for dtb vendor subdirs
      dts, arm64: Move dts files to vendor subdirs
      dts, arm: Remove $(MACHINE) variable from dtbs make recipes

 arch/arm/Makefile                                  |  8 +++-
 arch/arm/boot/dts/Makefile                         | 12 +----
 arch/arm64/Makefile                                | 10 ++++-
 arch/arm64/boot/dts/Makefile                       | 15 +++----
 arch/arm64/boot/dts/apm/Makefile                   |  5 +++
 arch/arm64/boot/dts/{ => apm}/apm-mustang.dts      |  0
 arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi       |  0
 arch/arm64/boot/dts/arm/Makefile                   |  6 +++
 arch/arm64/boot/dts/{ => arm}/foundation-v8.dts    |  0
 arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts   |  0
 .../boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi    |  0
 arch/arm64/boot/dts/cavium/Makefile                |  5 +++
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dts  |  0
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dtsi |  0
 scripts/Kbuild.include                             |  6 +++
 scripts/Makefile.dtbinst                           | 51 ++++++++++++++++++++++
 scripts/Makefile.lib                               | 12 -----
 17 files changed, 95 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm64/boot/dts/apm/Makefile
 rename arch/arm64/boot/dts/{ => apm}/apm-mustang.dts (100%)
 rename arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi (100%)
 create mode 100644 arch/arm64/boot/dts/arm/Makefile
 rename arch/arm64/boot/dts/{ => arm}/foundation-v8.dts (100%)
 rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts (100%)
 rename arch/arm64/boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi (100%)
 create mode 100644 arch/arm64/boot/dts/cavium/Makefile
 rename arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dts (100%)
 rename arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dtsi (100%)
 create mode 100644 scripts/Makefile.dtbinst
