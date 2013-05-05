Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3EEFyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 01:54:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48336 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3EEFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 01:54:16 -0400
Date: Sun, 5 May 2013 06:54:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] single_open() leak fixes
Message-ID: <20130505055414.GJ25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A bunch of fixes for a moderately common class of bugs: file with
single_open() done by its ->open() and seq_release as its ->release().
That leaks; fortunately, it's not _too_ common (either people manage to
RTFM that says "When using single_open(), the programmer should use
single_release() instead of seq_release() in the file_operations structure
to avoid a memory leak", or they just copy a correct instance), but grepping
through the tree has caught quite a pile.  All of that is, AFAICS, -stable
fodder, for as far as the patches apply.  I tried to carve it up into
reasonably-sized pieces (more or less "comes from the same tree").  Please,
pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Al Viro (15):
      arm: single_open() leaks
      cris: single_open() leaks
      h8300: single_open() leaks
      ia64: single_open() leaks
      mips: single_open() leaks
      parisc: single_open() leaks
      sh: single_open() leaks
      ds1620: single_open() leak
      rtc: single_open() leaks
      input: single_open() leak
      wireless: single_open() leaks
      megaraid: single_open() leak
      staging: single_open() leaks
      gadget: single_open() leaks
      rcutrace: single_open() leaks

Diffstat:
 arch/arm/kernel/swp_emulate.c                      |    2 +-
 arch/arm/mach-omap1/pm.c                           |    2 +-
 arch/cris/arch-v10/kernel/fasttimer.c              |    2 +-
 arch/cris/arch-v32/kernel/fasttimer.c              |    2 +-
 arch/h8300/kernel/gpio.c                           |    2 +-
 arch/ia64/kernel/palinfo.c                         |    2 +-
 arch/ia64/kernel/salinfo.c                         |    2 +-
 arch/ia64/sn/kernel/sn2/prominfo_proc.c            |    4 ++--
 arch/mips/kernel/smtc-proc.c                       |    2 +-
 arch/mips/pci/ops-pmcmsp.c                         |    4 ++--
 arch/mips/sibyte/sb1250/bus_watcher.c              |    2 +-
 arch/parisc/kernel/pdc_chassis.c                   |    2 +-
 arch/sh/drivers/dma/dma-api.c                      |    2 +-
 drivers/char/ds1620.c                              |    2 +-
 drivers/char/efirtc.c                              |    2 +-
 drivers/char/genrtc.c                              |    2 +-
 drivers/input/misc/hp_sdc_rtc.c                    |    2 +-
 drivers/net/wireless/atmel.c                       |    2 +-
 drivers/net/wireless/hostap/hostap_ap.c            |    4 ++--
 drivers/net/wireless/hostap/hostap_hw.c            |    2 +-
 drivers/net/wireless/hostap/hostap_proc.c          |    6 +++---
 drivers/scsi/megaraid.c                            |    2 +-
 drivers/staging/comedi/proc.c                      |    2 +-
 drivers/staging/csr/io.c                           |    2 +-
 drivers/staging/cxt1e1/sbeproc.c                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/wlags49_h2/wl_main.c               |    2 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    2 +-
 drivers/usb/gadget/goku_udc.c                      |    2 +-
 kernel/rcutree_trace.c                             |    8 ++++----
 33 files changed, 41 insertions(+), 41 deletions(-)
