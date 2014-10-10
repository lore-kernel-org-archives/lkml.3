Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaJJVZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:25:12 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:64038 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaJJVZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:25:10 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 10 Oct 2014 22:24:49 +0100
X-Google-Sender-Auth: DKa3bO36Uq7O-GR2H4_TODb3f0s
Message-ID: <CACxGe6sqRfWG4xAAxNuaONJrcy_VXYDxAqAdBa+oA4BVVkx32g@mail.gmail.com>
Subject: [GIT PULL] Devicetree changes for v3.18
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the device tree changes I have queued up for v3.18. Pretty
small set this time. Please pull.

g.

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux
tags/devicetree-for-linus

for you to fetch changes up to 2118f4b8dfc666c3e4a9e262beca79636a0852fe:

  of/selftest: Move hash table off stack to fix large frame size
(2014-10-07 11:30:31 +0100)

----------------------------------------------------------------
Devicetree changes for v3.18

This branch contains bug fixes and new features for the devicetree code.
Most of the changes are either new testcases for the selftest code or
documentation changes. The most notable change is the addition of a
phandle resolver for use when grafting in a second device tree blob into
the core tree. The resolver isn't currently used by anything other than
the selftest module, but it will be used to support device tree
overlays; probably in the v3.19 timeframe.

Also note that I've moved my normal tree from git.secretlab.ca to
git.kernel.org.

----------------------------------------------------------------
Gaurav Minocha (1):
      To remove non-ascii characters in of_selftest.txt

Geert Uytterhoeven (1):
      of: Add vendor prefix for Sitronix

Grant Likely (7):
      of: Fix NULL dereference in selftest removal code
      of/selftest: Test structure of device tree
      of: Don't try to search when phandle == 0
      of/selftest: Add a test for duplicate phandles
      of/selftest: Use the resolver to fixup phandles
      Merge branch 'for-next' of git://git.kernel.org/.../robh/linux
into devicetree/next
      of/selftest: Move hash table off stack to fix large frame size

Pantelis Antoniou (1):
      of: Introduce Device Tree resolve support.

Peter Chen (1):
      of: add vendor prefix for Chipidea

Santosh Shilimkar (1):
      dt/documentation: add specification of dma bus information

Thierry Reding (1):
      of: Add vendor prefix for Innolux Corporation

Tim Harvey (1):
      devicetree: bindings: Document Gateworks vendor prefix

Uwe Kleine-König (1):
      of: Add vendor prefix for Energy Micro

 .../devicetree/bindings/vendor-prefixes.txt        |   5 +
 Documentation/devicetree/booting-without-of.txt    |  53 ++++
 .../devicetree/dynamic-resolution-notes.txt        |  25 ++
 Documentation/devicetree/of_selftest.txt           |  30 +-
 drivers/of/Kconfig                                 |   4 +
 drivers/of/Makefile                                |   1 +
 drivers/of/base.c                                  |   3 +
 drivers/of/resolver.c                              | 336 +++++++++++++++++++++
 drivers/of/selftest.c                              | 120 +++++++-
 drivers/of/testcase-data/testcases.dts             |  35 +++
 include/linux/of.h                                 |   3 +
 11 files changed, 591 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
 create mode 100644 drivers/of/resolver.c
