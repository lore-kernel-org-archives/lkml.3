Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaKKIPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:21 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50642 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKKIPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:19 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 00/21] backports: add kernel integration support
Date: Tue, 11 Nov 2014 00:14:51 -0800
Message-Id: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This third series should hopefully address all pending feedback.
I've split out patches even more, but more importantly have
made the parser simpler by both integrating the logic required
to understand a backport by identifying the backport by type
and strategy, sharing that, and then providing ignore lists on
the parsers.

The more complex change was dealing with the recursive _walk() in such
a way that we can have a modified src_line regexp depending on the type
of backport we are using. The parser will use a regexp that requires a
full path for the sources, it will also allow for using a variable for
the backport project directory if such is defined, and also provide a
verification helper which ensures backported will be used rather than
the older kernel code.

Luis R. Rodriguez (21):
  backports: move legacy and SmPL patch application into helper
  backports: ifdef around module_init() module_exit() for modules
  backports: move packaging kconfig hacks to its own file
  backports: grant parsers access to kconfig config and menuconfig
  backports: keep track of original backported source symbols early on
  backports: allow for different backport prefix and simple integration
    support
  backports: add prefix for integration on dependencies
  backports: replace BACKPORT_PWD with BACKPORT_DIR
  backports: fold outdir as a backport identity target
  backports: avoid git tree reinitialization
  backports: modify kconfig parser to use bpid and target_dir
  backports: make kconfig src_line backport / ConfigTree specific
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
 backport/Kconfig.package                           |  24 +
 backport/Kconfig.package.hacks                     |   8 +
 backport/Kconfig.sources                           |  23 +
 backport/Makefile                                  |   8 +-
 backport/Makefile.build                            |   4 +-
 backport/Makefile.kernel                           |  19 +-
 backport/Makefile.real                             |   2 +-
 backport/backport-include/asm/dma-mapping.h        |   4 +-
 backport/backport-include/backport/backport.h      |   5 +
 backport/backport-include/backport/leds-disabled.h |   2 +-
 backport/backport-include/linux/module.h           |   8 +-
 backport/compat/Kconfig                            |  84 +--
 backport/compat/Makefile                           |  42 +-
 backport/compat/backports.h                        |   4 +-
 backport/compat/main.c                             |  40 +-
 backport/scripts/uninstall.sh                      |   4 +-
 dependencies                                       |  31 +-
 devel/doc/kconfig-operation                        |  13 +-
 gentree.py                                         | 599 ++++++++++++++-------
 .../0001-enable-backports-built-in.patch           |  40 ++
 lib/bpversion.py                                   |  48 ++
 lib/kconfig.py                                     | 196 ++++++-
 patches/backport-adjustments/devcoredump.patch     |   4 +-
 .../media/0002-no_dmabuf/v4l2.patch                |   6 +-
 26 files changed, 910 insertions(+), 391 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.integrate
 create mode 100644 backport/Kconfig.package
 create mode 100644 backport/Kconfig.package.hacks
 create mode 100644 backport/Kconfig.sources
 create mode 100644 integration-patches/0001-enable-backports/0001-enable-backports-built-in.patch
 create mode 100644 lib/bpversion.py

-- 
2.1.1

