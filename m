Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3JRRyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3JRRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:54:52 -0400
Date: Fri, 18 Oct 2013 10:56:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.17
Message-ID: <20131018175605.GA18467@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.17 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/arc/include/asm/delay.h            |    5=20
 arch/arc/include/asm/sections.h         |    1=20
 arch/arc/include/asm/spinlock.h         |    9=20
 arch/arc/include/asm/uaccess.h          |    4=20
 arch/arc/kernel/head.S                  |    7=20
 arch/arc/kernel/irq.c                   |    3=20
 arch/arc/kernel/ptrace.c                |    2=20
 arch/arc/kernel/setup.c                 |    3=20
 arch/arc/kernel/signal.c                |   25 -
 arch/arc/kernel/unaligned.c             |    6=20
 arch/arm/include/asm/jump_label.h       |    2=20
 arch/arm/kernel/process.c               |    2=20
 arch/mips/include/asm/jump_label.h      |    2=20
 arch/parisc/kernel/traps.c              |    6=20
 arch/powerpc/include/asm/jump_label.h   |    2=20
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2=20
 arch/s390/include/asm/jump_label.h      |    2=20
 arch/sparc/include/asm/jump_label.h     |    2=20
 arch/x86/include/asm/cpufeature.h       |    2=20
 arch/x86/include/asm/e820.h             |    2=20
 arch/x86/include/asm/jump_label.h       |    2=20
 arch/x86/kernel/e820.c                  |    5=20
 arch/x86/kernel/setup.c                 |   19=20
 drivers/char/random.c                   |    3=20
 drivers/gpu/drm/i915/intel_display.c    |    8=20
 drivers/gpu/drm/radeon/evergreen.c      |    2=20
 drivers/gpu/drm/radeon/evergreend.h     |    4=20
 drivers/gpu/drm/radeon/r600d.h          |    2=20
 drivers/gpu/drm/radeon/radeon_test.c    |    4=20
 drivers/gpu/drm/radeon/sid.h            |    4=20
 drivers/hwmon/applesmc.c                |   13=20
 drivers/i2c/busses/i2c-omap.c           |    3=20
 drivers/watchdog/ts72xx_wdt.c           |    3=20
 fs/btrfs/inode.c                        |    2=20
 fs/dcache.c                             |   11=20
 fs/ext4/xattr.c                         |    2=20
 fs/hugetlbfs/inode.c                    |    8=20
 fs/statfs.c                             |    2=20
 include/linux/compiler-gcc4.h           |   15=20
 include/linux/dcache.h                  |    1=20
 include/linux/ipc_namespace.h           |    2=20
 include/linux/random.h                  |    1=20
 include/linux/sem.h                     |    6=20
 init/main.c                             |    2=20
 ipc/msg.c                               |  281 ++++++++-----
 ipc/namespace.c                         |    7=20
 ipc/sem.c                               |  660 +++++++++++++++++++++------=
-----
 ipc/shm.c                               |  288 ++++++++-----
 ipc/util.c                              |  140 ++----
 ipc/util.h                              |   34 +
 mm/shmem.c                              |    8=20
 sound/pci/hda/patch_hdmi.c              |   18=20
 sound/pci/hda/patch_realtek.c           |   37 +
 sound/usb/usx2y/usbusx2yaudio.c         |   22 -
 sound/usb/usx2y/usx2yhwdeppcm.c         |    7=20
 56 files changed, 1061 insertions(+), 656 deletions(-)

Al Viro (1):
      cope with potentially long ->d_dname() output for shmem/hugetlb

Alex Deucher (1):
      drm/radeon: fix typo in CP DMA register headers

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix channel map switch not taking effect

Chris Wilson (1):
      drm/i915: Only apply DPMS to the encoder if enabled

Christian Ruppert (1):
      ARC: Fix signal frame management for SA_SIGINFO

Dan Carpenter (2):
      watchdog: ts72xx_wdt: locking bug in ioctl
      drm/radeon: forever loop on error in radeon_do_test_moves()

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Dave Jones (1):
      ext4: fix memory leak in xattr

David Henningsson (2):
      ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)
      ALSA: hda - Fix mono speakers and headset mic on Dell Vostro 5470

