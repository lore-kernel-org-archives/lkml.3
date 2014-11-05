Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaKEDSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:18:46 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53099 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaKEDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:18:44 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 00/13] backports: add kernel integration support
Date: Tue,  4 Nov 2014 19:18:24 -0800
Message-Id: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Here's a v2 series on kernel integration support. This addresses
the expresed concerns over killing the versions file for packaging.
While at it it also addresses avoiding the double prefix issue
by prefixing the things we carry over with the copy trick with
BPAUTO, and removing the BACKPORT prefix all together from the
kernel versions we backport.

Luis R. Rodriguez (13):
  backports: move legacy and SmPL patch application into helper
  backports: ifdef around module_init() module_exit() for modules
  backports: allow for different backport prefix
  backports: replace BACKPORT_PWD with BACKPORT_DIR
  backports: use BACKPORT_DIR prefix on kconfig sources
  backports: update dependencies map file
  backports: split Kconfig into Kconfig.package and Kconfig.sources
  backports: move version file generation to run earlier
  backports: define C code backport version info using CPTCFG_
  backports: add backport version parsing for kernel integration
  backports: prefix c-file / h-file auto backport with BPAUTO
  backports: remove extra BACKPORT_ prefix from kernel versioning
  backports: add full kernel integration support

 backport/Kconfig                                   |  47 --
 backport/Kconfig.integrate                         |  36 ++
 backport/Kconfig.package                           |  32 ++
 backport/Kconfig.sources                           |  23 +
 backport/Makefile                                  |   8 +-
 backport/Makefile.build                            |   4 +-
 backport/Makefile.kernel                           |  19 +-
 backport/Makefile.real                             |   2 +-
 backport/backport-include/asm/dma-mapping.h        |   4 +-
 backport/backport-include/backport/backport.h      |   5 +
 backport/backport-include/backport/leds-disabled.h |   2 +-
 backport/backport-include/linux/module.h           |   8 +-
 backport/compat/Kconfig                            |  84 ++--
 backport/compat/Makefile                           |  42 +-
 backport/compat/backports.h                        |   4 +-
 backport/compat/main.c                             |  40 +-
 backport/scripts/uninstall.sh                      |   4 +-
 dependencies                                       |  31 +-
 devel/doc/kconfig-operation                        |  13 +-
 gentree.py                                         | 487 +++++++++++++--------
 .../0001-enable-backports-built-in.patch           |  40 ++
 lib/bpversion.py                                   |  48 ++
 lib/kconfig.py                                     | 164 ++++++-
 patches/backport-adjustments/devcoredump.patch     |   4 +-
 .../media/0002-no_dmabuf/v4l2.patch                |   6 +-
 25 files changed, 800 insertions(+), 357 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.integrate
 create mode 100644 backport/Kconfig.package
 create mode 100644 backport/Kconfig.sources
 create mode 100644 integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
 create mode 100644 lib/bpversion.py

-- 
2.1.1

