Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaDMXFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:05:16 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:36401 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDMXFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:05:14 -0400
MIME-Version: 1.0
Date: Sun, 13 Apr 2014 16:05:12 -0700
X-Google-Sender-Auth: gZEULZUPbeXnsipH4PwuJA90SuM
Message-ID: <CA+55aFykrvKAe29pTUqq8Oc2FKtnFWwU7vxbTQXa7ysZ6xxMXw@mail.gmail.com>
Subject: Linux 3.15-rc1 out, merge window closed
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been two weeks since 3.14 was released, and -rc1 of 3.15 is now
tagged and pushed out, and the patches and tar-balls are going through
the compressors on kernel.org as I write this. Which means that the
merge window is closed, and people should send me fixes only.

And quite frankly, it's about time. This release doesn't really have a
lot of odd things going on, but it's *big*. Sure, we've had releases
with more files and lines changed (3.7-rc1 and 3.11-rc1 in
particular), but those tended to have something particular going on
(3.7-rc1 saw the largely automated UAPI header file disintegration,
and 3.11 saw the bug staging lustre merge).

In comparison to those large releases, 3.15-rc1 is just big in
general. No single big thing, but just lots and lots of commits. Sure,
it has a few big new staging drivers (rtl8723au in particular), but
even when big, those aren't nearly the bulk of things. There's just a
lot going on

In fact, we have the biggest number of commits in recent history
(maybe ever), at just over 12000 non-merge commits (and about 800
merges).

And it really is all over the map. The bulk is driver changes, at
about three quarters of the actual patch. Staging shows up pretty
prominently, but it's really all over the driver map, with networking,
sound, media, gpu, block drivers..)

