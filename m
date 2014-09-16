Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaIPPtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:49:47 -0400
Received: from ozlabs.org ([103.22.144.67]:38111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaIPPtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:49:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bertrand Jacquin <beber@meleeweb.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Willy Tarreau <w@1wt.eu>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 17 Sep 2014 01:18:39 +0930
Message-ID: <87d2avftwo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 68e370289c29e3beac99d59c6d840d470af9dfcf:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2014-08-26 13:50:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to 184c3fc3f52fb75800deb76deffb70907d1f76ea:

  moduleparam: Resolve missing-field-initializer warning (2014-09-11 09:59:25 +0930)

----------------------------------------------------------------
Nothing major: support for compressing modules, and auto-tainting params.

Cheers,
Rusty.
PS.  My virtio-next tree is empty: DaveM took the patches I had.  There might
     be a virtio-rng starvation fix, but so far it's a bit voodoo so I will
     get to that in the next two days or it will wait.

----------------------------------------------------------------
Bertrand Jacquin (3):
      modsign: lookup lines ending in .ko in .mod files
      modinst: wrap long lines in order to enhance cmd_modules_install
      kbuild: handle module compression while running 'make modules_install'.

Jani Nikula (4):
      module: rename KERNEL_PARAM_FL_NOARG to avoid confusion
      module: make it possible to have unsafe, tainting module params
      module: add module_param_unsafe and module_param_named_unsafe
      drm/i915: taint the kernel if unsafe module parameters are set

Mark Rustad (1):
      moduleparam: Resolve missing-field-initializer warning

Mathias Krause (2):
      modpost: reduce visibility of symbols and constify r/o arrays
      modpost: simplify file name generation of *.mod.c files

Rusty Russell (1):
      param: check for tainting before calling set op.

 Makefile                            | 15 +++++++++++
 drivers/gpu/drm/i915/i915_params.c  |  8 +++---
 drivers/tty/serial/8250/8250_core.c |  2 +-
 include/linux/moduleparam.h         | 50 +++++++++++++++++++++++++++++--------
 init/Kconfig                        | 43 +++++++++++++++++++++++++++++++
 kernel/module.c                     |  2 +-
 kernel/params.c                     | 17 ++++++++++---
 scripts/Makefile.modinst            |  7 +++++-
 scripts/Makefile.modsign            |  2 +-
 scripts/mod/modpost.c               | 25 ++++++++++---------
 security/apparmor/lsm.c             |  4 +--
 11 files changed, 139 insertions(+), 36 deletions(-)