Davidlohr Bueso (28):
      ipc: move rcu lock out of ipc_addid
      ipc: introduce ipc object locking helpers
      ipc: close open coded spin lock calls
      ipc: move locking out of ipcctl_pre_down_nolock
      ipc,msg: shorten critical region in msgctl_down
      ipc,msg: introduce msgctl_nolock
      ipc,msg: introduce lockless functions to obtain the ipc object
      ipc,msg: make msgctl_nolock lockless
      ipc,msg: shorten critical region in msgsnd
      ipc,msg: shorten critical region in msgrcv
      ipc: remove unused functions
      ipc,shm: introduce lockless functions to obtain the ipc object
      ipc,shm: shorten critical region in shmctl_down
      ipc: drop ipcctl_pre_down
      ipc,shm: introduce shmctl_nolock
      ipc,shm: make shmctl_nolock lockless
      ipc,shm: shorten critical region for shmctl
      ipc,shm: cleanup do_shmat pasta
      ipc,shm: shorten critical region for shmat
      ipc: rename ids->rw_mutex
      ipc,msg: drop msg_unlock
      ipc: document general ipc locking scheme
      ipc, shm: guard against non-existant vma in shmdt(2)
      ipc: drop ipc_lock_by_ptr
      ipc, shm: drop shm_lock_check
      ipc: drop ipc_lock_check
      ipc: fix race with LSMs
      ipc,msg: prevent race with rmid in msgsnd,msgrcv

Greg Kroah-Hartman (1):
      Linux 3.10.17

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Josef Bacik (1):
      Btrfs: use right root when checking for hash collision

Linn Crosetto (1):
      x86: avoid remapping data in parse_setup_data()

Linus Torvalds (1):
      vfs: allow O_PATH file descriptors for fstatfs()

Manfred Spraul (11):
      ipc/util.c, ipc_rcu_alloc: cacheline align allocation
      ipc/sem.c: cacheline align the semaphore structures
      ipc/sem: separate wait-for-zero and alter tasks into seperate queues
      ipc/sem.c: always use only one queue for alter operations
      ipc/sem.c: replace shared sem_otime with per-semaphore value
      ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), docu =
update
      ipc/msg.c: Fix lost wakeup in msgsnd().
      ipc/sem.c: fix race in sem_lock()
      ipc/sem.c: optimize sem_lock()
      ipc/sem.c: synchronize the proc interface
      ipc/sem.c: update sem_otime for all operations

Mischa Jonker (2):
      ARC: Fix __udelay calculation
      ARC: Handle zero-overhead-loop in unaligned access handler

Noam Camus (1):
      ARC: SMP failed to boot due to missing IVT setup

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Russell King (1):
      ARM: Fix the world famous typo with is_gate_vma()

Takashi Iwai (1):
      ALSA: hda - Add fixup for ASUS N56VZ

Taras Kondratiuk (1):
      i2c: omap: Clear ARDY bit twice

Theodore Ts'o (1):
      random: run random_int_secret_init() run after all late_initcalls

Vineet Gupta (4):
      ARC: Setup Vector Table Base in early boot
      ARC: Fix 32-bit wrap around in access_ok()
      ARC: Workaround spinlock livelock in SMP SystemC simulation
      ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYXY1AAoJEDjbvchgkmk+Z1IQAJDbcqZ4olDC34BX0qI2y+mv
Y+7F/ut9UKQXuYGZ533KAE08Zq7aoIDsnHZUvsnUXNFw9SXK0E4LguQpIb0F18bI
2sS85IMXPoE2jAxbjryeMjq+X8mgqKnWdCV/iQjS5WhonxlLRLgOXwW0zjDtae/D
VeD5OabMxrJdFecldf62d/6pvMCqRShA1LJSm9gelwzEFTAAHzMoghaQlVMcDLSv
9vsHFk3IrZ4SeCwvAryP+P5e4bNhKOOvIAFzRUbpTBFqJRSP3sEJY3XnUNQu4bAv
4CvjH75cvfeN5WQMiU7P5i3BfWzyIhrHP0gdTT6rnyL/mKKyuXttBPeKMt4CNjRe
1qhCRRBpz0d/zr/+vHr9kW5uT7yciCUCrxU6IqzBF9ViV4X3BpbF8fRzBlar0hMP
EwpWCJ2CCCaGd5vKmslKCCmyvjpHiZbxzN3X3+8IYMYGmuUkz2LulPJ5CVguxlCZ
PEKqfSBhYHzK7+1lbBj4zODoIVxaj8ShTEX6SYv/keu29C8d2MYbIMyVND/g3Nkf
YdmY6hmGxQkCbXP42mQmUxsP1Z7GdEEpkgvgToPCi2AUcu8G3AhI9SAPgW6fPFHy
DQMTaNot5QMk7rNbnbKXa7oVsxPCLDkaZId4Agq6XneEpupSSETI4xRkxej90QX3
T5caDhDbFHs6tX073Dgu
=0Lfd
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
