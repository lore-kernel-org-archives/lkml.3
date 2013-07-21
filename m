Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3GUFNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 01:13:17 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60711 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3GUFNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 01:13:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rob Landley <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] Documentation/Changes: phase out Changes file that hasn't changed
Date: Sun, 21 Jul 2013 01:12:55 -0400
Message-ID: <1374383575-31493-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been over two years since this file has been touched, and
even that prior change was just to delete some ancient text.

Looking at the bigger picture, the need for this file has simply
passed.  It was trying to detail required versions of userspace
packages, in order to cater to hand-crafted systems.  But now the
majority of users get their userspace all at once from some kind
of distro, and we are probably a lot more serious about avoiding
breaking userspace than we were a dozen years ago.

The remaining data in the file, like (probably stale) links to
old package versions, etc. is also no longer of any real value
today, so let us just remove the file and all references to it.

For a couple references, where it was obvious the surrounding
text was also super ancient (e.g. 1.2.x kernels or similar),
the whole paragraph with the reference was removed.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/00-INDEX              |   2 -
 Documentation/Changes               | 415 ------------------------------------
 Documentation/HOWTO                 |   5 -
 Documentation/filesystems/locks.txt |   4 -
 Documentation/isdn/README           |   3 +-
 Documentation/ja_JP/HOWTO           |   5 -
 Documentation/ko_KR/HOWTO           |   4 -
 Documentation/networking/PLIP.txt   |   3 +-
 Documentation/zh_CN/HOWTO           |   3 -
 README                              |  16 +-
 drivers/net/ppp/Kconfig             |   5 +-
 drivers/pcmcia/Kconfig              |   3 +-
 fs/Kconfig.binfmt                   |   6 -
 fs/fuse/Kconfig                     |   1 -
 net/Kconfig                         |   7 +-
 scripts/ver_linux                   |   1 -
 16 files changed, 8 insertions(+), 475 deletions(-)
 delete mode 100644 Documentation/Changes

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 0c4cc68..ec40988 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -17,8 +17,6 @@ ABI/
 
 BUG-HUNTING
 	- brute force method of doing binary search of patches to find bug.
-Changes
-	- list of changes that break older software packages.
 CodingStyle
 	- how the maintainers expect the C code in the kernel to look.
 DMA-API.txt
