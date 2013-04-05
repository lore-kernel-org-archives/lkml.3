Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162488Ab3DESq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:46:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60767 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162471Ab3DESq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:46:58 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <glikely@secretlab.ca>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [GIT PULL] dt: run C pre-processor on *.dts, create some standard headers
Date: Fri,  5 Apr 2013 12:46:50 -0600
Message-Id: <1365187610-29422-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob, it might be worth keeping this in a separate branch in linux-next
so you can pull it out if it causes any issues. I've been using these
patches for quite a while now, but there's always opportunity for
surprises on architectures I don't use. I did just fix a bug when
building with O= a few days back, hence the V2 that I posted as patches.

----------------------------------------------------------------

This branch enhances the support for running dtc on device tree files.

A dedicated directory is created for header files that provide constants
for device-tree bindings.

The kbuild dependency script processor is enhanced to support processing
the dependency outputs from multiple separate commands at once.

The kbuild dtc rule is modified so that the C pre-processor is always
applied when compiling any device tree.

Some standard headers are created which define common constants for GPIO,
IRQ, and ARM GIC device tree bindings.

----------------------------------------------------------------

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git tegra-for-3.10-dtc-cpp-chroot-std-headers

for you to fetch changes up to 4be505d4fc7a07371a2b658469ca1dda99993ca3:

  ARM: dt: create a DT header for the GIC

----------------------------------------------------------------

Stephen Warren (7):
      kbuild: create an "include chroot" for DT bindings
      kbuild: fixdep: support concatenated dep files
      kbuild: cmd_dtc_cpp: extract deps from both gcc -E and dtc
      kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp
      ARM: dt: add header to define GPIO flags
      ARM: dt: add header to define IRQ flags
      ARM: dt: create a DT header for the GIC

 arch/arm/boot/dts/include/dt-bindings           |    1 +
 include/dt-bindings/gpio/gpio.h                 |   15 +++
 .../dt-bindings/interrupt-controller/arm-gic.h  |   22 +++++
 include/dt-bindings/interrupt-controller/irq.h  |   19 ++++
 scripts/Makefile.lib                            |   17 ++--
 scripts/basic/fixdep.c                          |   93 ++++++++++++------
 6 files changed, 125 insertions(+), 42 deletions(-)
 create mode 120000 arch/arm/boot/dts/include/dt-bindings
 create mode 100644 include/dt-bindings/gpio/gpio.h
 create mode 100644 include/dt-bindings/interrupt-controller/arm-gic.h
 create mode 100644 include/dt-bindings/interrupt-controller/irq.h