But there's tons of non-driver stuff too. Outside of the driver
subdirectories, architecture updates account for about half the
changes (with ARM leading the way, largely due to device-tree
descriptors, but there's mips, x86, powerpc, s390, blackfin..). And
the rest is pretty varied too, with core networking, documentation,
kernel, mm, tools etc.

So while drivers and architecture updates are the bulk of it, we
really do have a lot of core changes too.

Anyway, even more than usual, the -rc1 is much too big to include a
shortlog of all commits. But the shortlog of merges I've done might
give at least some overview of all the changes. As usual, the people
credited in the mergelog are the maintainers I pull from, not the
developers that wrote the code. You can see that in the full git logs.

Anyway, because -rc1 is already pretty darn big, I do *not* want to
hear about "sorry this missed the window, can I still sneak in". Fixes
only.

The only exception to that is a couple of pending things that came in
during the merge window, but were explicitly delayed. So we do have a
fbdev file movement pending (I'll do the file movement after -rc1 just
to make things easier to see in the history and not mix up movement
with development). And there was one namespaces/mounting pull request
that I didn't pull, but that might still make it in after some more
commentary/work. That will *probably* be delayed 3.16, but we'll see
how much TLC that thing needs..

                Linus

---

Al Viro (1):
  vfs updates

Alex Williamson (1):
  VFIO updates

Andrew Morton (3):
  first patch-bomb
  second patch-bomb
  a few more patches

Arnd Bergmann (8):
  ARM SoC non-critical bug fixes
  ARM SoC cleanups
  ARM SoC specific changes
  ARM SoC board changes
  ARM SoC device tree changes
  ARM SoC driver changes
  ARM SoC sh driver change
  ARM SoC late cleanups

Artem Bityutskiy (1):
  ubifs updates

Behan Webster (1):
  llvm patches

Ben Herrenschmidt (3):
  main powerpc updates
  powerpc non-virtualized cpuidle
  more powerpc updates

Ben LaHaise (1):
  aio ctx->ring_pages migration serialization fix

Bjorn Helgaas (1):
  PCI changes

Boaz Harrosh (1):
  exofs updates

Borislav Petkov (1):
  EDAC updates

Brian Norris (1):
  MTD updates

Bruce Fields (1):
  nfsd updates

Bryan Wu (1):
  LED updates

Catalin Marinas (2):
  ARM64 updates
  second set of arm64 updates

Chris Ball (1):
  MMC updates

Chris Mason (2):
  btrfs changes
  second set of btrfs updates

Chris Metcalf (1):
  arch/tile updates

Dan Williams (1):
  async SCSI resume support

Dave Airlie (1):
  drm updates

Dave Chinner (1):
  xfs update

David Miller (3):
  networking updates
  more networking updates
  yet more networking updates

David Teigland (1):
  dlm updates

David Vrabel (2):
  Xen features and fixes
  Xen build fix

Dmitry Torokhov (1):
  input updates

Eric Paris (1):
  audit updates

Eric Van Hensbergen (1):
  9p changes

Geert Uytterhoeven (1):
  m68k updates

Grant Likely (1):
  devicetree changes

Greg KH (6):
  char/misc driver patches
  driver core and sysfs updates
  staging driver updates
  tty/serial driver update
  USB patches
  more staging patches

Greg Ungerer (1):
  m68k fixes

Guenter Roeck (2):
  hwmon updates
  second round of hwmon updates

Hans-Christian Egtvedt (1):
  AVR32 updates

Heiko Carstens (1):
  s390 compat wrapper rework

Herbert Xu (1):
  crypto updates

Ingo Molnar (21):
  core locking updates
  RCU updates
  hweight type fix
  perf changes
  scheduler changes
  x86 acpi numa fix
  x86 apic changes
  x86 build change
  x86 cleanups
  x86 cpu handling changes
  x86 debug cleanup
  x86 EFI changes
  x86 hashing changes
  x86 hyperv change
  x86 kaslr update
  x86 mm change
  x86 reboot changes
  x86 cpufeature update
  timer updates
  x86 threadinfo changes
  sched/idle changes

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (1):
  first round of SCSI updates

James Hogan (1):
  Metag architecture changes

James Morris (1):
  security subsystem updates

Jan Kara (1):
  ext3 improvements, cleanups, reiserfs fix

Jean Delvare (1):
  hwmon updates

Jeff Layton (1):
  file locking updates

Jens Axboe (3):
  core block layer updates
  block driver update
  block layer fixes

Jiri Kosina (2):
  trivial tree updates
  HID updates

Joerg Roedel (1):
  IOMMU upates

Jon Mason (1):
  PCIe non-transparent bridge fixes and features

Lee Jones (2):
  MFD updates
  backlight changes

Linus Walleij (2):
  pin control bulk changes
  bulk of gpio updates

Marek Szyprowski (1):
  DMA-mapping updates

Mark Brown (6):
  regmap updates
  regulator updates
  spi Updates
  regmap fix
  regulator fixes
  spi fixes

Martin Schwidefsky (2):
  s390 updates
  second set of s390 patches

Matthew Garrett (1):
  x86 platform driver updates

Matthew Wilcox (1):
  NVMe driver updates

Mauro Carvalho Chehab (4):
  sb_edac patches
  media updates
  exynos media updates
  media fixes

Michal Marek (2):
  kbuild changes
  misc kbuild changes

Michal Simek (1):
  Microblaze updates

Mike Snitzer (1):
  device mapper changes

Mike Turquette (1):
  clock framework changes

Miklos Szeredi (2):
  renameat2 system call
  fuse update

Neil Brown (1):
  md updates

Nicholas Bellinger (1):
  SCSI target updates

Ohad Ben-Cohen (1):
  remoteproc cleanups

Paolo Bonzini (1):
  kvm updates

Pekka Enberg (1):
  slab changes

Peter Anvin (6):
  x86 LTO changes
  x86 boot changes
  x86 vdso changes
  compat time conversion changes
  x86 old platform removal
  x86 fixes

Rafael Wysocki (4):
  ACPI and power management updates
  more ACPI and power management updates
  CPU hotplug notifiers registration fixes
  more ACPI and power management fixes and updates

Ralf Baechle (1):
  MIPS updates

Richard Kuo (1):
  Hexagon updates

Roland Dreier (1):
  infiniband updates

Russell King (2):
  ARM changes
  second set of ARM changes

Rusty Russell (2):
  virtio updates
  module updates

Sage Weil (1):
  Ceph updates

Steven Miao (1):
  blackfin updates

Steven Rostedt (3):
  tracing updates
  single ktest fix
  more tracing updates

Steven Whitehouse (1):
  GFS2 updates

Takashi Iwai (2):
  sound updates
  sound fixes

Ted Ts'o (2):
  ext4 updates
  /dev/random changes

Tejun Heo (5):
  percpu changes
  workqueue changes
  libata updates
  cgroup updates
  cgroup fixes

Thierry Reding (1):
  pwm changes

Thomas Gleixner (3):
  x86 iommu quirk fix
  timer changes
  irq code updates

Tomi Valkeinen (2):
  fbdev changes
  OMAP fbdev changes

Tony Luck (2):
  ia64 updates
  pstore fixes

Trond Myklebust (1):
  NFS client updates

Vineet Gupta (1):
  ARC changes

Vinod Koul (1):
  slave-dmaengine updates

Wim Van Sebroeck (1):
  watchdog updates

Wolfram Sang (1):
  i2c updates

Zhang Rui (1):
  thermal management updates