diff --git a/Documentation/Changes b/Documentation/Changes
deleted file mode 100644
index b175808..0000000
--- a/Documentation/Changes
+++ /dev/null
@@ -1,415 +0,0 @@
-Intro
-=====
-
-This document is designed to provide a list of the minimum levels of
-software necessary to run the 3.0 kernels.
-
-This document is originally based on my "Changes" file for 2.0.x kernels
-and therefore owes credit to the same people as that file (Jared Mauch,
-Axel Boldt, Alessandro Sigala, and countless other users all over the
-'net).
-
-Current Minimal Requirements
-============================
-
-Upgrade to at *least* these software revisions before thinking you've
-encountered a bug!  If you're unsure what version you're currently
-running, the suggested command should tell you.
-
-Again, keep in mind that this list assumes you are already functionally
-running a Linux kernel.  Also, not all tools are necessary on all
-systems; obviously, if you don't have any ISDN hardware, for example,
-you probably needn't concern yourself with isdn4k-utils.
-
-o  Gnu C                  3.2                     # gcc --version
-o  Gnu make               3.80                    # make --version
-o  binutils               2.12                    # ld -v
-o  util-linux             2.10o                   # fdformat --version
-o  module-init-tools      0.9.10                  # depmod -V
-o  e2fsprogs              1.41.4                  # e2fsck -V
-o  jfsutils               1.1.3                   # fsck.jfs -V
-o  reiserfsprogs          3.6.3                   # reiserfsck -V
-o  xfsprogs               2.6.0                   # xfs_db -V
-o  squashfs-tools         4.0                     # mksquashfs -version
-o  btrfs-progs            0.18                    # btrfsck
-o  pcmciautils            004                     # pccardctl -V
-o  quota-tools            3.09                    # quota -V
-o  PPP                    2.4.0                   # pppd --version
-o  isdn4k-utils           3.1pre1                 # isdnctrl 2>&1|grep version
-o  nfs-utils              1.0.5                   # showmount --version
-o  procps                 3.2.0                   # ps --version
-o  oprofile               0.9                     # oprofiled --version
-o  udev                   081                     # udevd --version
-o  grub                   0.93                    # grub --version || grub-install --version
-o  mcelog                 0.6                     # mcelog --version
-o  iptables               1.4.2                   # iptables -V
-
-
-Kernel compilation
-==================
-
-GCC
----
-
-The gcc version requirements may vary depending on the type of CPU in your
-computer.
-
-Make
-----
-
-You will need Gnu make 3.80 or later to build the kernel.
-
-Binutils
---------
-
-Linux on IA-32 has recently switched from using as86 to using gas for
-assembling the 16-bit boot code, removing the need for as86 to compile
-your kernel.  This change does, however, mean that you need a recent
-release of binutils.
-
-Perl
-----
-
-You will need perl 5 and the following modules: Getopt::Long, Getopt::Std,
-File::Basename, and File::Find to build the kernel.
-
-
-System utilities
-================
-
-Architectural changes
----------------------
-
-DevFS has been obsoleted in favour of udev
-(http://www.kernel.org/pub/linux/utils/kernel/hotplug/)
-
-32-bit UID support is now in place.  Have fun!
-
-Linux documentation for functions is transitioning to inline
-documentation via specially-formatted comments near their
-definitions in the source.  These comments can be combined with the
-SGML templates in the Documentation/DocBook directory to make DocBook
-files, which can then be converted by DocBook stylesheets to PostScript,
-HTML, PDF files, and several other formats.  In order to convert from
-DocBook format to a format of your choice, you'll need to install Jade as
-well as the desired DocBook stylesheets.
-
-Util-linux
-----------
-
-New versions of util-linux provide *fdisk support for larger disks,
-support new options to mount, recognize more supported partition
-types, have a fdformat which works with 2.4 kernels, and similar goodies.
-You'll probably want to upgrade.
-
-Ksymoops
---------
-
-If the unthinkable happens and your kernel oopses, you may need the
-ksymoops tool to decode it, but in most cases you don't.
-It is generally preferred to build the kernel with CONFIG_KALLSYMS so
-that it produces readable dumps that can be used as-is (this also
-produces better output than ksymoops).  If for some reason your kernel
-is not build with CONFIG_KALLSYMS and you have no way to rebuild and
-reproduce the Oops with that option, then you can still decode that Oops
-with ksymoops.
-
-Module-Init-Tools
------------------
-
-A new module loader is now in the kernel that requires module-init-tools
-to use.  It is backward compatible with the 2.4.x series kernels.
-
-Mkinitrd
---------
-
-These changes to the /lib/modules file tree layout also require that
-mkinitrd be upgraded.
-
-E2fsprogs
----------
-
-The latest version of e2fsprogs fixes several bugs in fsck and
-debugfs.  Obviously, it's a good idea to upgrade.
-
-JFSutils
---------
-
-The jfsutils package contains the utilities for the file system.
-The following utilities are available:
-o fsck.jfs - initiate replay of the transaction log, and check
-  and repair a JFS formatted partition.
-o mkfs.jfs - create a JFS formatted partition.
-o other file system utilities are also available in this package.
-
-Reiserfsprogs
--------------
-
-The reiserfsprogs package should be used for reiserfs-3.6.x
-(Linux kernels 2.4.x). It is a combined package and contains working
-versions of mkreiserfs, resize_reiserfs, debugreiserfs and
-reiserfsck. These utils work on both i386 and alpha platforms.
-
-Xfsprogs
---------
-
-The latest version of xfsprogs contains mkfs.xfs, xfs_db, and the
-xfs_repair utilities, among others, for the XFS filesystem.  It is
-architecture independent and any version from 2.0.0 onward should
-work correctly with this version of the XFS kernel code (2.6.0 or
-later is recommended, due to some significant improvements).
-
-PCMCIAutils
------------
-
-PCMCIAutils replaces pcmcia-cs (see below). It properly sets up
-PCMCIA sockets at system startup and loads the appropriate modules
-for 16-bit PCMCIA devices if the kernel is modularized and the hotplug
-subsystem is used.
-
-Pcmcia-cs
----------
-
-PCMCIA (PC Card) support is now partially implemented in the main
-kernel source. The "pcmciautils" package (see above) replaces pcmcia-cs
-for newest kernels.
-
-Quota-tools
------------
-
-Support for 32 bit uid's and gid's is required if you want to use
-the newer version 2 quota format.  Quota-tools version 3.07 and
-newer has this support.  Use the recommended version or newer
-from the table above.
-
-Intel IA32 microcode
---------------------
-
-A driver has been added to allow updating of Intel IA32 microcode,
-accessible as a normal (misc) character device.  If you are not using
-udev you may need to:
-
-mkdir /dev/cpu
-mknod /dev/cpu/microcode c 10 184
-chmod 0644 /dev/cpu/microcode
-
-as root before you can use this.  You'll probably also want to
-get the user-space microcode_ctl utility to use with this.
-
-Powertweak
-----------
-
-If you are running v0.1.17 or earlier, you should upgrade to
-version v0.99.0 or higher. Running old versions may cause problems
-with programs using shared memory.
-
-udev
-----
-udev is a userspace application for populating /dev dynamically with
-only entries for devices actually present.  udev replaces the basic
-functionality of devfs, while allowing persistent device naming for
-devices.
-
-FUSE
-----
-
-Needs libfuse 2.4.0 or later.  Absolute minimum is 2.3.0 but mount
-options 'direct_io' and 'kernel_cache' won't work.
-
-Networking
-==========
-
-General changes
----------------
-
-If you have advanced network configuration needs, you should probably
-consider using the network tools from ip-route2.
-
-Packet Filter / NAT
--------------------
-The packet filtering and NAT code uses the same tools like the previous 2.4.x
-kernel series (iptables).  It still includes backwards-compatibility modules
-for 2.2.x-style ipchains and 2.0.x-style ipfwadm.
-
-PPP
----
-
-The PPP driver has been restructured to support multilink and to
-enable it to operate over diverse media layers.  If you use PPP,
-upgrade pppd to at least 2.4.0.
-
-If you are not using udev, you must have the device file /dev/ppp
-which can be made by:
-
-mknod /dev/ppp c 108 0
-
-as root.
-
-Isdn4k-utils
-------------
-
-Due to changes in the length of the phone number field, isdn4k-utils
-needs to be recompiled or (preferably) upgraded.
-
-NFS-utils
----------
-
-In ancient (2.4 and earlier) kernels, the nfs server needed to know
-about any client that expected to be able to access files via NFS.  This
-information would be given to the kernel by "mountd" when the client
-mounted the filesystem, or by "exportfs" at system startup.  exportfs
-would take information about active clients from /var/lib/nfs/rmtab.
-
-This approach is quite fragile as it depends on rmtab being correct
-which is not always easy, particularly when trying to implement
-fail-over.  Even when the system is working well, rmtab suffers from
-getting lots of old entries that never get removed.
-
-With modern kernels we have the option of having the kernel tell mountd
-when it gets a request from an unknown host, and mountd can give
-appropriate export information to the kernel.  This removes the
-dependency on rmtab and means that the kernel only needs to know about
-currently active clients.
-
-To enable this new functionality, you need to:
-
-  mount -t nfsd nfsd /proc/fs/nfsd
-
-before running exportfs or mountd.  It is recommended that all NFS
-services be protected from the internet-at-large by a firewall where
-that is possible.
-
-mcelog
-------
-
-In Linux 2.6.31+ the i386 kernel needs to run the mcelog utility
-as a regular cronjob similar to the x86-64 kernel to process and log
-machine check events when CONFIG_X86_NEW_MCE is enabled. Machine check
-events are errors reported by the CPU. Processing them is strongly encouraged.
-All x86-64 kernels since 2.6.4 require the mcelog utility to
-process machine checks.
-
-Getting updated software
-========================
-
-Kernel compilation
-******************
-
-gcc
----
-o  <ftp://ftp.gnu.org/gnu/gcc/>
-
-Make
-----
-o  <ftp://ftp.gnu.org/gnu/make/>
-
-Binutils
---------
-o  <ftp://ftp.kernel.org/pub/linux/devel/binutils/>
-
-System utilities
-****************
-
-Util-linux
-----------
-o  <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>
-
-Ksymoops
---------
-o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
-
-Module-Init-Tools
------------------
-o  <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
-
-Mkinitrd
---------
-o  <https://code.launchpad.net/initrd-tools/main>
-
-E2fsprogs
----------
-o  <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.29.tar.gz>
-
-JFSutils
---------
-o  <http://jfs.sourceforge.net/>
-
-Reiserfsprogs
--------------
-o  <http://www.kernel.org/pub/linux/utils/fs/reiserfs/>
-
-Xfsprogs
---------
-o  <ftp://oss.sgi.com/projects/xfs/>
-
-Pcmciautils
------------
-o  <ftp://ftp.kernel.org/pub/linux/utils/kernel/pcmcia/>
-
-Pcmcia-cs
----------
-o  <http://pcmcia-cs.sourceforge.net/>
-
-Quota-tools
-----------
-o  <http://sourceforge.net/projects/linuxquota/>
-
-DocBook Stylesheets
--------------------
-o  <http://nwalsh.com/docbook/dsssl/>
-
-XMLTO XSLT Frontend
--------------------
-o  <http://cyberelk.net/tim/xmlto/>
-
-Intel P6 microcode
-------------------
-o  <http://www.urbanmyth.org/microcode/>
-
-Powertweak
-----------
-o  <http://powertweak.sourceforge.net/>
-
-udev
-----
-o <http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html>
-
-FUSE
-----
-o <http://sourceforge.net/projects/fuse>
-
-mcelog
-------
-o <ftp://ftp.kernel.org/pub/linux/utils/cpu/mce/>
-
-Networking
-**********
-
-PPP
----
-o  <ftp://ftp.samba.org/pub/ppp/>
-
-Isdn4k-utils
-------------
-o  <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/>
-
-NFS-utils
----------
-o  <http://sourceforge.net/project/showfiles.php?group_id=14>
-
-Iptables
---------
-o  <http://www.iptables.org/downloads.html>
-
-Ip-route2
----------
-o  <ftp://ftp.tux.org/pub/net/ip-routing/iproute2-2.2.4-now-ss991023.tar.gz>
-
-OProfile
---------
-o  <http://oprofile.sf.net/download/>
-
-NFS-Utils
----------
-o  <http://nfs.sourceforge.net/>
-
diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 27faae3..506c77e 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -87,11 +87,6 @@ required reading:
     what is necessary to do to configure and build the kernel.  People
     who are new to the kernel should start here.
 
-  Documentation/Changes
-    This file gives a list of the minimum levels of various software
-    packages that are necessary to build and run the kernel
-    successfully.
-
   Documentation/CodingStyle
     This describes the Linux kernel coding style, and some of the
     rationale behind it. All new code is expected to follow the
diff --git a/Documentation/filesystems/locks.txt b/Documentation/filesystems/locks.txt
index 2cf8108..42861db 100644
--- a/Documentation/filesystems/locks.txt
+++ b/Documentation/filesystems/locks.txt
@@ -17,10 +17,6 @@ release of the 2.1.x kernel series, support for the old emulation has
 been totally removed, so that we don't need to carry this baggage
 forever.
 
-This should not cause problems for anybody, since everybody using a
-2.1.x kernel should have updated their C library to a suitable version
-anyway (see the file "Documentation/Changes".)
-
 1.2 Allow Mixed Locks Again
 ---------------------------
 
diff --git a/Documentation/isdn/README b/Documentation/isdn/README
index cfb1884..6dcdd52 100644
--- a/Documentation/isdn/README
+++ b/Documentation/isdn/README
@@ -320,8 +320,7 @@ README for the ISDN-subsystem
 
   ATTENTION!
 
-  Always use the latest module utilities. The current version is
-  named in Documentation/Changes. Some old versions of insmod
+  Always use the latest module utilities.  Some old versions of insmod
   are not capable of setting the driver-Ids correctly.
 
 3. Lowlevel-driver configuration.
diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 050d37f..eb58b1c 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -122,11 +122,6 @@ linux-api@ver.kernel.org に送ることを勧めます。
     ています。カーネルに関して初めての人はここからスタートすると良いで
     しょう。
 
-  Documentation/Changes
-     このファイルはカーネルをうまく生成(訳注 build )し、走らせるのに最
-     小限のレベルで必要な数々のソフトウェアパッケージの一覧を示してい
-     ます。
-
   Documentation/CodingStyle
     これは Linux カーネルのコーディングスタイルと背景にある理由を記述
     しています。全ての新しいコードはこのドキュメントにあるガイドライン
diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 2f48f20..5d41e1a 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -98,10 +98,6 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
     빌드하기 위해 필요한 것을 설명한다. 커널에 입문하는 사람들은 여기서
     시작해야 한다.
 
-  Documentation/Changes
-    이 파일은 커널을 성공적으로 빌드하고 실행시키기 위해 필요한 다양한
-    소프트웨어 패키지들의 최소 버젼을 나열한다.
-
   Documentation/CodingStyle
     이 문서는 리눅스 커널 코딩 스타일과 그렇게 한 몇몇 이유를 설명한다.
     모든 새로운 코드는 이 문서에 가이드라인들을 따라야 한다. 대부분의
diff --git a/Documentation/networking/PLIP.txt b/Documentation/networking/PLIP.txt
index ad7e3f7..3cb3c60 100644
--- a/Documentation/networking/PLIP.txt
+++ b/Documentation/networking/PLIP.txt
@@ -101,8 +101,7 @@ in which case a long timeout would stall the machine when, for whatever
 reason, bits are dropped.
 
 A utility that can perform this change in Linux is plipconfig, which is part
-of the net-tools package (its location can be found in the
-Documentation/Changes file). An example command would be
+of the net-tools package.  An example command would be
 'plipconfig plipX trigger 10000', where plipX is the appropriate
 PLIP device.
 
diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 7fba5aa..4f1e735 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -93,9 +93,6 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
     文件简要介绍了Linux内核的背景，并且描述了如何配置和编译内核。内核的
     新用户应该从这里开始。
 
-  Documentation/Changes
-    文件给出了用来编译和使用内核所需要的最小软件包列表。
-
   Documentation/CodingStyle
     描述Linux内核的代码风格和理由。所有新代码需要遵守这篇文档中定义的规
     范。大多数维护者只会接收符合规定的补丁，很多人也只会帮忙检查符合风格
diff --git a/README b/README
index a24ec89..44b1a50 100644
--- a/README
+++ b/README
@@ -46,9 +46,7 @@ DOCUMENTATION:
  - There are various README files in the Documentation/ subdirectory:
    these typically contain kernel-specific installation notes for some 
    drivers for example. See Documentation/00-INDEX for a list of what
-   is contained in each file.  Please read the Changes file, as it
-   contains information about the problems, which may result by upgrading
-   your kernel.
+   is contained in each file.
 
  - The Documentation/DocBook/ subdirectory contains several guides for
    kernel developers and users.  These guides can be rendered in a
@@ -118,17 +116,6 @@ INSTALLING the kernel source:
 
    You should now have the sources correctly installed.
 
-SOFTWARE REQUIREMENTS
-
-   Compiling and running the 3.x kernels requires up-to-date
-   versions of various software packages.  Consult
-   Documentation/Changes for the minimum version numbers required
-   and how to get updates for these packages.  Beware that using
-   excessively old versions of these packages can cause indirect
-   errors that are very difficult to track down, so don't assume that
-   you can just update packages when obvious problems arise during
-   build or operation.
-
 BUILD directory for the kernel:
 
    When compiling the kernel, all output files will per default be
@@ -257,7 +244,6 @@ CONFIGURING the kernel:
 COMPILING the kernel:
 
  - Make sure you have at least gcc 3.2 available.
-   For more information, refer to Documentation/Changes.
 
    Please note that you can still run a.out user programs with this kernel.
 
diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 1373c6d..75db6f5 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -14,9 +14,8 @@ config PPP
 
 	  To use PPP, you need an additional program called pppd as described
 	  in the PPP-HOWTO, available at
-	  <http://www.tldp.org/docs.html#howto>.  Make sure that you have
-	  the version of pppd recommended in <file:Documentation/Changes>.
-	  The PPP option enlarges your kernel by about 16 KB.
+	  <http://www.tldp.org/docs.html#howto>.  The PPP option enlarges your
+	  kernel by about 16 KB.
 
 	  There are actually two versions of PPP: the traditional PPP for
 	  asynchronous lines, such as regular analog phone lines, and
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 0c657d6..95d6cb7 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -26,8 +26,7 @@ config PCMCIA
 	   only using 32-bit CardBus cards, say Y or M here.
 
 	   To use 16-bit PCMCIA cards, you will need supporting software in
-	   most cases. (see the file <file:Documentation/Changes> for
-	   location and details).
+	   most cases.
 
 	   To compile this driver as modules, choose M here: the
 	   module will be called pcmcia.
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 370b24c..5fa78a0 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -17,12 +17,6 @@ config BINFMT_ELF
 	  Information about ELF is contained in the ELF HOWTO available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  If you find that after upgrading from Linux kernel 1.2 and saying Y
-	  here, you still can't run any ELF binaries (they just crash), then
-	  you'll have to install the newest ELF runtime libraries, including
-	  ld.so (check the file <file:Documentation/Changes> for location and
-	  latest version).
-
 config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 1b2f6c2..f2212c9 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -11,7 +11,6 @@ config FUSE_FS
 	  installed if you've installed the "fuse" package itself.
 
 	  See <file:Documentation/filesystems/fuse.txt> for more information.
-	  See <file:Documentation/Changes> for needed library/utility version.
 
 	  If you want to develop a userspace FS, or if you want to use
 	  a filesystem based on FUSE, answer Y or M.
diff --git a/net/Kconfig b/net/Kconfig
index 3770249..045efe1 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -15,8 +15,7 @@ menuconfig NET
 	  If you are upgrading from an older kernel, you
 	  should consider updating your networking tools too because changes
 	  in the kernel and the tools often go hand in hand. The tools are
-	  contained in the package net-tools, the location and version number
-	  of which are given in <file:Documentation/Changes>.
+	  contained in the package net-tools.
 
 	  For a general introduction to Linux networking, it is highly
 	  recommended to read the NET-HOWTO, available from
@@ -147,9 +146,7 @@ menuconfig NETFILTER
 
 	  Various modules exist for netfilter which replace the previous
 	  masquerading (ipmasqadm), packet filtering (ipchains), transparent
-	  proxying, and portforwarding mechanisms. Please see
-	  <file:Documentation/Changes> under "iptables" for the location of
-	  these packages.
+	  proxying, and portforwarding mechanisms.
 
 if NETFILTER
 
diff --git a/scripts/ver_linux b/scripts/ver_linux
index 7de36df..de9e097 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -5,7 +5,6 @@
 # differ on your system.
 #
 echo 'If some fields are empty or look unusual you may have an old version.'
-echo 'Compare to the current minimal requirements in Documentation/Changes.'
 echo ' '
 
 uname -a
-- 
1.8.1.2

