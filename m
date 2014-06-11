Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaFKGVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:21:31 -0400
Received: from ozlabs.org ([103.22.144.67]:59211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaFKGVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:21:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Brian W Hart <hartb@linux.vnet.ibm.com>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Christian Engelmayer <cengelma@gmx.at>
Cc: Christopher Brannon <chris@the-brannons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Lindar Liu <lindar_liu@usish.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Simon Wood <simon@mungewell.org>
Cc: Vincent Sanders <vince@simtec.co.uk>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Jun 2014 15:03:47 +0930
Message-ID: <877g4oau2s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ec6931b281797b69e6cf109f9cc94d5a2bf994e0:

  word-at-a-time: avoid undefined behaviour in zero_bytemask macro (2014-04-27 15:20:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to 4982223e51e8ea9d09bb33c8323b5ec1877b2b51:

  module: set nx before marking module MODULE_STATE_COMING. (2014-05-14 10:55:47 +0930)

----------------------------------------------------------------
Most of this is cleaning up various driver sysfs permissions so we can
re-add the perm check (we unified the module param and sysfs checks, but
the module ones were stronger so we weakened them temporarily).

Param parsing gets documented, and also "--" now forces args to be
handed to init (and ignored by the kernel).

Module NX/RO protections get tightened: we now set them before calling
parse_args().

Cheers,
Rusty.

----------------------------------------------------------------
Brian W Hart (1):
      cpumask.h: silence warning with -Wsign-compare

Christian Engelmayer (1):
      modpost: Fix resource leak in read_dump()

Rusty Russell (12):
      param: hand arguments after -- straight to init
      Documentation: Update kernel-parameters.tx
      speakup: fix incorrect perms on speakup_acntsa.c
      drivers/mtd/devices/docg3.c: avoid world-writable sysfs files.
      drivers/video/fbdev/sm501fb.c: avoid world-writable sysfs files.
      drivers/hid/hid-lg4ff.c: avoid world-writable sysfs files.
      drivers/scsi/pm8001/pm8001_ctl.c: avoid world-writable sysfs files.
      drivers/regulator/virtual: avoid world-writable sysfs files.
      drivers/staging/speakup/: avoid world-writable sysfs files.
      drivers/hid/hid-picolcd_fb: avoid world-writable sysfs files.
      samples/kobject/: avoid world-writable sysfs files.
      module: set nx before marking module MODULE_STATE_COMING.

 Documentation/kernel-parameters.txt      | 40 +++++++++++++--------
 drivers/hid/hid-lg4ff.c                  |  2 +-
 drivers/hid/hid-picolcd_fb.c             |  2 +-
 drivers/mtd/devices/docg3.c              |  4 +--
 drivers/regulator/virtual.c              | 10 +++---
 drivers/scsi/pm8001/pm8001_ctl.c         |  2 +-
 drivers/staging/speakup/kobjects.c       | 62 ++++++++++++++++----------------
 drivers/staging/speakup/speakup_acntpc.c | 14 ++++----
 drivers/staging/speakup/speakup_acntsa.c | 22 ++++++------
 drivers/staging/speakup/speakup_apollo.c | 16 ++++-----
 drivers/staging/speakup/speakup_audptr.c | 16 ++++-----
 drivers/staging/speakup/speakup_bns.c    | 14 ++++----
 drivers/staging/speakup/speakup_decext.c | 16 ++++-----
 drivers/staging/speakup/speakup_decpc.c  | 16 ++++-----
 drivers/staging/speakup/speakup_dectlk.c | 16 ++++-----
 drivers/staging/speakup/speakup_dtlk.c   | 20 +++++------
 drivers/staging/speakup/speakup_dummy.c  | 14 ++++----
 drivers/staging/speakup/speakup_keypc.c  | 10 +++---
 drivers/staging/speakup/speakup_ltlk.c   | 20 +++++------
 drivers/staging/speakup/speakup_soft.c   | 22 ++++++------
 drivers/staging/speakup/speakup_spkout.c | 16 ++++-----
 drivers/staging/speakup/speakup_txprt.c  | 14 ++++----
 drivers/video/fbdev/sm501fb.c            |  2 +-
 include/linux/cpumask.h                  |  2 +-
 include/linux/moduleparam.h              |  2 +-
 init/main.c                              | 33 ++++++++++++++---
 kernel/module.c                          | 44 +++++++++++++----------
 kernel/params.c                          | 25 +++++++------
 samples/kobject/kobject-example.c        |  7 ++--
 samples/kobject/kset-example.c           |  7 ++--
 scripts/mod/modpost.c                    |  2 ++
