Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3IPWIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:08:14 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:44906 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:08:13 -0400
MIME-Version: 1.0
Date: Mon, 16 Sep 2013 18:08:11 -0400
X-Google-Sender-Auth: Zn803WE1mNp7YOa19Jbz-JWNfQw
Message-ID: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
Subject: Linux 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been two weeks, and the merge window for 3.12 is now closed.

The git trees have been updated, the tar-balls and patches should be
out too, and here's my "short mergelog" for the merge window: it's
kind of like "git shortlog", except it names the person I merged from
(_not_ necessarily the author of the actual work, but the maintainer
who sent me the pull request) along with a very short description of
what the pull was for.

In general, this merge window was fairly normal. About 73% drivers,
12% architecture updates, and 6% filesystems. The rest falls under
"misc".

I personally particularly like the scalability improvements that got
merged this time around. The tty layer locking got cleaned up and in
the process a lot of locking became per-tty, which actually shows up
on some (admittedly odd) loads. And the dentry refcount scalability
work means that the filename caches now scale very well indeed, even
for the case where you look up the same directory or file (which could
historically result in contention on the per-dentry d_lock).

But those things aren't noticeable on normal machines, I'm just odd
and tend to get excited about improvements to our dentry cache. Just
because it's one of the more interesting parts of the core code to me
personally.

So most other people will probably care more about all the driver
updates that actually affect more everyday life.

Go forth and test,

              Linus

---

Al Viro (4):
  vfs pile 1
  vfs pile 2 (of many)
  vfs pile 3 (of many)
  vfs pile 4

Alex Williamson (1):
  VFIO update

Andrew Morton (2):
  first patch-bomb
  more patches

Anton Vorontsov (1):
  battery/power supply driver updates

Artem Bityutskiy (2):
  ubifs fix
  UBI fixes

Ben Herrenschmidt (2):
  powerpc updates
  powerpc fixes

Ben LaHaise (1):
  aio changes

Ben Myers (2):
  xfs updates
  xfs update #2

Bjorn Helgaas (1):
  PCI changes

Bruce Fields (1):
  nfsd updates

Bryan Wu (1):
  led updates

Catalin Marinas (1):
  ARM64 update

Chris Ball (1):
  MMC updates

Chris Mason (1):
  btrfs updates

Chris Metcalf (1):
  Tile arch updates

Chris Zankel (1):
  Xtensa updates

Dan Williams (1):
  dmaengine update

Dave Airlie (2):
  drm tree changes
  drm fixes

David Miller (5):
  networking changes
  sparc changes
  IDE changes
  networking fixes
  networking fixes

David Teigland (1):
  dlm updates

David Woodhouse (1):
  mtd updates

Dmitry Torokhov (2):
  input updates
  input update

Eric Biederman (1):
  namespace changes

Eric Van Hensbergen (1):
  9p updates

Geert Uytterhoeven (1):
  m68k updates

Gleb Natapov (1):
  KVM updates

Grant Likely (1):
  device tree core updates

Greg KH (5):
  USB patches
  char/misc patches
  driver core patches
  staging tree merge
  tty/serial driver patches

Greg Ungerer (1):
  m68knommu fixes

Guenter Roeck (3):
  hwmon updates
  hwmon cleanups
  hwmon fixes

Heiko Carstens (1):
  more s390 updates

Herbert Xu (2):
  crypto update
  crypto fixes

Ingo Molnar (23):
  RCU updates
  core/locking changes
  perf changes
  scheduler changes
  timer changes
  x86/apic changes
  x86/asm changes
  x86/asmlinkage changes
  tiny x86 boot cleanups
  x86 cpu feature fixes
  x86 fb changes
  timers/nohz changes
  x86 relocation changes
  x86 mm changes
  x86 paravirt changes
  x86 platform documentation fix
  x86 RAS changes
  x86 SMAP fixes
  x86 spinlock changes
  x86 fixes
  cputime fix
  scheduler fix
  perf fixes

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (2):
  first round of SCSI updates
  misc SCSI driver updates

