Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3JRTw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:52:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3JRTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/11] 3.4.67-stable review
Date: Fri, 18 Oct 2013 12:53:29 -0700
Message-Id: <20131018195049.069623827@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.67 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 20 19:50:39 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.67-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.67-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    mm: do not grow the stack vma just because of an overrun on preceding vma

Cyril Hrubis <chrubis@suse.cz>
    mm/mmap: check for RLIMIT_AS before unmapping

wojciech kapuscinski <wojtask9@wp.pl>
    drm/radeon: fix hw contexts for SUMO2 asics

Dan Carpenter <dan.carpenter@oracle.com>
    watchdog: ts72xx_wdt: locking bug in ioctl

Helge Deller <deller@gmx.de>
    parisc: fix interruption handler to respect pagefault_disable()

Paul Mackerras <paulus@samba.org>
    KVM: PPC: Book3S HV: Fix typo in saving DSCR

Dave Jones <davej@redhat.com>
    ext4: fix memory leak in xattr

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: allow O_PATH file descriptors for fstatfs()

Theodore Ts'o <tytso@mit.edu>
    random: run random_int_secret_init() run after all late_initcalls

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add fixup for ASUS N56VZ

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb-usx2y: remove bogus frame checks


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/parisc/kernel/traps.c              |  6 +--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 +-
 drivers/char/random.c                   |  3 +-
 drivers/gpu/drm/radeon/evergreen.c      |  2 +-
 drivers/watchdog/ts72xx_wdt.c           |  3 +-
 fs/ext4/xattr.c                         |  2 +
 fs/statfs.c                             |  2 +-
 include/linux/random.h                  |  1 +
 init/main.c                             |  2 +
 mm/mmap.c                               | 77 +++++++++++++++++++++++++++++++--
 sound/pci/hda/patch_realtek.c           |  1 +
 sound/usb/usx2y/usbusx2yaudio.c         | 22 ++--------
 sound/usb/usx2y/usx2yhwdeppcm.c         |  7 +--
 14 files changed, 94 insertions(+), 40 deletions(-)