James Hogan (1):
  metag architecture changes

James Morris (1):
  security subsystem updates

Jan Kara (1):
  ext3, reiserfs, udf & isofs fixes

Jean Delvare (1):
  hwmon fixes

Jesper Nilsson (1):
  CRIS updates

Jiri Kosina (2):
  HID updates
  trivial tree

Joerg Roedel (1):
  IOMMU Updates

Jon Mason (1):
  NTB (non-transparent bridge) updates

Kevin Hilman (3):
  ARM SoC driver update
  ARM Renesas SoC cleanup, refactoring and more SMP support
  ARM SoC late changes

Konrad Rzeszutek Wilk (2):
  Xen updates
  Xen bug-fixes

Linus Walleij (2):
  pin control changes
  GPIO updates

Marek Szyprowski (2):
  DMA mapping update
  DMA-mapping fix

Mark Brown (3):
  regmap updates
  spi updates
  regulator updates

Martin Schwidefsky (2):
  first batch of s390 updates
  generic hardirq option removal

Matthew Garrett (1):
  x86 platform updates

Matthew Wilcox (1):
  NVM Express driver update

Mauro Carvalho Chehab (1):
  media updates

Michael Turquette (1):
  clock framework changes

Michal Marek (4):
  kbuild update
  misc kbuild updates
  kconfig updates
  kconfig fix

Michal Simek (1):
  Microblaze patches

Mike Snitzer (1):
  device-mapper updates

Miklos Szeredi (1):
  fuse bugfixes

Neil Brown (1):
  md update

Nicholas Bellinger (2):
  SCSI target fixes
  SCSI target updates

Olof Johansson (6):
  ARM SoC low-priority fixes
  ARM SoC cleanups
  ARM SoC DT updates
  ARM SoC platform changes
  ARM SoC board updates
  ARM SoC fixes

Pekka Enberg (1):
  SLAB update

Peter Anvin (1):
  x86 jumplabel changes

Phillip Lougher (1):
  squashfs updates

Rafael Wysocki (2):
  ACPI and power management updates
  ACPI and power management fixes

Ralf Baechle (2):
  MIPS updates
  MIPS fixes

Richard Weinberger (1):
  UML updates

Roland Dreier (1):
  main batch of InfiniBand/RDMA changes

Russell King (2):
  ARM updates
  ARM fixes

Rusty Russell (3):
  PTR_RET() removal patches
  module updates
  virtio update

Sage Weil (1):
  ceph updates

Samuel Ortiz (1):
  MFD (multi-function device) updates

Stefan Richter (1):
  firewire updates

Stefano Stabellini (1):
  Xen balloon driver bug-fixes

Steve French (2):
  CIFS fixes
  CIFS fixes

Steven Miao (1):
  blackfin updates

Steven Rostedt (1):
  tracing updates

Steven Whitehouse (1):
  GFS2 updates

Sumit Semwal (1):
  dma-buf updates

Takashi Iwai (2):
  sound updates
  sound fixes

Ted Ts'o (1):
  ext4 updates

Tejun Heo (4):
  single percpu update
  workqueue updates
  libata changes
  cgroup updates

Thierry Reding (1):
  pwm changes

Thomas Gleixner (1):
  timer code update

Tomi Valkeinen (2):
  OMAP specific fbdev changes
  fbdev changes

Tony Luck (2):
  pstore changes
  ia64 fixes

Trond Myklebust (2):
  NFS client updates
  NFS client bugfixes (part 2)

Tyler Hicks (1):
  eCryptfs fixes

Vineet Gupta (1):
  ARC changes

Vinod Koul (1):
  slave-dmaengine updates

Wim Van Sebroeck (1):
  watchdog updates

Wolfram Sang (1):
  i2c updates

Wu Fengguang (1):
  writeback fix

Zhang Rui (1):
  thermal management updates
