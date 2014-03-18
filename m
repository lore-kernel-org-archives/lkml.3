Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaCRUMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:12:20 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35902 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbaCRUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:12:09 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 1/3] usbip: move usbip userspace code out of staging
Date: Tue, 18 Mar 2014 22:11:21 +0200
Message-Id: <1395173483-27542-2-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, USB/IP userspace code is fully functional
and can be moved out of staging.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/.gitignore         |  28 -
 drivers/staging/usbip/userspace/AUTHORS            |   3 -
 drivers/staging/usbip/userspace/COPYING            | 340 -----------
 drivers/staging/usbip/userspace/INSTALL            | 237 --------
 drivers/staging/usbip/userspace/Makefile.am        |   6 -
 drivers/staging/usbip/userspace/README             | 203 -------
 drivers/staging/usbip/userspace/autogen.sh         |   9 -
 drivers/staging/usbip/userspace/cleanup.sh         |  12 -
 drivers/staging/usbip/userspace/configure.ac       | 111 ----
 drivers/staging/usbip/userspace/doc/usbip.8        |  95 ---
 drivers/staging/usbip/userspace/doc/usbipd.8       |  91 ---
 drivers/staging/usbip/userspace/libsrc/Makefile.am |   8 -
 drivers/staging/usbip/userspace/libsrc/list.h      | 136 -----
 drivers/staging/usbip/userspace/libsrc/names.c     | 504 ---------------
 drivers/staging/usbip/userspace/libsrc/names.h     |  41 --
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   |  31 -
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |   8 -
 .../staging/usbip/userspace/libsrc/usbip_common.c  | 285 ---------
 .../staging/usbip/userspace/libsrc/usbip_common.h  | 137 -----
 .../usbip/userspace/libsrc/usbip_host_driver.c     | 276 ---------
 .../usbip/userspace/libsrc/usbip_host_driver.h     |  49 --
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 411 -------------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |  59 --
 drivers/staging/usbip/userspace/src/Makefile.am    |  11 -
 drivers/staging/usbip/userspace/src/usbip.c        | 201 ------
 drivers/staging/usbip/userspace/src/usbip.h        |  40 --
 drivers/staging/usbip/userspace/src/usbip_attach.c | 240 --------
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 214 -------
 drivers/staging/usbip/userspace/src/usbip_detach.c | 110 ----
 drivers/staging/usbip/userspace/src/usbip_list.c   | 283 ---------
 .../staging/usbip/userspace/src/usbip_network.c    | 303 ---------
 .../staging/usbip/userspace/src/usbip_network.h    | 185 ------
 drivers/staging/usbip/userspace/src/usbip_port.c   |  57 --
 drivers/staging/usbip/userspace/src/usbip_unbind.c | 141 -----
 drivers/staging/usbip/userspace/src/usbipd.c       | 675 ---------------------
 drivers/staging/usbip/userspace/src/utils.c        |  52 --
 drivers/staging/usbip/userspace/src/utils.h        |  25 -
 tools/usb/usbip/.gitignore                         |  28 +
 tools/usb/usbip/AUTHORS                            |   3 +
 tools/usb/usbip/COPYING                            | 340 +++++++++++
 tools/usb/usbip/INSTALL                            | 237 ++++++++
 tools/usb/usbip/Makefile.am                        |   6 +
 tools/usb/usbip/README                             | 203 +++++++
 tools/usb/usbip/autogen.sh                         |   9 +
 tools/usb/usbip/cleanup.sh                         |  12 +
 tools/usb/usbip/configure.ac                       | 111 ++++
 tools/usb/usbip/doc/usbip.8                        |  95 +++
 tools/usb/usbip/doc/usbipd.8                       |  91 +++
 tools/usb/usbip/libsrc/Makefile.am                 |   8 +
 tools/usb/usbip/libsrc/list.h                      | 136 +++++
 tools/usb/usbip/libsrc/names.c                     | 504 +++++++++++++++
 tools/usb/usbip/libsrc/names.h                     |  41 ++
 tools/usb/usbip/libsrc/sysfs_utils.c               |  31 +
 tools/usb/usbip/libsrc/sysfs_utils.h               |   8 +
 tools/usb/usbip/libsrc/usbip_common.c              | 285 +++++++++
 tools/usb/usbip/libsrc/usbip_common.h              | 137 +++++
 tools/usb/usbip/libsrc/usbip_host_driver.c         | 276 +++++++++
 tools/usb/usbip/libsrc/usbip_host_driver.h         |  49 ++
 tools/usb/usbip/libsrc/vhci_driver.c               | 411 +++++++++++++
 tools/usb/usbip/libsrc/vhci_driver.h               |  59 ++
 tools/usb/usbip/src/Makefile.am                    |  11 +
 tools/usb/usbip/src/usbip.c                        | 201 ++++++
 tools/usb/usbip/src/usbip.h                        |  40 ++
 tools/usb/usbip/src/usbip_attach.c                 | 240 ++++++++
 tools/usb/usbip/src/usbip_bind.c                   | 214 +++++++
 tools/usb/usbip/src/usbip_detach.c                 | 110 ++++
 tools/usb/usbip/src/usbip_list.c                   | 283 +++++++++
 tools/usb/usbip/src/usbip_network.c                | 303 +++++++++
 tools/usb/usbip/src/usbip_network.h                | 185 ++++++
 tools/usb/usbip/src/usbip_port.c                   |  57 ++
 tools/usb/usbip/src/usbip_unbind.c                 | 141 +++++
 tools/usb/usbip/src/usbipd.c                       | 675 +++++++++++++++++++++
 tools/usb/usbip/src/utils.c                        |  52 ++
 tools/usb/usbip/src/utils.h                        |  25 +
 74 files changed, 5617 insertions(+), 5617 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/.gitignore
 delete mode 100644 drivers/staging/usbip/userspace/AUTHORS
 delete mode 100644 drivers/staging/usbip/userspace/COPYING
 delete mode 100644 drivers/staging/usbip/userspace/INSTALL
 delete mode 100644 drivers/staging/usbip/userspace/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/README
 delete mode 100755 drivers/staging/usbip/userspace/autogen.sh
 delete mode 100755 drivers/staging/usbip/userspace/cleanup.sh
 delete mode 100644 drivers/staging/usbip/userspace/configure.ac
 delete mode 100644 drivers/staging/usbip/userspace/doc/usbip.8
 delete mode 100644 drivers/staging/usbip/userspace/doc/usbipd.8
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/list.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/names.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/names.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/src/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip.h
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_attach.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_bind.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_detach.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_list.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_network.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_network.h
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_port.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbip_unbind.c
 delete mode 100644 drivers/staging/usbip/userspace/src/usbipd.c
 delete mode 100644 drivers/staging/usbip/userspace/src/utils.c
 delete mode 100644 drivers/staging/usbip/userspace/src/utils.h
 create mode 100644 tools/usb/usbip/.gitignore
 create mode 100644 tools/usb/usbip/AUTHORS
 create mode 100644 tools/usb/usbip/COPYING
 create mode 100644 tools/usb/usbip/INSTALL
 create mode 100644 tools/usb/usbip/Makefile.am
 create mode 100644 tools/usb/usbip/README
 create mode 100755 tools/usb/usbip/autogen.sh
 create mode 100755 tools/usb/usbip/cleanup.sh
 create mode 100644 tools/usb/usbip/configure.ac
 create mode 100644 tools/usb/usbip/doc/usbip.8
 create mode 100644 tools/usb/usbip/doc/usbipd.8
 create mode 100644 tools/usb/usbip/libsrc/Makefile.am
 create mode 100644 tools/usb/usbip/libsrc/list.h
 create mode 100644 tools/usb/usbip/libsrc/names.c
 create mode 100644 tools/usb/usbip/libsrc/names.h
 create mode 100644 tools/usb/usbip/libsrc/sysfs_utils.c
 create mode 100644 tools/usb/usbip/libsrc/sysfs_utils.h
 create mode 100644 tools/usb/usbip/libsrc/usbip_common.c
 create mode 100644 tools/usb/usbip/libsrc/usbip_common.h
 create mode 100644 tools/usb/usbip/libsrc/usbip_host_driver.c
 create mode 100644 tools/usb/usbip/libsrc/usbip_host_driver.h
 create mode 100644 tools/usb/usbip/libsrc/vhci_driver.c
 create mode 100644 tools/usb/usbip/libsrc/vhci_driver.h
 create mode 100644 tools/usb/usbip/src/Makefile.am
 create mode 100644 tools/usb/usbip/src/usbip.c
 create mode 100644 tools/usb/usbip/src/usbip.h
 create mode 100644 tools/usb/usbip/src/usbip_attach.c
 create mode 100644 tools/usb/usbip/src/usbip_bind.c
 create mode 100644 tools/usb/usbip/src/usbip_detach.c
 create mode 100644 tools/usb/usbip/src/usbip_list.c
 create mode 100644 tools/usb/usbip/src/usbip_network.c
 create mode 100644 tools/usb/usbip/src/usbip_network.h
 create mode 100644 tools/usb/usbip/src/usbip_port.c
 create mode 100644 tools/usb/usbip/src/usbip_unbind.c
 create mode 100644 tools/usb/usbip/src/usbipd.c
 create mode 100644 tools/usb/usbip/src/utils.c
 create mode 100644 tools/usb/usbip/src/utils.h

diff --git a/drivers/staging/usbip/userspace/.gitignore b/drivers/staging/usbip/userspace/.gitignore
deleted file mode 100644
index 9aad9e3..0000000
--- a/drivers/staging/usbip/userspace/.gitignore
+++ /dev/null
@@ -1,28 +0,0 @@
-Makefile
-Makefile.in
-aclocal.m4
-autom4te.cache/
-config.guess
-config.h
-config.h.in
-config.log
-config.status
-config.sub
-configure
-depcomp
-install-sh
-libsrc/Makefile
-libsrc/Makefile.in
-libtool
-ltmain.sh
-missing
-src/Makefile
-src/Makefile.in
-stamp-h1
-libsrc/libusbip.la
-libsrc/libusbip_la-names.lo
-libsrc/libusbip_la-usbip_common.lo
-libsrc/libusbip_la-usbip_host_driver.lo
-libsrc/libusbip_la-vhci_driver.lo
-src/usbip
-src/usbipd
diff --git a/drivers/staging/usbip/userspace/AUTHORS b/drivers/staging/usbip/userspace/AUTHORS
deleted file mode 100644
index a27ea8d..0000000
--- a/drivers/staging/usbip/userspace/AUTHORS
+++ /dev/null
@@ -1,3 +0,0 @@
-Takahiro Hirofuchi
-Robert Leibl
-matt mooney <mfm@muteddisk.com>
diff --git a/drivers/staging/usbip/userspace/COPYING b/drivers/staging/usbip/userspace/COPYING
deleted file mode 100644
index c5611e4..0000000
--- a/drivers/staging/usbip/userspace/COPYING
+++ /dev/null
@@ -1,340 +0,0 @@
-		    GNU GENERAL PUBLIC LICENSE
-		       Version 2, June 1991
-
- Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-     51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
- Everyone is permitted to copy and distribute verbatim copies
- of this license document, but changing it is not allowed.
-
-			    Preamble
-
-  The licenses for most software are designed to take away your
-freedom to share and change it.  By contrast, the GNU General Public
-License is intended to guarantee your freedom to share and change free
-software--to make sure the software is free for all its users.  This
-General Public License applies to most of the Free Software
-Foundation's software and to any other program whose authors commit to
-using it.  (Some other Free Software Foundation software is covered by
-the GNU Library General Public License instead.)  You can apply it to
-your programs, too.
-
-  When we speak of free software, we are referring to freedom, not
-price.  Our General Public Licenses are designed to make sure that you
-have the freedom to distribute copies of free software (and charge for
-this service if you wish), that you receive source code or can get it
-if you want it, that you can change the software or use pieces of it
-in new free programs; and that you know you can do these things.
-
-  To protect your rights, we need to make restrictions that forbid
-anyone to deny you these rights or to ask you to surrender the rights.
-These restrictions translate to certain responsibilities for you if you
-distribute copies of the software, or if you modify it.
-
-  For example, if you distribute copies of such a program, whether
-gratis or for a fee, you must give the recipients all the rights that
-you have.  You must make sure that they, too, receive or can get the
-source code.  And you must show them these terms so they know their
-rights.
-
-  We protect your rights with two steps: (1) copyright the software, and
-(2) offer you this license which gives you legal permission to copy,
-distribute and/or modify the software.
-
-  Also, for each author's protection and ours, we want to make certain
-that everyone understands that there is no warranty for this free
-software.  If the software is modified by someone else and passed on, we
-want its recipients to know that what they have is not the original, so
-that any problems introduced by others will not reflect on the original
-authors' reputations.
-
-  Finally, any free program is threatened constantly by software
-patents.  We wish to avoid the danger that redistributors of a free
-program will individually obtain patent licenses, in effect making the
-program proprietary.  To prevent this, we have made it clear that any
-patent must be licensed for everyone's free use or not licensed at all.
-
-  The precise terms and conditions for copying, distribution and
-modification follow.
-
-		    GNU GENERAL PUBLIC LICENSE
-   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
-
-  0. This License applies to any program or other work which contains
-a notice placed by the copyright holder saying it may be distributed
-under the terms of this General Public License.  The "Program", below,
-refers to any such program or work, and a "work based on the Program"
-means either the Program or any derivative work under copyright law:
-that is to say, a work containing the Program or a portion of it,
-either verbatim or with modifications and/or translated into another
-language.  (Hereinafter, translation is included without limitation in
-the term "modification".)  Each licensee is addressed as "you".
-
-Activities other than copying, distribution and modification are not
-covered by this License; they are outside its scope.  The act of
-running the Program is not restricted, and the output from the Program
-is covered only if its contents constitute a work based on the
-Program (independent of having been made by running the Program).
-Whether that is true depends on what the Program does.
-
-  1. You may copy and distribute verbatim copies of the Program's
-source code as you receive it, in any medium, provided that you
-conspicuously and appropriately publish on each copy an appropriate
-copyright notice and disclaimer of warranty; keep intact all the
-notices that refer to this License and to the absence of any warranty;
-and give any other recipients of the Program a copy of this License
-along with the Program.
-
-You may charge a fee for the physical act of transferring a copy, and
-you may at your option offer warranty protection in exchange for a fee.
-
-  2. You may modify your copy or copies of the Program or any portion
-of it, thus forming a work based on the Program, and copy and
-distribute such modifications or work under the terms of Section 1
-above, provided that you also meet all of these conditions:
-
-    a) You must cause the modified files to carry prominent notices
-    stating that you changed the files and the date of any change.
-
-    b) You must cause any work that you distribute or publish, that in
-    whole or in part contains or is derived from the Program or any
-    part thereof, to be licensed as a whole at no charge to all third
-    parties under the terms of this License.
-
-    c) If the modified program normally reads commands interactively
-    when run, you must cause it, when started running for such
-    interactive use in the most ordinary way, to print or display an
-    announcement including an appropriate copyright notice and a
-    notice that there is no warranty (or else, saying that you provide
-    a warranty) and that users may redistribute the program under
-    these conditions, and telling the user how to view a copy of this
-    License.  (Exception: if the Program itself is interactive but
-    does not normally print such an announcement, your work based on
-    the Program is not required to print an announcement.)
-
-These requirements apply to the modified work as a whole.  If
-identifiable sections of that work are not derived from the Program,
-and can be reasonably considered independent and separate works in
-themselves, then this License, and its terms, do not apply to those
-sections when you distribute them as separate works.  But when you
-distribute the same sections as part of a whole which is a work based
-on the Program, the distribution of the whole must be on the terms of
-this License, whose permissions for other licensees extend to the
-entire whole, and thus to each and every part regardless of who wrote it.
-
-Thus, it is not the intent of this section to claim rights or contest
-your rights to work written entirely by you; rather, the intent is to
-exercise the right to control the distribution of derivative or
-collective works based on the Program.
-
-In addition, mere aggregation of another work not based on the Program
-with the Program (or with a work based on the Program) on a volume of
-a storage or distribution medium does not bring the other work under
-the scope of this License.
-
-  3. You may copy and distribute the Program (or a work based on it,
-under Section 2) in object code or executable form under the terms of
-Sections 1 and 2 above provided that you also do one of the following:
-
-    a) Accompany it with the complete corresponding machine-readable
-    source code, which must be distributed under the terms of Sections
-    1 and 2 above on a medium customarily used for software interchange; or,
-
-    b) Accompany it with a written offer, valid for at least three
-    years, to give any third party, for a charge no more than your
-    cost of physically performing source distribution, a complete
-    machine-readable copy of the corresponding source code, to be
-    distributed under the terms of Sections 1 and 2 above on a medium
-    customarily used for software interchange; or,
-
-    c) Accompany it with the information you received as to the offer
-    to distribute corresponding source code.  (This alternative is
-    allowed only for noncommercial distribution and only if you
-    received the program in object code or executable form with such
-    an offer, in accord with Subsection b above.)
-
-The source code for a work means the preferred form of the work for
-making modifications to it.  For an executable work, complete source
-code means all the source code for all modules it contains, plus any
-associated interface definition files, plus the scripts used to
-control compilation and installation of the executable.  However, as a
-special exception, the source code distributed need not include
-anything that is normally distributed (in either source or binary
-form) with the major components (compiler, kernel, and so on) of the
-operating system on which the executable runs, unless that component
-itself accompanies the executable.
-
-If distribution of executable or object code is made by offering
-access to copy from a designated place, then offering equivalent
-access to copy the source code from the same place counts as
-distribution of the source code, even though third parties are not
-compelled to copy the source along with the object code.
-
-  4. You may not copy, modify, sublicense, or distribute the Program
-except as expressly provided under this License.  Any attempt
-otherwise to copy, modify, sublicense or distribute the Program is
-void, and will automatically terminate your rights under this License.
-However, parties who have received copies, or rights, from you under
-this License will not have their licenses terminated so long as such
-parties remain in full compliance.
-
-  5. You are not required to accept this License, since you have not
-signed it.  However, nothing else grants you permission to modify or
-distribute the Program or its derivative works.  These actions are
-prohibited by law if you do not accept this License.  Therefore, by
-modifying or distributing the Program (or any work based on the
-Program), you indicate your acceptance of this License to do so, and
-all its terms and conditions for copying, distributing or modifying
-the Program or works based on it.
-
-  6. Each time you redistribute the Program (or any work based on the
-Program), the recipient automatically receives a license from the
-original licensor to copy, distribute or modify the Program subject to
-these terms and conditions.  You may not impose any further
-restrictions on the recipients' exercise of the rights granted herein.
-You are not responsible for enforcing compliance by third parties to
-this License.
-
-  7. If, as a consequence of a court judgment or allegation of patent
-infringement or for any other reason (not limited to patent issues),
-conditions are imposed on you (whether by court order, agreement or
-otherwise) that contradict the conditions of this License, they do not
-excuse you from the conditions of this License.  If you cannot
-distribute so as to satisfy simultaneously your obligations under this
-License and any other pertinent obligations, then as a consequence you
-may not distribute the Program at all.  For example, if a patent
-license would not permit royalty-free redistribution of the Program by
-all those who receive copies directly or indirectly through you, then
-the only way you could satisfy both it and this License would be to
-refrain entirely from distribution of the Program.
-
-If any portion of this section is held invalid or unenforceable under
-any particular circumstance, the balance of the section is intended to
-apply and the section as a whole is intended to apply in other
-circumstances.
-
-It is not the purpose of this section to induce you to infringe any
-patents or other property right claims or to contest validity of any
-such claims; this section has the sole purpose of protecting the
-integrity of the free software distribution system, which is
-implemented by public license practices.  Many people have made
-generous contributions to the wide range of software distributed
-through that system in reliance on consistent application of that
-system; it is up to the author/donor to decide if he or she is willing
-to distribute software through any other system and a licensee cannot
-impose that choice.
-
-This section is intended to make thoroughly clear what is believed to
-be a consequence of the rest of this License.
-
-  8. If the distribution and/or use of the Program is restricted in
-certain countries either by patents or by copyrighted interfaces, the
-original copyright holder who places the Program under this License
-may add an explicit geographical distribution limitation excluding
-those countries, so that distribution is permitted only in or among
-countries not thus excluded.  In such case, this License incorporates
-the limitation as if written in the body of this License.
-
-  9. The Free Software Foundation may publish revised and/or new versions
-of the General Public License from time to time.  Such new versions will
-be similar in spirit to the present version, but may differ in detail to
-address new problems or concerns.
-
-Each version is given a distinguishing version number.  If the Program
-specifies a version number of this License which applies to it and "any
-later version", you have the option of following the terms and conditions
-either of that version or of any later version published by the Free
-Software Foundation.  If the Program does not specify a version number of
-this License, you may choose any version ever published by the Free Software
-Foundation.
-
-  10. If you wish to incorporate parts of the Program into other free
-programs whose distribution conditions are different, write to the author
-to ask for permission.  For software which is copyrighted by the Free
-Software Foundation, write to the Free Software Foundation; we sometimes
-make exceptions for this.  Our decision will be guided by the two goals
-of preserving the free status of all derivatives of our free software and
-of promoting the sharing and reuse of software generally.
-
-			    NO WARRANTY
-
-  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
-FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
-OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
-PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
-OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
-MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
-TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
-PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
-REPAIR OR CORRECTION.
-
-  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
-WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
-REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
-INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
-OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
-TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
-YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
-PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
-POSSIBILITY OF SUCH DAMAGES.
-
-		     END OF TERMS AND CONDITIONS
-
-	    How to Apply These Terms to Your New Programs
-
-  If you develop a new program, and you want it to be of the greatest
-possible use to the public, the best way to achieve this is to make it
-free software which everyone can redistribute and change under these terms.
-
-  To do so, attach the following notices to the program.  It is safest
-to attach them to the start of each source file to most effectively
-convey the exclusion of warranty; and each file should have at least
-the "copyright" line and a pointer to where the full notice is found.
-
-    <one line to give the program's name and a brief idea of what it does.>
-    Copyright (C) <year>  <name of author>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
-
-
-Also add information on how to contact you by electronic and paper mail.
-
-If the program is interactive, make it output a short notice like this
-when it starts in an interactive mode:
-
-    Gnomovision version 69, Copyright (C) year  name of author
-    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
-    This is free software, and you are welcome to redistribute it
-    under certain conditions; type `show c' for details.
-
-The hypothetical commands `show w' and `show c' should show the appropriate
-parts of the General Public License.  Of course, the commands you use may
-be called something other than `show w' and `show c'; they could even be
-mouse-clicks or menu items--whatever suits your program.
-
-You should also get your employer (if you work as a programmer) or your
-school, if any, to sign a "copyright disclaimer" for the program, if
-necessary.  Here is a sample; alter the names:
-
-  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
-  `Gnomovision' (which makes passes at compilers) written by James Hacker.
-
-  <signature of Ty Coon>, 1 April 1989
-  Ty Coon, President of Vice
-
-This General Public License does not permit incorporating your program into
-proprietary programs.  If your program is a subroutine library, you may
-consider it more useful to permit linking proprietary applications with the
-library.  If this is what you want to do, use the GNU Library General
-Public License instead of this License.
diff --git a/drivers/staging/usbip/userspace/INSTALL b/drivers/staging/usbip/userspace/INSTALL
deleted file mode 100644
index d3c5b40..0000000
--- a/drivers/staging/usbip/userspace/INSTALL
+++ /dev/null
@@ -1,237 +0,0 @@
-Installation Instructions
-*************************
-
-Copyright (C) 1994, 1995, 1996, 1999, 2000, 2001, 2002, 2004, 2005,
-2006, 2007 Free Software Foundation, Inc.
-
-This file is free documentation; the Free Software Foundation gives
-unlimited permission to copy, distribute and modify it.
-
-Basic Installation
-==================
-
-Briefly, the shell commands `./configure; make; make install' should
-configure, build, and install this package.  The following
-more-detailed instructions are generic; see the `README' file for
-instructions specific to this package.
-
-   The `configure' shell script attempts to guess correct values for
-various system-dependent variables used during compilation.  It uses
-those values to create a `Makefile' in each directory of the package.
-It may also create one or more `.h' files containing system-dependent
-definitions.  Finally, it creates a shell script `config.status' that
-you can run in the future to recreate the current configuration, and a
-file `config.log' containing compiler output (useful mainly for
-debugging `configure').
-
-   It can also use an optional file (typically called `config.cache'
-and enabled with `--cache-file=config.cache' or simply `-C') that saves
-the results of its tests to speed up reconfiguring.  Caching is
-disabled by default to prevent problems with accidental use of stale
-cache files.
-
-   If you need to do unusual things to compile the package, please try
-to figure out how `configure' could check whether to do them, and mail
-diffs or instructions to the address given in the `README' so they can
-be considered for the next release.  If you are using the cache, and at
-some point `config.cache' contains results you don't want to keep, you
-may remove or edit it.
-
-   The file `configure.ac' (or `configure.in') is used to create
-`configure' by a program called `autoconf'.  You need `configure.ac' if
-you want to change it or regenerate `configure' using a newer version
-of `autoconf'.
-
-The simplest way to compile this package is:
-
-  1. `cd' to the directory containing the package's source code and type
-     `./configure' to configure the package for your system.
-
-     Running `configure' might take a while.  While running, it prints
-     some messages telling which features it is checking for.
-
-  2. Type `make' to compile the package.
-
-  3. Optionally, type `make check' to run any self-tests that come with
-     the package.
-
-  4. Type `make install' to install the programs and any data files and
-     documentation.
-
-  5. You can remove the program binaries and object files from the
-     source code directory by typing `make clean'.  To also remove the
-     files that `configure' created (so you can compile the package for
-     a different kind of computer), type `make distclean'.  There is
-     also a `make maintainer-clean' target, but that is intended mainly
-     for the package's developers.  If you use it, you may have to get
-     all sorts of other programs in order to regenerate files that came
-     with the distribution.
-
-  6. Often, you can also type `make uninstall' to remove the installed
-     files again.
-
-Compilers and Options
-=====================
-
-Some systems require unusual options for compilation or linking that the
-`configure' script does not know about.  Run `./configure --help' for
-details on some of the pertinent environment variables.
-
-   You can give `configure' initial values for configuration parameters
-by setting variables in the command line or in the environment.  Here
-is an example:
-
-     ./configure CC=c99 CFLAGS=-g LIBS=-lposix
-
-   *Note Defining Variables::, for more details.
-
-Compiling For Multiple Architectures
-====================================
-
-You can compile the package for more than one kind of computer at the
-same time, by placing the object files for each architecture in their
-own directory.  To do this, you can use GNU `make'.  `cd' to the
-directory where you want the object files and executables to go and run
-the `configure' script.  `configure' automatically checks for the
-source code in the directory that `configure' is in and in `..'.
-
-   With a non-GNU `make', it is safer to compile the package for one
-architecture at a time in the source code directory.  After you have
-installed the package for one architecture, use `make distclean' before
-reconfiguring for another architecture.
-
-Installation Names
-==================
-
-By default, `make install' installs the package's commands under
-`/usr/local/bin', include files under `/usr/local/include', etc.  You
-can specify an installation prefix other than `/usr/local' by giving
-`configure' the option `--prefix=PREFIX'.
-
-   You can specify separate installation prefixes for
-architecture-specific files and architecture-independent files.  If you
-pass the option `--exec-prefix=PREFIX' to `configure', the package uses
-PREFIX as the prefix for installing programs and libraries.
-Documentation and other data files still use the regular prefix.
-
-   In addition, if you use an unusual directory layout you can give
-options like `--bindir=DIR' to specify different values for particular
-kinds of files.  Run `configure --help' for a list of the directories
-you can set and what kinds of files go in them.
-
-   If the package supports it, you can cause programs to be installed
-with an extra prefix or suffix on their names by giving `configure' the
-option `--program-prefix=PREFIX' or `--program-suffix=SUFFIX'.
-
-Optional Features
-=================
-
-Some packages pay attention to `--enable-FEATURE' options to
-`configure', where FEATURE indicates an optional part of the package.
-They may also pay attention to `--with-PACKAGE' options, where PACKAGE
-is something like `gnu-as' or `x' (for the X Window System).  The
-`README' should mention any `--enable-' and `--with-' options that the
-package recognizes.
-
-   For packages that use the X Window System, `configure' can usually
-find the X include and library files automatically, but if it doesn't,
-you can use the `configure' options `--x-includes=DIR' and
-`--x-libraries=DIR' to specify their locations.
-
-Specifying the System Type
-==========================
-
-There may be some features `configure' cannot figure out automatically,
-but needs to determine by the type of machine the package will run on.
-Usually, assuming the package is built to be run on the _same_
-architectures, `configure' can figure that out, but if it prints a
-message saying it cannot guess the machine type, give it the
-`--build=TYPE' option.  TYPE can either be a short name for the system
-type, such as `sun4', or a canonical name which has the form:
-
-     CPU-COMPANY-SYSTEM
-
-where SYSTEM can have one of these forms:
-
-     OS KERNEL-OS
-
-   See the file `config.sub' for the possible values of each field.  If
-`config.sub' isn't included in this package, then this package doesn't
-need to know the machine type.
-
-   If you are _building_ compiler tools for cross-compiling, you should
-use the option `--target=TYPE' to select the type of system they will
-produce code for.
-
-   If you want to _use_ a cross compiler, that generates code for a
-platform different from the build platform, you should specify the
-"host" platform (i.e., that on which the generated programs will
-eventually be run) with `--host=TYPE'.
-
-Sharing Defaults
-================
-
-If you want to set default values for `configure' scripts to share, you
-can create a site shell script called `config.site' that gives default
-values for variables like `CC', `cache_file', and `prefix'.
-`configure' looks for `PREFIX/share/config.site' if it exists, then
-`PREFIX/etc/config.site' if it exists.  Or, you can set the
-`CONFIG_SITE' environment variable to the location of the site script.
-A warning: not all `configure' scripts look for a site script.
-
-Defining Variables
-==================
-
-Variables not defined in a site shell script can be set in the
-environment passed to `configure'.  However, some packages may run
-configure again during the build, and the customized values of these
-variables may be lost.  In order to avoid this problem, you should set
-them in the `configure' command line, using `VAR=value'.  For example:
-
-     ./configure CC=/usr/local2/bin/gcc
-
-causes the specified `gcc' to be used as the C compiler (unless it is
-overridden in the site shell script).
-
-Unfortunately, this technique does not work for `CONFIG_SHELL' due to
-an Autoconf bug.  Until the bug is fixed you can use this workaround:
-
-     CONFIG_SHELL=/bin/bash /bin/bash ./configure CONFIG_SHELL=/bin/bash
-
-`configure' Invocation
-======================
-
-`configure' recognizes the following options to control how it operates.
-
-`--help'
-`-h'
-     Print a summary of the options to `configure', and exit.
-
-`--version'
-`-V'
-     Print the version of Autoconf used to generate the `configure'
-     script, and exit.
-
-`--cache-file=FILE'
-     Enable the cache: use and save the results of the tests in FILE,
-     traditionally `config.cache'.  FILE defaults to `/dev/null' to
-     disable caching.
-
-`--config-cache'
-`-C'
-     Alias for `--cache-file=config.cache'.
-
-`--quiet'
-`--silent'
-`-q'
-     Do not print messages saying which checks are being made.  To
-     suppress all normal output, redirect it to `/dev/null' (any error
-     messages will still be shown).
-
-`--srcdir=DIR'
-     Look for the package's source code in directory DIR.  Usually
-     `configure' can determine that directory automatically.
-
-`configure' also accepts some other, not widely useful, options.  Run
-`configure --help' for more details.
-
diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
deleted file mode 100644
index 66f8bf0..0000000
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ /dev/null
@@ -1,6 +0,0 @@
-SUBDIRS := libsrc src
-includedir = @includedir@/usbip
-include_HEADERS := $(addprefix libsrc/, \
-		     usbip_common.h vhci_driver.h usbip_host_driver.h)
-
-dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8)
diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
deleted file mode 100644
index f528ba4..0000000
--- a/drivers/staging/usbip/userspace/README
+++ /dev/null
@@ -1,203 +0,0 @@
-#
-# README for usbip-utils
-#
-# Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
-#               2005-2008 Takahiro Hirofuchi
-
-
-[Requirements]
-    - USB/IP device drivers
-	Found in the staging directory of the Linux kernel.
-
-    - libudev >= 2.0
-	libudev library
-
-    - libwrap0-dev
-	tcp wrapper library
-
-    - gcc >= 4.0
-
-    - libtool, automake >= 1.9, autoconf >= 2.5.0, pkg-config
-
-[Optional]
-    - hwdata
-        Contains USB device identification data.
-
-
-[Install]
-    0. Generate configuration scripts.
-	$ ./autogen.sh
-
-    1. Compile & install the userspace utilities.
-	$ ./configure [--with-tcp-wrappers=no] [--with-usbids-dir=<dir>]
-	$ make install
-
-    2. Compile & install USB/IP drivers.
-
-
-[Usage]
-    server:# (Physically attach your USB device.)
-
-    server:# insmod usbip-core.ko
-    server:# insmod usbip-host.ko
-
-    server:# usbipd -D
-	- Start usbip daemon.
-
-    server:# usbip list -l
-	- List driver assignments for USB devices.
-
-    server:# usbip bind --busid 1-2
-	- Bind usbip-host.ko to the device with busid 1-2.
-	- The USB device 1-2 is now exportable to other hosts!
-	- Use `usbip unbind --busid 1-2' to stop exporting the device.
-
-    client:# insmod usbip-core.ko
-    client:# insmod vhci-hcd.ko
-
-    client:# usbip list --remote <host>
-	- List exported USB devices on the <host>.
-
-    client:# usbip attach --remote <host> --busid 1-2
-	- Connect the remote USB device.
-
-    client:# usbip port
-	- Show virtual port status.
-
-    client:# usbip detach --port <port>
-	- Detach the USB device.
-
-
-[Example]
----------------------------
-	SERVER SIDE
----------------------------
-Physically attach your USB devices to this host.
-
-    trois:# insmod path/to/usbip-core.ko
-    trois:# insmod path/to/usbip-host.ko
-    trois:# usbipd -D
-
-In another terminal, let's look up what USB devices are physically
-attached to this host.
-
-    trois:# usbip list -l
-    Local USB devices
-    =================
-     - busid 1-1 (05a9:a511)
-	     1-1:1.0 -> ov511
-
-     - busid 3-2 (0711:0902)
-	     3-2:1.0 -> none
-
-     - busid 3-3.1 (08bb:2702)
-	     3-3.1:1.0 -> snd-usb-audio
-	     3-3.1:1.1 -> snd-usb-audio
-
-     - busid 3-3.2 (04bb:0206)
-	     3-3.2:1.0 -> usb-storage
-
-     - busid 3-3 (0409:0058)
-	     3-3:1.0 -> hub
-
-     - busid 4-1 (046d:08b2)
-	     4-1:1.0 -> none
-	     4-1:1.1 -> none
-	     4-1:1.2 -> none
-
-     - busid 5-2 (058f:9254)
-	     5-2:1.0 -> hub
-
-A USB storage device of busid 3-3.2 is now bound to the usb-storage
-driver. To export this device, we first mark the device as
-"exportable"; the device is bound to the usbip-host driver. Please
-remember you can not export a USB hub.
-
-Mark the device of busid 3-3.2 as exportable:
-
-    trois:# usbip --debug bind --busid 3-3.2
-    ...
-    usbip debug: usbip_bind.c:162:[unbind_other] 3-3.2:1.0 -> usb-storage
-    ...
-    bind device on busid 3-3.2: complete
-
-    trois:# usbip list -l
-    Local USB devices
-    =================
-    ...
-
-     - busid 3-3.2 (04bb:0206)
-	     3-3.2:1.0 -> usbip-host
-    ...
-
----------------------------
-	CLIENT SIDE
----------------------------
-First, let's list available remote devices that are marked as
-exportable on the host.
-
-    deux:# insmod path/to/usbip-core.ko
-    deux:# insmod path/to/vhci-hcd.ko
-
-    deux:# usbip list --remote 10.0.0.3
-    Exportable USB devices
-    ======================
-     - 10.0.0.3
-	    1-1: Prolific Technology, Inc. : unknown product (067b:3507)
-	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
-	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	       :  0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
-
-	1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
-	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
-	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	       :  0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
-
-	1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
-	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
-	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	       :  0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
-
-	    3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
-	       : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
-	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
-	       :  0 - Data / unknown subclass / unknown protocol (0a/ff/00)
-	       :  1 - Audio / Control Device / unknown protocol (01/01/00)
-	       :  2 - Audio / Streaming / unknown protocol (01/02/00)
-
-Attach a remote USB device:
-
-    deux:# usbip attach --remote 10.0.0.3 --busid 1-1
-    port 0 attached
-
-Show the devices attached to this client:
-
-    deux:# usbip port
-    Port 00: <Port in Use> at Full Speed(12Mbps)
-	   Prolific Technology, Inc. : unknown product (067b:3507)
-	   6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
-	   6-1:1.0 used by usb-storage
-			  /sys/class/scsi_device/0:0:0:0/device
-			  /sys/class/scsi_host/host0/device
-			  /sys/block/sda/device
-
-Detach the imported device:
-
-    deux:# usbip detach --port 0
-    port 0 detached
-
-
-[Checklist]
-    - See 'Debug Tips' on the project wiki.
-	- http://usbip.wiki.sourceforge.net/how-to-debug-usbip
-    - usbip-host.ko must be bound to the target device.
-	- See /proc/bus/usb/devices and find "Driver=..." lines of the device.
-    - Shutdown firewall.
-	- usbip now uses TCP port 3240.
-    - Disable SELinux.
-    - If possible, compile your kernel with CONFIG_USB_DEBUG flag and try again.
-    - Check the kernel and daemon messages.
-
-
-[Contact]
-    Mailing List: linux-usb@vger.kernel.org
diff --git a/drivers/staging/usbip/userspace/autogen.sh b/drivers/staging/usbip/userspace/autogen.sh
deleted file mode 100755
index e1112d3..0000000
--- a/drivers/staging/usbip/userspace/autogen.sh
+++ /dev/null
@@ -1,9 +0,0 @@
-#!/bin/sh -x
-
-#aclocal
-#autoheader
-#libtoolize --copy --force
-#automake-1.9 -acf
-#autoconf
-
-autoreconf -i -f -v
diff --git a/drivers/staging/usbip/userspace/cleanup.sh b/drivers/staging/usbip/userspace/cleanup.sh
deleted file mode 100755
index 955c3cc..0000000
--- a/drivers/staging/usbip/userspace/cleanup.sh
+++ /dev/null
@@ -1,12 +0,0 @@
-#!/bin/sh
-
-if [ -r Makefile ]; then
-	make distclean
-fi
-
-FILES="aclocal.m4 autom4te.cache compile config.guess config.h.in config.log \
-       config.status config.sub configure cscope.out depcomp install-sh      \
-       libsrc/Makefile libsrc/Makefile.in libtool ltmain.sh Makefile         \
-       Makefile.in missing src/Makefile src/Makefile.in"
-
-rm -vRf $FILES
diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
deleted file mode 100644
index 607d05c..0000000
--- a/drivers/staging/usbip/userspace/configure.ac
+++ /dev/null
@@ -1,111 +0,0 @@
-dnl Process this file with autoconf to produce a configure script.
-
-AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
-AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
-
-CURRENT=0
-REVISION=1
-AGE=0
-AC_SUBST([LIBUSBIP_VERSION], [$CURRENT:$REVISION:$AGE], [library version])
-
-AC_CONFIG_SRCDIR([src/usbipd.c])
-AC_CONFIG_HEADERS([config.h])
-
-AM_INIT_AUTOMAKE([foreign])
-LT_INIT
-
-# Silent build for automake >= 1.11
-m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-
-AC_SUBST([EXTRA_CFLAGS], ["-Wall -Werror -Wextra -std=gnu99"])
-
-# Checks for programs.
-AC_PROG_CC
-AC_PROG_INSTALL
-AC_PROG_MAKE_SET
-
-# Checks for header files.
-AC_HEADER_DIRENT
-AC_HEADER_STDC
-AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h netinet/in.h stdint.h stdlib.h dnl
-		  string.h sys/socket.h syslog.h unistd.h])
-
-# Checks for typedefs, structures, and compiler characteristics.
-AC_TYPE_INT32_T
-AC_TYPE_SIZE_T
-AC_TYPE_SSIZE_T
-AC_TYPE_UINT16_T
-AC_TYPE_UINT32_T
-AC_TYPE_UINT8_T
-
-# Checks for library functions.
-AC_FUNC_REALLOC
-AC_CHECK_FUNCS([memset mkdir regcomp socket strchr strerror strstr dnl
-		strtoul])
-
-AC_CHECK_HEADER([libudev.h],
-		[AC_CHECK_LIB([udev], [udev_new],
-			      [LIBS="$LIBS -ludev"],
-			      [AC_MSG_ERROR([Missing udev library!])])],
-		[AC_MSG_ERROR([Missing /usr/include/libudev.h])])
-
-# Checks for libwrap library.
-AC_MSG_CHECKING([whether to use the libwrap (TCP wrappers) library])
-AC_ARG_WITH([tcp-wrappers],
-	    [AS_HELP_STRING([--with-tcp-wrappers],
-			    [use the libwrap (TCP wrappers) library])],
-	    dnl [ACTION-IF-GIVEN]
-	    [if test "$withval" = "yes"; then
-		     AC_MSG_RESULT([yes])
-		     AC_MSG_CHECKING([for hosts_access in -lwrap])
-		     saved_LIBS="$LIBS"
-		     LIBS="-lwrap $saved_LIBS"
-		     AC_TRY_LINK(
-		       [int hosts_access(); int allow_severity, deny_severity;],
-		       [hosts_access()],
-		       [AC_MSG_RESULT([yes]);
-			AC_DEFINE([HAVE_LIBWRAP], [1],
-				  [use tcp wrapper]) wrap_LIB="-lwrap"],
-		       [AC_MSG_RESULT([not found]); exit 1])
-	     else
-		     AC_MSG_RESULT([no]);
-	     fi],
-	    dnl [ACTION-IF-NOT-GIVEN]
-	    [AC_MSG_RESULT([(default)])
-	     AC_MSG_CHECKING([for hosts_access in -lwrap])
-	     saved_LIBS="$LIBS"
-	     LIBS="-lwrap $saved_LIBS"
-	     AC_TRY_LINK(
-	       [int hosts_access(); int allow_severity, deny_severity;],
-	       [hosts_access()],
-	       [AC_MSG_RESULT([yes]);
-		AC_DEFINE([HAVE_LIBWRAP], [1], [use tcp wrapper])],
-	       [AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])])
-
-# Sets directory containing usb.ids.
-AC_ARG_WITH([usbids-dir],
-	    [AS_HELP_STRING([--with-usbids-dir=DIR],
-	       [where usb.ids is found (default /usr/share/hwdata/)])],
-	    [USBIDS_DIR=$withval], [USBIDS_DIR="/usr/share/hwdata/"])
-AC_SUBST([USBIDS_DIR])
-
-# use _FORTIFY_SOURCE
-AC_MSG_CHECKING([whether to use fortify])
-AC_ARG_WITH([fortify],
-	    [AS_HELP_STRING([--with-fortify],
-			    [use _FORTIFY_SROUCE option when compiling)])],
-			    dnl [ACTION-IF-GIVEN]
-			    [if test "$withval" = "yes"; then
-				AC_MSG_RESULT([yes])
-				CFLAGS="$CFLAGS -D_FORTIFY_SOURCE -O"
-			     else
-			     	AC_MSG_RESULT([no])
-				CFLAGS="$CFLAGS -U_FORTIFY_SOURCE"
-			     fi
-			    ],
-			    dnl [ACTION-IF-NOT-GIVEN]
-			    [AC_MSG_RESULT([default])])
-
-AC_CONFIG_FILES([Makefile libsrc/Makefile src/Makefile])
-AC_OUTPUT
diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/drivers/staging/usbip/userspace/doc/usbip.8
deleted file mode 100644
index a6097be..0000000
--- a/drivers/staging/usbip/userspace/doc/usbip.8
+++ /dev/null
@@ -1,95 +0,0 @@
-.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
-.SH NAME
-usbip \- manage USB/IP devices
-.SH SYNOPSIS
-.B usbip
-[\fIoptions\fR] <\fIcommand\fR> <\fIargs\fR>
-
-.SH DESCRIPTION
-On a USB/IP server, devices can be listed, bound, and unbound using
-this program.  On a USB/IP client, devices exported by USB/IP servers
-can be listed, attached and detached.
-
-.SH OPTIONS
-.HP
-\fB\-\-debug\fR
-.IP
-Print debugging information.
-.PP
-
-.HP
-\fB\-\-log\fR
-.IP
-Log to syslog.
-.PP
-
-.HP
-\fB\-\-tcp-port PORT\fR
-.IP
-Connect to PORT on remote host (used for attach and list --remote).
-.PP
-
-.SH COMMANDS
-.HP
-\fBversion\fR
-.IP
-Show version and exit.
-.PP
-
-.HP
-\fBhelp\fR [\fIcommand\fR]
-.IP
-Print the program help message, or help on a specific command, and
-then exit.
-.PP
-
-.HP
-\fBattach\fR \-\-remote=<\fIhost\fR> \-\-busid=<\fIbus_id\fR>
-.IP
-Attach a remote USB device.
-.PP
-
-.HP
-\fBdetach\fR \-\-port=<\fIport\fR>
-.IP
-Detach an imported USB device.
-.PP
-
-.HP
-\fBbind\fR \-\-busid=<\fIbusid\fR>
-.IP
-Make a device exportable.
-.PP
-
-.HP
-\fBunbind\fR \-\-busid=<\fIbusid\fR>
-.IP
-Stop exporting a device so it can be used by a local driver.
-.PP
-
-.HP
-\fBlist\fR \-\-remote=<\fIhost\fR>
-.IP
-List USB devices exported by a remote host.
-.PP
-
-.HP
-\fBlist\fR \-\-local
-.IP
-List local USB devices.
-.PP
-
-
-.SH EXAMPLES
-
-    client:# usbip list --remote=server
-        - List exportable usb devices on the server.
-
-    client:# usbip attach --remote=server --busid=1-2
-        - Connect the remote USB device.
-
-    client:# usbip detach --port=0
-        - Detach the usb device.
-
-.SH "SEE ALSO"
-\fBusbipd\fP\fB(8)\fB\fP
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/drivers/staging/usbip/userspace/doc/usbipd.8
deleted file mode 100644
index ac4635d..0000000
--- a/drivers/staging/usbip/userspace/doc/usbipd.8
+++ /dev/null
@@ -1,91 +0,0 @@
-.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
-.SH NAME
-usbipd \- USB/IP server daemon
-.SH SYNOPSIS
-.B usbipd
-[\fIoptions\fR]
-
-.SH DESCRIPTION
-.B usbipd
-provides USB/IP clients access to exported USB devices.
-
-Devices have to explicitly be exported using
-.B usbip bind
-before usbipd makes them available to other hosts.
-
-The daemon accepts connections from USB/IP clients
-on TCP port 3240 by default.
-
-.SH OPTIONS
-.HP
-\fB\-4\fR, \fB\-\-ipv4\fR
-.IP
-Bind to IPv4. Default is both.
-.PP
-
-.HP
-\fB\-6\fR, \fB\-\-ipv6\fR
-.IP
-Bind to IPv6. Default is both.
-.PP
-
-.HP
-\fB\-D\fR, \fB\-\-daemon\fR
-.IP
-Run as a daemon process.
-.PP
-
-.HP
-\fB\-d\fR, \fB\-\-debug\fR
-.IP
-Print debugging information.
-.PP
-
-.HP
-\fB\-PFILE\fR, \fB\-\-pid FILE\fR
-.IP
-Write process id to FILE.
-.br
-If no FILE specified, use /var/run/usbipd.pid
-.PP
-
-\fB\-tPORT\fR, \fB\-\-tcp\-port PORT\fR
-.IP
-Listen on TCP/IP port PORT.
-.PP
-
-\fB\-h\fR, \fB\-\-help\fR
-.IP
-Print the program help message and exit.
-.PP
-
-.HP
-\fB\-v\fR, \fB\-\-version\fR
-.IP
-Show version.
-.PP
-
-.SH LIMITATIONS
-
-.B usbipd
-offers no authentication or authorization for USB/IP. Any
-USB/IP client can connect and use exported devices.
-
-.SH EXAMPLES
-
-    server:# modprobe usbip
-
-    server:# usbipd -D
-        - Start usbip daemon.
-
-    server:# usbip list --local
-        - List driver assignments for usb devices.
-
-    server:# usbip bind --busid=1-2
-        - Bind usbip-host.ko to the device of busid 1-2.
-        - A usb device 1-2 is now exportable to other hosts!
-        - Use 'usbip unbind --busid=1-2' when you want to shutdown exporting and use the device locally.
-
-.SH "SEE ALSO"
-\fBusbip\fP\fB(8)\fB\fP
-
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
deleted file mode 100644
index 7c8f8a4..0000000
--- a/drivers/staging/usbip/userspace/libsrc/Makefile.am
+++ /dev/null
@@ -1,8 +0,0 @@
-libusbip_la_CPPFLAGS = -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-libusbip_la_CFLAGS   = @EXTRA_CFLAGS@
-libusbip_la_LDFLAGS  = -version-info @LIBUSBIP_VERSION@
-
-lib_LTLIBRARIES := libusbip.la
-libusbip_la_SOURCES := names.c names.h usbip_host_driver.c usbip_host_driver.h \
-		       usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h \
-		       sysfs_utils.c sysfs_utils.h
diff --git a/drivers/staging/usbip/userspace/libsrc/list.h b/drivers/staging/usbip/userspace/libsrc/list.h
deleted file mode 100644
index 8d0c936..0000000
--- a/drivers/staging/usbip/userspace/libsrc/list.h
+++ /dev/null
@@ -1,136 +0,0 @@
-#ifndef _LIST_H
-#define _LIST_H
-
-/* Stripped down implementation of linked list taken
- * from the Linux Kernel.
- */
-
-/*
- * Simple doubly linked list implementation.
- *
- * Some of the internal functions ("__xxx") are useful when
- * manipulating whole lists rather than single entries, as
- * sometimes we already know the next/prev entries and we can
- * generate better code by using them directly rather than
- * using the generic single-entry routines.
- */
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
-
-#define LIST_HEAD(name) \
-	struct list_head name = LIST_HEAD_INIT(name)
-
-static inline void INIT_LIST_HEAD(struct list_head *list)
-{
-	list->next = list;
-	list->prev = list;
-}
-
-/*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
-{
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
-}
-
-/**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-static inline void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-
-/*
- * Delete a list entry by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-#define POISON_POINTER_DELTA 0
-#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
-#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
-
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty() on entry does not return true after this, the entry is
- * in an undefined state.
- */
-static inline void __list_del_entry(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-}
-
-static inline void list_del(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
-}
-
-/**
- * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_entry(ptr, type, member) \
-	container_of(ptr, type, member)
-/**
- * list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- */
-#define list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
- * list_for_each_safe - iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
-
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
-#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
deleted file mode 100644
index 81ff852..0000000
--- a/drivers/staging/usbip/userspace/libsrc/names.c
+++ /dev/null
@@ -1,504 +0,0 @@
-/*
- *      names.c  --  USB name database manipulation routines
- *
- *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
- *
- *      This program is free software; you can redistribute it and/or modify
- *      it under the terms of the GNU General Public License as published by
- *      the Free Software Foundation; either version 2 of the License, or
- *      (at your option) any later version.
- *
- *      This program is distributed in the hope that it will be useful,
- *      but WITHOUT ANY WARRANTY; without even the implied warranty of
- *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *      GNU General Public License for more details.
- *
- *      You should have received a copy of the GNU General Public License
- *      along with this program; if not, write to the Free Software
- *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
- *
- *
- *
- *	Copyright (C) 2005 Takahiro Hirofuchi
- *		- names_deinit() is added.
- *
- */
-
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <dirent.h>
-#include <string.h>
-#include <errno.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <stdio.h>
-#include <ctype.h>
-
-#include "names.h"
-#include "usbip_common.h"
-
-struct vendor {
-	struct vendor *next;
-	u_int16_t vendorid;
-	char name[1];
-};
-
-struct product {
-	struct product *next;
-	u_int16_t vendorid, productid;
-	char name[1];
-};
-
-struct class {
-	struct class *next;
-	u_int8_t classid;
-	char name[1];
-};
-
-struct subclass {
-	struct subclass *next;
-	u_int8_t classid, subclassid;
-	char name[1];
-};
-
-struct protocol {
-	struct protocol *next;
-	u_int8_t classid, subclassid, protocolid;
-	char name[1];
-};
-
-struct genericstrtable {
-	struct genericstrtable *next;
-	unsigned int num;
-	char name[1];
-};
-
-
-#define HASH1  0x10
-#define HASH2  0x02
-#define HASHSZ 16
-
-static unsigned int hashnum(unsigned int num)
-{
-	unsigned int mask1 = HASH1 << 27, mask2 = HASH2 << 27;
-
-	for (; mask1 >= HASH1; mask1 >>= 1, mask2 >>= 1)
-		if (num & mask1)
-			num ^= mask2;
-	return num & (HASHSZ-1);
-}
-
-
-static struct vendor *vendors[HASHSZ] = { NULL, };
-static struct product *products[HASHSZ] = { NULL, };
-static struct class *classes[HASHSZ] = { NULL, };
-static struct subclass *subclasses[HASHSZ] = { NULL, };
-static struct protocol *protocols[HASHSZ] = { NULL, };
-
-const char *names_vendor(u_int16_t vendorid)
-{
-	struct vendor *v;
-
-	v = vendors[hashnum(vendorid)];
-	for (; v; v = v->next)
-		if (v->vendorid == vendorid)
-			return v->name;
-	return NULL;
-}
-
-const char *names_product(u_int16_t vendorid, u_int16_t productid)
-{
-	struct product *p;
-
-	p = products[hashnum((vendorid << 16) | productid)];
-	for (; p; p = p->next)
-		if (p->vendorid == vendorid && p->productid == productid)
-			return p->name;
-	return NULL;
-}
-
-const char *names_class(u_int8_t classid)
-{
-	struct class *c;
-
-	c = classes[hashnum(classid)];
-	for (; c; c = c->next)
-		if (c->classid == classid)
-			return c->name;
-	return NULL;
-}
-
-const char *names_subclass(u_int8_t classid, u_int8_t subclassid)
-{
-	struct subclass *s;
-
-	s = subclasses[hashnum((classid << 8) | subclassid)];
-	for (; s; s = s->next)
-		if (s->classid == classid && s->subclassid == subclassid)
-			return s->name;
-	return NULL;
-}
-
-const char *names_protocol(u_int8_t classid, u_int8_t subclassid,
-			   u_int8_t protocolid)
-{
-	struct protocol *p;
-
-	p = protocols[hashnum((classid << 16) | (subclassid << 8)
-			      | protocolid)];
-	for (; p; p = p->next)
-		if (p->classid == classid && p->subclassid == subclassid &&
-		    p->protocolid == protocolid)
-			return p->name;
-	return NULL;
-}
-
-/* add a cleanup function by takahiro */
-struct pool {
-	struct pool *next;
-	void *mem;
-};
-
-static struct pool *pool_head;
-
-static void *my_malloc(size_t size)
-{
-	struct pool *p;
-
-	p = calloc(1, sizeof(struct pool));
-	if (!p)
-		return NULL;
-
-	p->mem = calloc(1, size);
-	if (!p->mem) {
-		free(p);
-		return NULL;
-	}
-
-	p->next = pool_head;
-	pool_head = p;
-
-	return p->mem;
-}
-
-void names_free(void)
-{
-	struct pool *pool;
-
-	if (!pool_head)
-		return;
-
-	for (pool = pool_head; pool != NULL; ) {
-		struct pool *tmp;
-
-		if (pool->mem)
-			free(pool->mem);
-
-		tmp = pool;
-		pool = pool->next;
-		free(tmp);
-	}
-}
-
-static int new_vendor(const char *name, u_int16_t vendorid)
-{
-	struct vendor *v;
-	unsigned int h = hashnum(vendorid);
-
-	v = vendors[h];
-	for (; v; v = v->next)
-		if (v->vendorid == vendorid)
-			return -1;
-	v = my_malloc(sizeof(struct vendor) + strlen(name));
-	if (!v)
-		return -1;
-	strcpy(v->name, name);
-	v->vendorid = vendorid;
-	v->next = vendors[h];
-	vendors[h] = v;
-	return 0;
-}
-
-static int new_product(const char *name, u_int16_t vendorid,
-		       u_int16_t productid)
-{
-	struct product *p;
-	unsigned int h = hashnum((vendorid << 16) | productid);
-
-	p = products[h];
-	for (; p; p = p->next)
-		if (p->vendorid == vendorid && p->productid == productid)
-			return -1;
-	p = my_malloc(sizeof(struct product) + strlen(name));
-	if (!p)
-		return -1;
-	strcpy(p->name, name);
-	p->vendorid = vendorid;
-	p->productid = productid;
-	p->next = products[h];
-	products[h] = p;
-	return 0;
-}
-
-static int new_class(const char *name, u_int8_t classid)
-{
-	struct class *c;
-	unsigned int h = hashnum(classid);
-
-	c = classes[h];
-	for (; c; c = c->next)
-		if (c->classid == classid)
-			return -1;
-	c = my_malloc(sizeof(struct class) + strlen(name));
-	if (!c)
-		return -1;
-	strcpy(c->name, name);
-	c->classid = classid;
-	c->next = classes[h];
-	classes[h] = c;
-	return 0;
-}
-
-static int new_subclass(const char *name, u_int8_t classid, u_int8_t subclassid)
-{
-	struct subclass *s;
-	unsigned int h = hashnum((classid << 8) | subclassid);
-
-	s = subclasses[h];
-	for (; s; s = s->next)
-		if (s->classid == classid && s->subclassid == subclassid)
-			return -1;
-	s = my_malloc(sizeof(struct subclass) + strlen(name));
-	if (!s)
-		return -1;
-	strcpy(s->name, name);
-	s->classid = classid;
-	s->subclassid = subclassid;
-	s->next = subclasses[h];
-	subclasses[h] = s;
-	return 0;
-}
-
-static int new_protocol(const char *name, u_int8_t classid, u_int8_t subclassid,
-			u_int8_t protocolid)
-{
-	struct protocol *p;
-	unsigned int h = hashnum((classid << 16) | (subclassid << 8)
-				 | protocolid);
-
-	p = protocols[h];
-	for (; p; p = p->next)
-		if (p->classid == classid && p->subclassid == subclassid
-		    && p->protocolid == protocolid)
-			return -1;
-	p = my_malloc(sizeof(struct protocol) + strlen(name));
-	if (!p)
-		return -1;
-	strcpy(p->name, name);
-	p->classid = classid;
-	p->subclassid = subclassid;
-	p->protocolid = protocolid;
-	p->next = protocols[h];
-	protocols[h] = p;
-	return 0;
-}
-
-static void parse(FILE *f)
-{
-	char buf[512], *cp;
-	unsigned int linectr = 0;
-	int lastvendor = -1;
-	int lastclass = -1;
-	int lastsubclass = -1;
-	int lasthut = -1;
-	int lastlang = -1;
-	unsigned int u;
-
-	while (fgets(buf, sizeof(buf), f)) {
-		linectr++;
-		/* remove line ends */
-		cp = strchr(buf, '\r');
-		if (cp)
-			*cp = 0;
-		cp = strchr(buf, '\n');
-		if (cp)
-			*cp = 0;
-		if (buf[0] == '#' || !buf[0])
-			continue;
-		cp = buf;
-		if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' &&
-		    buf[3] == 'S' && buf[4] == 'D' &&
-		    buf[5] == 'E' && buf[6] == 'S' && /*isspace(buf[7])*/
-		    buf[7] == ' ') {
-			continue;
-		}
-		if (buf[0] == 'P' && buf[1] == 'H' &&
-		    buf[2] == 'Y' && /*isspace(buf[3])*/ buf[3] == ' ') {
-			continue;
-		}
-		if (buf[0] == 'B' && buf[1] == 'I' && buf[2] == 'A' &&
-		    buf[3] == 'S' && /*isspace(buf[4])*/ buf[4] == ' ') {
-			continue;
-		}
-		if (buf[0] == 'L' && /*isspace(buf[1])*/ buf[1] == ' ') {
-			lasthut = lastclass = lastvendor = lastsubclass = -1;
-			/*
-			 * set 1 as pseudo-id to indicate that the parser is
-			 * in a `L' section.
-			 */
-			lastlang = 1;
-			continue;
-		}
-		if (buf[0] == 'C' && /*isspace(buf[1])*/ buf[1] == ' ') {
-			/* class spec */
-			cp = buf+2;
-			while (isspace(*cp))
-				cp++;
-			if (!isxdigit(*cp)) {
-				err("Invalid class spec at line %u", linectr);
-				continue;
-			}
-			u = strtoul(cp, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				err("Invalid class spec at line %u", linectr);
-				continue;
-			}
-			if (new_class(cp, u))
-				err("Duplicate class spec at line %u class %04x %s",
-				    linectr, u, cp);
-			dbg("line %5u class %02x %s", linectr, u, cp);
-			lasthut = lastlang = lastvendor = lastsubclass = -1;
-			lastclass = u;
-			continue;
-		}
-		if (buf[0] == 'A' && buf[1] == 'T' && isspace(buf[2])) {
-			/* audio terminal type spec */
-			continue;
-		}
-		if (buf[0] == 'H' && buf[1] == 'C' && buf[2] == 'C'
-		    && isspace(buf[3])) {
-			/* HID Descriptor bCountryCode */
-			continue;
-		}
-		if (isxdigit(*cp)) {
-			/* vendor */
-			u = strtoul(cp, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				err("Invalid vendor spec at line %u", linectr);
-				continue;
-			}
-			if (new_vendor(cp, u))
-				err("Duplicate vendor spec at line %u vendor %04x %s",
-				    linectr, u, cp);
-			dbg("line %5u vendor %04x %s", linectr, u, cp);
-			lastvendor = u;
-			lasthut = lastlang = lastclass = lastsubclass = -1;
-			continue;
-		}
-		if (buf[0] == '\t' && isxdigit(buf[1])) {
-			/* product or subclass spec */
-			u = strtoul(buf+1, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				err("Invalid product/subclass spec at line %u",
-				    linectr);
-				continue;
-			}
-			if (lastvendor != -1) {
-				if (new_product(cp, lastvendor, u))
-					err("Duplicate product spec at line %u product %04x:%04x %s",
-					    linectr, lastvendor, u, cp);
-				dbg("line %5u product %04x:%04x %s", linectr,
-				    lastvendor, u, cp);
-				continue;
-			}
-			if (lastclass != -1) {
-				if (new_subclass(cp, lastclass, u))
-					err("Duplicate subclass spec at line %u class %02x:%02x %s",
-					    linectr, lastclass, u, cp);
-				dbg("line %5u subclass %02x:%02x %s", linectr,
-				    lastclass, u, cp);
-				lastsubclass = u;
-				continue;
-			}
-			if (lasthut != -1) {
-				/* do not store hut */
-				continue;
-			}
-			if (lastlang != -1) {
-				/* do not store langid */
-				continue;
-			}
-			err("Product/Subclass spec without prior Vendor/Class spec at line %u",
-			    linectr);
-			continue;
-		}
-		if (buf[0] == '\t' && buf[1] == '\t' && isxdigit(buf[2])) {
-			/* protocol spec */
-			u = strtoul(buf+2, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				err("Invalid protocol spec at line %u",
-				    linectr);
-				continue;
-			}
-			if (lastclass != -1 && lastsubclass != -1) {
-				if (new_protocol(cp, lastclass, lastsubclass,
-						 u))
-					err("Duplicate protocol spec at line %u class %02x:%02x:%02x %s",
-					    linectr, lastclass, lastsubclass,
-					    u, cp);
-				dbg("line %5u protocol %02x:%02x:%02x %s",
-				    linectr, lastclass, lastsubclass, u, cp);
-				continue;
-			}
-			err("Protocol spec without prior Class and Subclass spec at line %u",
-			    linectr);
-			continue;
-		}
-		if (buf[0] == 'H' && buf[1] == 'I' &&
-		    buf[2] == 'D' && /*isspace(buf[3])*/ buf[3] == ' ') {
-			continue;
-		}
-		if (buf[0] == 'H' && buf[1] == 'U' &&
-		    buf[2] == 'T' && /*isspace(buf[3])*/ buf[3] == ' ') {
-			lastlang = lastclass = lastvendor = lastsubclass = -1;
-			/*
-			 * set 1 as pseudo-id to indicate that the parser is
-			 * in a `HUT' section.
-			 */
-			lasthut = 1;
-			continue;
-		}
-		if (buf[0] == 'R' && buf[1] == ' ')
-			continue;
-
-		if (buf[0] == 'V' && buf[1] == 'T')
-			continue;
-
-		err("Unknown line at line %u", linectr);
-	}
-}
-
-
-int names_init(char *n)
-{
-	FILE *f;
-
-	f = fopen(n, "r");
-	if (!f)
-		return errno;
-
-	parse(f);
-	fclose(f);
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/libsrc/names.h b/drivers/staging/usbip/userspace/libsrc/names.h
deleted file mode 100644
index 6809265..0000000
--- a/drivers/staging/usbip/userspace/libsrc/names.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- *      names.h  --  USB name database manipulation routines
- *
- *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
- *
- *      This program is free software; you can redistribute it and/or modify
- *      it under the terms of the GNU General Public License as published by
- *      the Free Software Foundation; either version 2 of the License, or
- *      (at your option) any later version.
- *
- *      This program is distributed in the hope that it will be useful,
- *      but WITHOUT ANY WARRANTY; without even the implied warranty of
- *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *      GNU General Public License for more details.
- *
- *      You should have received a copy of the GNU General Public License
- *      along with this program; if not, write to the Free Software
- *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
- *
- *	Copyright (C) 2005 Takahiro Hirofuchi
- *	       - names_free() is added.
- */
-
-#ifndef _NAMES_H
-#define _NAMES_H
-
-#include <sys/types.h>
-
-/* used by usbip_common.c */
-extern const char *names_vendor(u_int16_t vendorid);
-extern const char *names_product(u_int16_t vendorid, u_int16_t productid);
-extern const char *names_class(u_int8_t classid);
-extern const char *names_subclass(u_int8_t classid, u_int8_t subclassid);
-extern const char *names_protocol(u_int8_t classid, u_int8_t subclassid,
-				  u_int8_t protocolid);
-extern int  names_init(char *n);
-extern void names_free(void);
-
-#endif /* _NAMES_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
deleted file mode 100644
index 36ac88e..0000000
--- a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include "sysfs_utils.h"
-#include "usbip_common.h"
-
-int write_sysfs_attribute(const char *attr_path, const char *new_value,
-			  size_t len)
-{
-	int fd;
-	int length;
-
-	fd = open(attr_path, O_WRONLY);
-	if (fd < 0) {
-		dbg("error opening attribute %s", attr_path);
-		return -1;
-	}
-
-	length = write(fd, new_value, len);
-	if (length < 0) {
-		dbg("error writing to attribute %s", attr_path);
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h b/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
deleted file mode 100644
index 32ac1d1..0000000
--- a/drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
+++ /dev/null
@@ -1,8 +0,0 @@
-
-#ifndef __SYSFS_UTILS_H
-#define __SYSFS_UTILS_H
-
-int write_sysfs_attribute(const char *attr_path, const char *new_value,
-			  size_t len);
-
-#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
deleted file mode 100644
index 238bf5b..0000000
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ /dev/null
@@ -1,285 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include <libudev.h>
-#include "usbip_common.h"
-#include "names.h"
-
-#undef  PROGNAME
-#define PROGNAME "libusbip"
-
-int usbip_use_syslog;
-int usbip_use_stderr;
-int usbip_use_debug;
-
-extern struct udev *udev_context;
-
-struct speed_string {
-	int num;
-	char *speed;
-	char *desc;
-};
-
-static const struct speed_string speed_strings[] = {
-	{ USB_SPEED_UNKNOWN, "unknown", "Unknown Speed"},
-	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
-	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
-	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
-	{ USB_SPEED_WIRELESS, "53.3-480", "Wireless"},
-	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
-	{ 0, NULL, NULL }
-};
-
-struct portst_string {
-	int num;
-	char *desc;
-};
-
-static struct portst_string portst_strings[] = {
-	{ SDEV_ST_AVAILABLE,	"Device Available" },
-	{ SDEV_ST_USED,		"Device in Use" },
-	{ SDEV_ST_ERROR,	"Device Error"},
-	{ VDEV_ST_NULL,		"Port Available"},
-	{ VDEV_ST_NOTASSIGNED,	"Port Initializing"},
-	{ VDEV_ST_USED,		"Port in Use"},
-	{ VDEV_ST_ERROR,	"Port Error"},
-	{ 0, NULL}
-};
-
-const char *usbip_status_string(int32_t status)
-{
-	for (int i = 0; portst_strings[i].desc != NULL; i++)
-		if (portst_strings[i].num == status)
-			return portst_strings[i].desc;
-
-	return "Unknown Status";
-}
-
-const char *usbip_speed_string(int num)
-{
-	for (int i = 0; speed_strings[i].speed != NULL; i++)
-		if (speed_strings[i].num == num)
-			return speed_strings[i].desc;
-
-	return "Unknown Speed";
-}
-
-
-#define DBG_UDEV_INTEGER(name)\
-	dbg("%-20s = %x", to_string(name), (int) udev->name)
-
-#define DBG_UINF_INTEGER(name)\
-	dbg("%-20s = %x", to_string(name), (int) uinf->name)
-
-void dump_usb_interface(struct usbip_usb_interface *uinf)
-{
-	char buff[100];
-	usbip_names_get_class(buff, sizeof(buff),
-			uinf->bInterfaceClass,
-			uinf->bInterfaceSubClass,
-			uinf->bInterfaceProtocol);
-	dbg("%-20s = %s", "Interface(C/SC/P)", buff);
-}
-
-void dump_usb_device(struct usbip_usb_device *udev)
-{
-	char buff[100];
-
-
-	dbg("%-20s = %s", "path",  udev->path);
-	dbg("%-20s = %s", "busid", udev->busid);
-
-	usbip_names_get_class(buff, sizeof(buff),
-			udev->bDeviceClass,
-			udev->bDeviceSubClass,
-			udev->bDeviceProtocol);
-	dbg("%-20s = %s", "Device(C/SC/P)", buff);
-
-	DBG_UDEV_INTEGER(bcdDevice);
-
-	usbip_names_get_product(buff, sizeof(buff),
-			udev->idVendor,
-			udev->idProduct);
-	dbg("%-20s = %s", "Vendor/Product", buff);
-
-	DBG_UDEV_INTEGER(bNumConfigurations);
-	DBG_UDEV_INTEGER(bNumInterfaces);
-
-	dbg("%-20s = %s", "speed",
-			usbip_speed_string(udev->speed));
-
-	DBG_UDEV_INTEGER(busnum);
-	DBG_UDEV_INTEGER(devnum);
-}
-
-
-int read_attr_value(struct udev_device *dev, const char *name,
-		    const char *format)
-{
-	const char *attr;
-	int num = 0;
-	int ret;
-
-	attr = udev_device_get_sysattr_value(dev, name);
-	if (!attr) {
-		err("udev_device_get_sysattr_value failed");
-		goto err;
-	}
-
-	/* The client chooses the device configuration
-	 * when attaching it so right after being bound
-	 * to usbip-host on the server the device will
-	 * have no configuration.
-	 * Therefore, attributes such as bConfigurationValue
-	 * and bNumInterfaces will not exist and sscanf will
-	 * fail. Check for these cases and don't treat them
-	 * as errors.
-	 */
-
-	ret = sscanf(attr, format, &num);
-	if (ret < 1) {
-		if (strcmp(name, "bConfigurationValue") &&
-				strcmp(name, "bNumInterfaces")) {
-			err("sscanf failed for attribute %s", name);
-			goto err;
-		}
-	}
-
-err:
-
-	return num;
-}
-
-
-int read_attr_speed(struct udev_device *dev)
-{
-	const char *speed;
-
-	speed = udev_device_get_sysattr_value(dev, "speed");
-	if (!speed) {
-		err("udev_device_get_sysattr_value failed");
-		goto err;
-	}
-
-	for (int i = 0; speed_strings[i].speed != NULL; i++) {
-		if (!strcmp(speed, speed_strings[i].speed))
-			return speed_strings[i].num;
-	}
-
-err:
-
-	return USB_SPEED_UNKNOWN;
-}
-
-#define READ_ATTR(object, type, dev, name, format)			      \
-	do {								      \
-		(object)->name = (type) read_attr_value(dev, to_string(name), \
-							format);	      \
-	} while (0)
-
-
-int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev)
-{
-	uint32_t busnum, devnum;
-	const char *path, *name;
-
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceClass,		"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceSubClass,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceProtocol,	"%02x\n");
-
-	READ_ATTR(udev, uint16_t, sdev, idVendor,		"%04x\n");
-	READ_ATTR(udev, uint16_t, sdev, idProduct,		"%04x\n");
-	READ_ATTR(udev, uint16_t, sdev, bcdDevice,		"%04x\n");
-
-	READ_ATTR(udev, uint8_t,  sdev, bConfigurationValue,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bNumConfigurations,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bNumInterfaces,		"%02x\n");
-
-	READ_ATTR(udev, uint8_t,  sdev, devnum,			"%d\n");
-	udev->speed = read_attr_speed(sdev);
-
-	path = udev_device_get_syspath(sdev);
-	name = udev_device_get_sysname(sdev);
-
-	strncpy(udev->path,  path,  SYSFS_PATH_MAX);
-	strncpy(udev->busid, name, SYSFS_BUS_ID_SIZE);
-
-	sscanf(name, "%u-%u", &busnum, &devnum);
-	udev->busnum = busnum;
-
-	return 0;
-}
-
-int read_usb_interface(struct usbip_usb_device *udev, int i,
-		       struct usbip_usb_interface *uinf)
-{
-	char busid[SYSFS_BUS_ID_SIZE];
-	struct udev_device *sif;
-
-	sprintf(busid, "%s:%d.%d", udev->busid, udev->bConfigurationValue, i);
-
-	sif = udev_device_new_from_subsystem_sysname(udev_context, "usb", busid);
-	if (!sif) {
-		err("udev_device_new_from_subsystem_sysname %s failed", busid);
-		return -1;
-	}
-
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceClass,		"%02x\n");
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceSubClass,	"%02x\n");
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceProtocol,	"%02x\n");
-
-	return 0;
-}
-
-int usbip_names_init(char *f)
-{
-	return names_init(f);
-}
-
-void usbip_names_free()
-{
-	names_free();
-}
-
-void usbip_names_get_product(char *buff, size_t size, uint16_t vendor,
-			     uint16_t product)
-{
-	const char *prod, *vend;
-
-	prod = names_product(vendor, product);
-	if (!prod)
-		prod = "unknown product";
-
-
-	vend = names_vendor(vendor);
-	if (!vend)
-		vend = "unknown vendor";
-
-	snprintf(buff, size, "%s : %s (%04x:%04x)", vend, prod, vendor, product);
-}
-
-void usbip_names_get_class(char *buff, size_t size, uint8_t class,
-			   uint8_t subclass, uint8_t protocol)
-{
-	const char *c, *s, *p;
-
-	if (class == 0 && subclass == 0 && protocol == 0) {
-		snprintf(buff, size, "(Defined at Interface level) (%02x/%02x/%02x)", class, subclass, protocol);
-		return;
-	}
-
-	p = names_protocol(class, subclass, protocol);
-	if (!p)
-		p = "unknown protocol";
-
-	s = names_subclass(class, subclass);
-	if (!s)
-		s = "unknown subclass";
-
-	c = names_class(class);
-	if (!c)
-		c = "unknown class";
-
-	snprintf(buff, size, "%s / %s / %s (%02x/%02x/%02x)", c, s, p, class, subclass, protocol);
-}
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
deleted file mode 100644
index 23be848..0000000
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef __USBIP_COMMON_H
-#define __USBIP_COMMON_H
-
-#include <libudev.h>
-
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include <syslog.h>
-#include <unistd.h>
-#include <linux/usb/ch9.h>
-#include "../../uapi/usbip.h"
-
-#ifndef USBIDS_FILE
-#define USBIDS_FILE "/usr/share/hwdata/usb.ids"
-#endif
-
-#ifndef VHCI_STATE_PATH
-#define VHCI_STATE_PATH "/var/run/vhci_hcd"
-#endif
-
-/* kernel module names */
-#define USBIP_CORE_MOD_NAME	"usbip-core"
-#define USBIP_HOST_DRV_NAME	"usbip-host"
-#define USBIP_VHCI_DRV_NAME	"vhci_hcd"
-
-/* sysfs constants */
-#define SYSFS_MNT_PATH         "/sys"
-#define SYSFS_BUS_NAME         "bus"
-#define SYSFS_BUS_TYPE         "usb"
-#define SYSFS_DRIVERS_NAME     "drivers"
-
-#define SYSFS_PATH_MAX		256
-#define SYSFS_BUS_ID_SIZE	32
-
-extern int usbip_use_syslog;
-extern int usbip_use_stderr;
-extern int usbip_use_debug ;
-
-#define PROGNAME "usbip"
-
-#define pr_fmt(fmt)	"%s: %s: " fmt "\n", PROGNAME
-#define dbg_fmt(fmt)	pr_fmt("%s:%d:[%s] " fmt), "debug",	\
-		        __FILE__, __LINE__, __FUNCTION__
-
-#define err(fmt, args...)						\
-	do {								\
-		if (usbip_use_syslog) {					\
-			syslog(LOG_ERR, pr_fmt(fmt), "error", ##args);	\
-		}							\
-		if (usbip_use_stderr) {					\
-			fprintf(stderr, pr_fmt(fmt), "error", ##args);	\
-		}							\
-	} while (0)
-
-#define info(fmt, args...)						\
-	do {								\
-		if (usbip_use_syslog) {					\
-			syslog(LOG_INFO, pr_fmt(fmt), "info", ##args);	\
-		}							\
-		if (usbip_use_stderr) {					\
-			fprintf(stderr, pr_fmt(fmt), "info", ##args);	\
-		}							\
-	} while (0)
-
-#define dbg(fmt, args...)						\
-	do {								\
-	if (usbip_use_debug) {						\
-		if (usbip_use_syslog) {					\
-			syslog(LOG_DEBUG, dbg_fmt(fmt), ##args);	\
-		}							\
-		if (usbip_use_stderr) {					\
-			fprintf(stderr, dbg_fmt(fmt), ##args);		\
-		}							\
-	}								\
-	} while (0)
-
-#define BUG()						\
-	do {						\
-		err("sorry, it's a bug!");		\
-		abort();				\
-	} while (0)
-
-struct usbip_usb_interface {
-	uint8_t bInterfaceClass;
-	uint8_t bInterfaceSubClass;
-	uint8_t bInterfaceProtocol;
-	uint8_t padding;	/* alignment */
-} __attribute__((packed));
-
-struct usbip_usb_device {
-	char path[SYSFS_PATH_MAX];
-	char busid[SYSFS_BUS_ID_SIZE];
-
-	uint32_t busnum;
-	uint32_t devnum;
-	uint32_t speed;
-
-	uint16_t idVendor;
-	uint16_t idProduct;
-	uint16_t bcdDevice;
-
-	uint8_t bDeviceClass;
-	uint8_t bDeviceSubClass;
-	uint8_t bDeviceProtocol;
-	uint8_t bConfigurationValue;
-	uint8_t bNumConfigurations;
-	uint8_t bNumInterfaces;
-} __attribute__((packed));
-
-#define to_string(s)	#s
-
-void dump_usb_interface(struct usbip_usb_interface *);
-void dump_usb_device(struct usbip_usb_device *);
-int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev);
-int read_attr_value(struct udev_device *dev, const char *name,
-		    const char *format);
-int read_usb_interface(struct usbip_usb_device *udev, int i,
-		       struct usbip_usb_interface *uinf);
-
-const char *usbip_speed_string(int num);
-const char *usbip_status_string(int32_t status);
-
-int usbip_names_init(char *);
-void usbip_names_free(void);
-void usbip_names_get_product(char *buff, size_t size, uint16_t vendor,
-			     uint16_t product);
-void usbip_names_get_class(char *buff, size_t size, uint8_t class,
-			   uint8_t subclass, uint8_t protocol);
-
-#endif /* __USBIP_COMMON_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
deleted file mode 100644
index c5bf60b..0000000
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ /dev/null
@@ -1,276 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-
-#include <errno.h>
-#include <unistd.h>
-
-#include <libudev.h>
-
-#include "usbip_common.h"
-#include "usbip_host_driver.h"
-#include "list.h"
-#include "sysfs_utils.h"
-
-#undef  PROGNAME
-#define PROGNAME "libusbip"
-
-struct usbip_host_driver *host_driver;
-struct udev *udev_context;
-
-static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
-{
-	char status_attr_path[SYSFS_PATH_MAX];
-	int fd;
-	int length;
-	char status;
-	int value = 0;
-
-	snprintf(status_attr_path, SYSFS_PATH_MAX, "%s/usbip_status",
-		 udev->path);
-
-	if ((fd = open(status_attr_path, O_RDONLY)) < 0) {
-		err("error opening attribute %s", status_attr_path);
-		return -1;
-	}
-
-	length = read(fd, &status, 1);
-	if (length < 0) {
-		err("error reading attribute %s", status_attr_path);
-		close(fd);
-		return -1;
-	}
-
-	value = atoi(&status);
-
-	return value;
-}
-
-static
-struct usbip_exported_device *usbip_exported_device_new(const char *sdevpath)
-{
-	struct usbip_exported_device *edev = NULL;
-	struct usbip_exported_device *edev_old;
-	size_t size;
-	int i;
-
-	edev = calloc(1, sizeof(struct usbip_exported_device));
-
-	edev->sudev = udev_device_new_from_syspath(udev_context, sdevpath);
-	if (!edev->sudev) {
-		err("udev_device_new_from_syspath: %s", sdevpath);
-		goto err;
-	}
-
-	read_usb_device(edev->sudev, &edev->udev);
-
-	edev->status = read_attr_usbip_status(&edev->udev);
-	if (edev->status < 0)
-		goto err;
-
-	/* reallocate buffer to include usb interface data */
-	size = sizeof(struct usbip_exported_device) + edev->udev.bNumInterfaces *
-		sizeof(struct usbip_usb_interface);
-
-	edev_old = edev;
-	edev = realloc(edev, size);
-	if (!edev) {
-		edev = edev_old;
-		dbg("realloc failed");
-		goto err;
-	}
-
-	for (i = 0; i < edev->udev.bNumInterfaces; i++)
-		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
-
-	return edev;
-err:
-	if (edev->sudev)
-		udev_device_unref(edev->sudev);
-	if (edev)
-		free(edev);
-
-	return NULL;
-}
-
-static int refresh_exported_devices(void)
-{
-	struct usbip_exported_device *edev;
-	struct udev_enumerate *enumerate;
-	struct udev_list_entry *devices, *dev_list_entry;
-	struct udev_device *dev;
-	const char *path;
-
-	enumerate = udev_enumerate_new(udev_context);
-	udev_enumerate_add_match_subsystem(enumerate, "usb");
-	udev_enumerate_scan_devices(enumerate);
-
-	devices = udev_enumerate_get_list_entry(enumerate);
-
-	udev_list_entry_foreach(dev_list_entry, devices) {
-		path = udev_list_entry_get_name(dev_list_entry);
-		dev = udev_device_new_from_syspath(udev_context, path);
-
-		/* Check whether device uses usbip-host driver. */
-		if (!strcmp(udev_device_get_driver(dev),
-			    USBIP_HOST_DRV_NAME)) {
-			edev = usbip_exported_device_new(path);
-			if (!edev) {
-				dbg("usbip_exported_device_new failed");
-				continue;
-			}
-
-			list_add(&edev->node, &host_driver->edev_list);
-			host_driver->ndevs++;
-		}
-	}
-
-	return 0;
-}
-
-static void usbip_exported_device_destroy(void)
-{
-	struct list_head *i, *tmp;
-	struct usbip_exported_device *edev;
-
-	list_for_each_safe(i, tmp, &host_driver->edev_list) {
-		edev = list_entry(i, struct usbip_exported_device, node);
-		list_del(i);
-		free(edev);
-	}
-}
-
-int usbip_host_driver_open(void)
-{
-	int rc;
-
-	udev_context = udev_new();
-	if (!udev_context) {
-		err("udev_new failed");
-		return -1;
-	}
-
-	host_driver = calloc(1, sizeof(*host_driver));
-
-	host_driver->ndevs = 0;
-	INIT_LIST_HEAD(&host_driver->edev_list);
-
-	rc = refresh_exported_devices();
-	if (rc < 0)
-		goto err_free_host_driver;
-
-	return 0;
-
-err_free_host_driver:
-	free(host_driver);
-	host_driver = NULL;
-
-	udev_unref(udev_context);
-
-	return -1;
-}
-
-void usbip_host_driver_close(void)
-{
-	if (!host_driver)
-		return;
-
-	usbip_exported_device_destroy();
-
-	free(host_driver);
-	host_driver = NULL;
-
-	udev_unref(udev_context);
-}
-
-int usbip_host_refresh_device_list(void)
-{
-	int rc;
-
-	usbip_exported_device_destroy();
-
-	host_driver->ndevs = 0;
-	INIT_LIST_HEAD(&host_driver->edev_list);
-
-	rc = refresh_exported_devices();
-	if (rc < 0)
-		return -1;
-
-	return 0;
-}
-
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
-{
-	char attr_name[] = "usbip_sockfd";
-	char sockfd_attr_path[SYSFS_PATH_MAX];
-	char sockfd_buff[30];
-	int ret;
-
-	if (edev->status != SDEV_ST_AVAILABLE) {
-		dbg("device not available: %s", edev->udev.busid);
-		switch (edev->status) {
-		case SDEV_ST_ERROR:
-			dbg("status SDEV_ST_ERROR");
-			break;
-		case SDEV_ST_USED:
-			dbg("status SDEV_ST_USED");
-			break;
-		default:
-			dbg("status unknown: 0x%x", edev->status);
-		}
-		return -1;
-	}
-
-	/* only the first interface is true */
-	snprintf(sockfd_attr_path, sizeof(sockfd_attr_path), "%s/%s",
-		 edev->udev.path, attr_name);
-
-	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
-
-	ret = write_sysfs_attribute(sockfd_attr_path, sockfd_buff,
-				    strlen(sockfd_buff));
-	if (ret < 0) {
-		err("write_sysfs_attribute failed: sockfd %s to %s",
-		    sockfd_buff, sockfd_attr_path);
-		return ret;
-	}
-
-	info("connect: %s", edev->udev.busid);
-
-	return ret;
-}
-
-struct usbip_exported_device *usbip_host_get_device(int num)
-{
-	struct list_head *i;
-	struct usbip_exported_device *edev;
-	int cnt = 0;
-
-	list_for_each(i, &host_driver->edev_list) {
-		edev = list_entry(i, struct usbip_exported_device, node);
-		if (num == cnt)
-			return edev;
-		else
-			cnt++;
-	}
-
-	return NULL;
-}
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
deleted file mode 100644
index 2a31f85..0000000
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __USBIP_HOST_DRIVER_H
-#define __USBIP_HOST_DRIVER_H
-
-#include <stdint.h>
-#include "usbip_common.h"
-#include "list.h"
-
-struct usbip_host_driver {
-	int ndevs;
-	/* list of exported device */
-	struct list_head edev_list;
-};
-
-struct usbip_exported_device {
-	struct udev_device *sudev;
-	int32_t status;
-	struct usbip_usb_device udev;
-	struct list_head node;
-	struct usbip_usb_interface uinf[];
-};
-
-extern struct usbip_host_driver *host_driver;
-
-int usbip_host_driver_open(void);
-void usbip_host_driver_close(void);
-
-int usbip_host_refresh_device_list(void);
-int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd);
-struct usbip_exported_device *usbip_host_get_device(int num);
-
-#endif /* __USBIP_HOST_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
deleted file mode 100644
index 8901fcb..0000000
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ /dev/null
@@ -1,411 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include "usbip_common.h"
-#include "vhci_driver.h"
-#include <limits.h>
-#include <netdb.h>
-#include <libudev.h>
-#include "sysfs_utils.h"
-
-#undef  PROGNAME
-#define PROGNAME "libusbip"
-
-struct usbip_vhci_driver *vhci_driver;
-struct udev *udev_context;
-
-static struct usbip_imported_device *
-imported_device_init(struct usbip_imported_device *idev, char *busid)
-{
-	struct udev_device *sudev;
-
-	sudev = udev_device_new_from_subsystem_sysname(udev_context,
-						       "usb", busid);
-	if (!sudev) {
-		dbg("udev_device_new_from_subsystem_sysname failed: %s", busid);
-		goto err;
-	}
-	read_usb_device(sudev, &idev->udev);
-	udev_device_unref(sudev);
-
-	return idev;
-
-err:
-	return NULL;
-}
-
-
-
-static int parse_status(const char *value)
-{
-	int ret = 0;
-	char *c;
-
-
-	for (int i = 0; i < vhci_driver->nports; i++)
-		memset(&vhci_driver->idev[i], 0, sizeof(vhci_driver->idev[i]));
-
-
-	/* skip a header line */
-	c = strchr(value, '\n');
-	if (!c)
-		return -1;
-	c++;
-
-	while (*c != '\0') {
-		int port, status, speed, devid;
-		unsigned long socket;
-		char lbusid[SYSFS_BUS_ID_SIZE];
-
-		ret = sscanf(c, "%d %d %d %x %lx %31s\n",
-				&port, &status, &speed,
-				&devid, &socket, lbusid);
-
-		if (ret < 5) {
-			dbg("sscanf failed: %d", ret);
-			BUG();
-		}
-
-		dbg("port %d status %d speed %d devid %x",
-				port, status, speed, devid);
-		dbg("socket %lx lbusid %s", socket, lbusid);
-
-
-		/* if a device is connected, look at it */
-		{
-			struct usbip_imported_device *idev = &vhci_driver->idev[port];
-
-			idev->port	= port;
-			idev->status	= status;
-
-			idev->devid	= devid;
-
-			idev->busnum	= (devid >> 16);
-			idev->devnum	= (devid & 0x0000ffff);
-
-			if (idev->status != VDEV_ST_NULL
-			    && idev->status != VDEV_ST_NOTASSIGNED) {
-				idev = imported_device_init(idev, lbusid);
-				if (!idev) {
-					dbg("imported_device_init failed");
-					return -1;
-				}
-			}
-		}
-
-
-		/* go to the next line */
-		c = strchr(c, '\n');
-		if (!c)
-			break;
-		c++;
-	}
-
-	dbg("exit");
-
-	return 0;
-}
-
-static int refresh_imported_device_list(void)
-{
-	const char *attr_status;
-
-	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
-					       "status");
-	if (!attr_status) {
-		err("udev_device_get_sysattr_value failed");
-		return -1;
-	}
-
-	return parse_status(attr_status);
-}
-
-static int get_nports(void)
-{
-	char *c;
-	int nports = 0;
-	const char *attr_status;
-
-	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
-					       "status");
-	if (!attr_status) {
-		err("udev_device_get_sysattr_value failed");
-		return -1;
-	}
-
-	/* skip a header line */
-	c = strchr(attr_status, '\n');
-	if (!c)
-		return 0;
-	c++;
-
-	while (*c != '\0') {
-		/* go to the next line */
-		c = strchr(c, '\n');
-		if (!c)
-			return nports;
-		c++;
-		nports += 1;
-	}
-
-	return nports;
-}
-
-/*
- * Read the given port's record.
- *
- * To avoid buffer overflow we will read the entire line and
- * validate each part's size. The initial buffer is padded by 4 to
- * accommodate the 2 spaces, 1 newline and an additional character
- * which is needed to properly validate the 3rd part without it being
- * truncated to an acceptable length.
- */
-static int read_record(int rhport, char *host, unsigned long host_len,
-		char *port, unsigned long port_len, char *busid)
-{
-	int part;
-	FILE *file;
-	char path[PATH_MAX+1];
-	char *buffer, *start, *end;
-	char delim[] = {' ', ' ', '\n'};
-	int max_len[] = {(int)host_len, (int)port_len, SYSFS_BUS_ID_SIZE};
-	size_t buffer_len = host_len + port_len + SYSFS_BUS_ID_SIZE + 4;
-
-	buffer = malloc(buffer_len);
-	if (!buffer)
-		return -1;
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	file = fopen(path, "r");
-	if (!file) {
-		err("fopen");
-		free(buffer);
-		return -1;
-	}
-
-	if (fgets(buffer, buffer_len, file) == NULL) {
-		err("fgets");
-		free(buffer);
-		fclose(file);
-		return -1;
-	}
-	fclose(file);
-
-	/* validate the length of each of the 3 parts */
-	start = buffer;
-	for (part = 0; part < 3; part++) {
-		end = strchr(start, delim[part]);
-		if (end == NULL || (end - start) > max_len[part]) {
-			free(buffer);
-			return -1;
-		}
-		start = end + 1;
-	}
-
-	if (sscanf(buffer, "%s %s %s\n", host, port, busid) != 3) {
-		err("sscanf");
-		free(buffer);
-		return -1;
-	}
-
-	free(buffer);
-
-	return 0;
-}
-
-/* ---------------------------------------------------------------------- */
-
-int usbip_vhci_driver_open(void)
-{
-	udev_context = udev_new();
-	if (!udev_context) {
-		err("udev_new failed");
-		return -1;
-	}
-
-	vhci_driver = calloc(1, sizeof(struct usbip_vhci_driver));
-
-	/* will be freed in usbip_driver_close() */
-	vhci_driver->hc_device =
-		udev_device_new_from_subsystem_sysname(udev_context,
-						       USBIP_VHCI_BUS_TYPE,
-						       USBIP_VHCI_DRV_NAME);
-	if (!vhci_driver->hc_device) {
-		err("udev_device_new_from_subsystem_sysname failed");
-		goto err;
-	}
-
-	vhci_driver->nports = get_nports();
-
-	dbg("available ports: %d", vhci_driver->nports);
-
-	if (refresh_imported_device_list())
-		goto err;
-
-	return 0;
-
-err:
-	udev_device_unref(vhci_driver->hc_device);
-
-	if (vhci_driver)
-		free(vhci_driver);
-
-	vhci_driver = NULL;
-
-	udev_unref(udev_context);
-
-	return -1;
-}
-
-
-void usbip_vhci_driver_close()
-{
-	if (!vhci_driver)
-		return;
-
-	udev_device_unref(vhci_driver->hc_device);
-
-	free(vhci_driver);
-
-	vhci_driver = NULL;
-
-	udev_unref(udev_context);
-}
-
-
-int usbip_vhci_refresh_device_list(void)
-{
-
-	if (refresh_imported_device_list())
-		goto err;
-
-	return 0;
-err:
-	dbg("failed to refresh device list");
-	return -1;
-}
-
-
-int usbip_vhci_get_free_port(void)
-{
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].status == VDEV_ST_NULL)
-			return i;
-	}
-
-	return -1;
-}
-
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed) {
-	char buff[200]; /* what size should be ? */
-	char attach_attr_path[SYSFS_PATH_MAX];
-	char attr_attach[] = "attach";
-	const char *path;
-	int ret;
-
-	snprintf(buff, sizeof(buff), "%u %d %u %u",
-			port, sockfd, devid, speed);
-	dbg("writing: %s", buff);
-
-	path = udev_device_get_syspath(vhci_driver->hc_device);
-	snprintf(attach_attr_path, sizeof(attach_attr_path), "%s/%s",
-		 path, attr_attach);
-	dbg("attach attribute path: %s", attach_attr_path);
-
-	ret = write_sysfs_attribute(attach_attr_path, buff, strlen(buff));
-	if (ret < 0) {
-		dbg("write_sysfs_attribute failed");
-		return -1;
-	}
-
-	dbg("attached port: %d", port);
-
-	return 0;
-}
-
-static unsigned long get_devid(uint8_t busnum, uint8_t devnum)
-{
-	return (busnum << 16) | devnum;
-}
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed)
-{
-	int devid = get_devid(busnum, devnum);
-
-	return usbip_vhci_attach_device2(port, sockfd, devid, speed);
-}
-
-int usbip_vhci_detach_device(uint8_t port)
-{
-	char detach_attr_path[SYSFS_PATH_MAX];
-	char attr_detach[] = "detach";
-	char buff[200]; /* what size should be ? */
-	const char *path;
-	int ret;
-
-	snprintf(buff, sizeof(buff), "%u", port);
-	dbg("writing: %s", buff);
-
-	path = udev_device_get_syspath(vhci_driver->hc_device);
-	snprintf(detach_attr_path, sizeof(detach_attr_path), "%s/%s",
-		 path, attr_detach);
-	dbg("detach attribute path: %s", detach_attr_path);
-
-	ret = write_sysfs_attribute(detach_attr_path, buff, strlen(buff));
-	if (ret < 0) {
-		dbg("write_sysfs_attribute failed");
-		return -1;
-	}
-
-	dbg("detached port: %d", port);
-
-	return 0;
-}
-
-int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
-{
-	char product_name[100];
-	char host[NI_MAXHOST] = "unknown host";
-	char serv[NI_MAXSERV] = "unknown port";
-	char remote_busid[SYSFS_BUS_ID_SIZE];
-	int ret;
-	int read_record_error = 0;
-
-	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED)
-		return 0;
-
-	ret = read_record(idev->port, host, sizeof(host), serv, sizeof(serv),
-			  remote_busid);
-	if (ret) {
-		err("read_record");
-		read_record_error = 1;
-	}
-
-	printf("Port %02d: <%s> at %s\n", idev->port,
-	       usbip_status_string(idev->status),
-	       usbip_speed_string(idev->udev.speed));
-
-	usbip_names_get_product(product_name, sizeof(product_name),
-				idev->udev.idVendor, idev->udev.idProduct);
-
-	printf("       %s\n",  product_name);
-
-	if (!read_record_error) {
-		printf("%10s -> usbip://%s:%s/%s\n", idev->udev.busid,
-		       host, serv, remote_busid);
-		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
-		       idev->busnum, idev->devnum);
-	} else {
-		printf("%10s -> unknown host, remote port and remote busid\n",
-		       idev->udev.busid);
-		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
-		       idev->busnum, idev->devnum);
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
deleted file mode 100644
index fa2316c..0000000
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef __VHCI_DRIVER_H
-#define __VHCI_DRIVER_H
-
-#include <libudev.h>
-#include <stdint.h>
-
-#include "usbip_common.h"
-
-#define USBIP_VHCI_BUS_TYPE "platform"
-#define MAXNPORT 128
-
-struct usbip_imported_device {
-	uint8_t port;
-	uint32_t status;
-
-	uint32_t devid;
-
-	uint8_t busnum;
-	uint8_t devnum;
-
-	/* usbip_class_device list */
-	struct usbip_usb_device udev;
-};
-
-struct usbip_vhci_driver {
-
-	/* /sys/devices/platform/vhci_hcd */
-	struct udev_device *hc_device;
-
-	int nports;
-	struct usbip_imported_device idev[MAXNPORT];
-};
-
-
-extern struct usbip_vhci_driver *vhci_driver;
-
-int usbip_vhci_driver_open(void);
-void usbip_vhci_driver_close(void);
-
-int  usbip_vhci_refresh_device_list(void);
-
-
-int usbip_vhci_get_free_port(void);
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed);
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed);
-
-int usbip_vhci_detach_device(uint8_t port);
-
-int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev);
-
-#endif /* __VHCI_DRIVER_H */
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
deleted file mode 100644
index e81a4eb..0000000
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ /dev/null
@@ -1,11 +0,0 @@
-AM_CPPFLAGS = -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-AM_CFLAGS   = @EXTRA_CFLAGS@
-LDADD       = $(top_builddir)/libsrc/libusbip.la
-
-sbin_PROGRAMS := usbip usbipd
-
-usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
-		 usbip_attach.c usbip_detach.c usbip_list.c \
-		 usbip_bind.c usbip_unbind.c usbip_port.c
-
-usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
deleted file mode 100644
index d7599d9..0000000
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/*
- * command structure borrowed from udev
- * (git://git.kernel.org/pub/scm/linux/hotplug/udev.git)
- *
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-
-#include <getopt.h>
-#include <syslog.h>
-
-#include "usbip_common.h"
-#include "usbip_network.h"
-#include "usbip.h"
-
-static int usbip_help(int argc, char *argv[]);
-static int usbip_version(int argc, char *argv[]);
-
-static const char usbip_version_string[] = PACKAGE_STRING;
-
-static const char usbip_usage_string[] =
-	"usbip [--debug] [--log] [--tcp-port PORT] [version]\n"
-	"             [help] <command> <args>\n";
-
-static void usbip_usage(void)
-{
-	printf("usage: %s", usbip_usage_string);
-}
-
-struct command {
-	const char *name;
-	int (*fn)(int argc, char *argv[]);
-	const char *help;
-	void (*usage)(void);
-};
-
-static const struct command cmds[] = {
-	{
-		.name  = "help",
-		.fn    = usbip_help,
-		.help  = NULL,
-		.usage = NULL
-	},
-	{
-		.name  = "version",
-		.fn    = usbip_version,
-		.help  = NULL,
-		.usage = NULL
-	},
-	{
-		.name  = "attach",
-		.fn    = usbip_attach,
-		.help  = "Attach a remote USB device",
-		.usage = usbip_attach_usage
-	},
-	{
-		.name  = "detach",
-		.fn    = usbip_detach,
-		.help  = "Detach a remote USB device",
-		.usage = usbip_detach_usage
-	},
-	{
-		.name  = "list",
-		.fn    = usbip_list,
-		.help  = "List exportable or local USB devices",
-		.usage = usbip_list_usage
-	},
-	{
-		.name  = "bind",
-		.fn    = usbip_bind,
-		.help  = "Bind device to " USBIP_HOST_DRV_NAME ".ko",
-		.usage = usbip_bind_usage
-	},
-	{
-		.name  = "unbind",
-		.fn    = usbip_unbind,
-		.help  = "Unbind device from " USBIP_HOST_DRV_NAME ".ko",
-		.usage = usbip_unbind_usage
-	},
-	{
-		.name  = "port",
-		.fn    = usbip_port_show,
-		.help  = "Show imported USB devices",
-		.usage = NULL
-	},
-	{ NULL, NULL, NULL, NULL }
-};
-
-static int usbip_help(int argc, char *argv[])
-{
-	const struct command *cmd;
-	int i;
-	int ret = 0;
-
-	if (argc > 1 && argv++) {
-		for (i = 0; cmds[i].name != NULL; i++)
-			if (!strcmp(cmds[i].name, argv[0]) && cmds[i].usage) {
-				cmds[i].usage();
-				goto done;
-			}
-		ret = -1;
-	}
-
-	usbip_usage();
-	printf("\n");
-	for (cmd = cmds; cmd->name != NULL; cmd++)
-		if (cmd->help != NULL)
-			printf("  %-10s %s\n", cmd->name, cmd->help);
-	printf("\n");
-done:
-	return ret;
-}
-
-static int usbip_version(int argc, char *argv[])
-{
-	(void) argc;
-	(void) argv;
-
-	printf(PROGNAME " (%s)\n", usbip_version_string);
-	return 0;
-}
-
-static int run_command(const struct command *cmd, int argc, char *argv[])
-{
-	dbg("running command: `%s'", cmd->name);
-	return cmd->fn(argc, argv);
-}
-
-int main(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "debug",    no_argument,       NULL, 'd' },
-		{ "log",      no_argument,       NULL, 'l' },
-		{ "tcp-port", required_argument, NULL, 't' },
-		{ NULL,       0,                 NULL,  0  }
-	};
-
-	char *cmd;
-	int opt;
-	int i, rc = -1;
-
-	usbip_use_stderr = 1;
-	opterr = 0;
-	for (;;) {
-		opt = getopt_long(argc, argv, "+dlt:", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'd':
-			usbip_use_debug = 1;
-			break;
-		case 'l':
-			usbip_use_syslog = 1;
-			openlog("", LOG_PID, LOG_USER);
-			break;
-		case 't':
-			usbip_setup_port_number(optarg);
-			break;
-		case '?':
-			printf("usbip: invalid option\n");
-		default:
-			usbip_usage();
-			goto out;
-		}
-	}
-
-	cmd = argv[optind];
-	if (cmd) {
-		for (i = 0; cmds[i].name != NULL; i++)
-			if (!strcmp(cmds[i].name, cmd)) {
-				argc -= optind;
-				argv += optind;
-				optind = 0;
-				rc = run_command(&cmds[i], argc, argv);
-				goto out;
-			}
-	}
-
-	/* invalid command */
-	usbip_help(0, NULL);
-out:
-	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip.h b/drivers/staging/usbip/userspace/src/usbip.h
deleted file mode 100644
index 84fe66a..0000000
--- a/drivers/staging/usbip/userspace/src/usbip.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __USBIP_H
-#define __USBIP_H
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-/* usbip commands */
-int usbip_attach(int argc, char *argv[]);
-int usbip_detach(int argc, char *argv[]);
-int usbip_list(int argc, char *argv[]);
-int usbip_bind(int argc, char *argv[]);
-int usbip_unbind(int argc, char *argv[]);
-int usbip_port_show(int argc, char *argv[]);
-
-void usbip_attach_usage(void);
-void usbip_detach_usage(void);
-void usbip_list_usage(void);
-void usbip_bind_usage(void);
-void usbip_unbind_usage(void);
-
-#endif /* __USBIP_H */
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
deleted file mode 100644
index 716a79e..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <sys/stat.h>
-
-#include <limits.h>
-#include <stdint.h>
-#include <stdio.h>
-#include <string.h>
-
-#include <fcntl.h>
-#include <getopt.h>
-#include <unistd.h>
-#include <errno.h>
-
-#include "vhci_driver.h"
-#include "usbip_common.h"
-#include "usbip_network.h"
-#include "usbip.h"
-
-static const char usbip_attach_usage_string[] =
-	"usbip attach <args>\n"
-	"    -r, --remote=<host>      The machine with exported USB devices\n"
-	"    -b, --busid=<busid>    Busid of the device on <host>\n";
-
-void usbip_attach_usage(void)
-{
-	printf("usage: %s", usbip_attach_usage_string);
-}
-
-#define MAX_BUFF 100
-static int record_connection(char *host, char *port, char *busid, int rhport)
-{
-	int fd;
-	char path[PATH_MAX+1];
-	char buff[MAX_BUFF+1];
-	int ret;
-
-	ret = mkdir(VHCI_STATE_PATH, 0700);
-	if (ret < 0) {
-		/* if VHCI_STATE_PATH exists, then it better be a directory */
-		if (errno == EEXIST) {
-			struct stat s;
-			ret = stat(VHCI_STATE_PATH, &s);
-			if (ret < 0)
-				return -1;
-			if (!(s.st_mode & S_IFDIR))
-				return -1;
-		} else
-			return -1;
-	}
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
-	if (fd < 0)
-		return -1;
-
-	snprintf(buff, MAX_BUFF, "%s %s %s\n",
-			host, port, busid);
-
-	ret = write(fd, buff, strlen(buff));
-	if (ret != (ssize_t) strlen(buff)) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int import_device(int sockfd, struct usbip_usb_device *udev)
-{
-	int rc;
-	int port;
-
-	rc = usbip_vhci_driver_open();
-	if (rc < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	port = usbip_vhci_get_free_port();
-	if (port < 0) {
-		err("no free port");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
-				      udev->devnum, udev->speed);
-	if (rc < 0) {
-		err("import device");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return port;
-}
-
-static int query_import_device(int sockfd, char *busid)
-{
-	int rc;
-	struct op_import_request request;
-	struct op_import_reply   reply;
-	uint16_t code = OP_REP_IMPORT;
-
-	memset(&request, 0, sizeof(request));
-	memset(&reply, 0, sizeof(reply));
-
-	/* send a request */
-	rc = usbip_net_send_op_common(sockfd, OP_REQ_IMPORT, 0);
-	if (rc < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
-
-	PACK_OP_IMPORT_REQUEST(0, &request);
-
-	rc = usbip_net_send(sockfd, (void *) &request, sizeof(request));
-	if (rc < 0) {
-		err("send op_import_request");
-		return -1;
-	}
-
-	/* receive a reply */
-	rc = usbip_net_recv_op_common(sockfd, &code);
-	if (rc < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	rc = usbip_net_recv(sockfd, (void *) &reply, sizeof(reply));
-	if (rc < 0) {
-		err("recv op_import_reply");
-		return -1;
-	}
-
-	PACK_OP_IMPORT_REPLY(0, &reply);
-
-	/* check the reply */
-	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
-		err("recv different busid %s", reply.udev.busid);
-		return -1;
-	}
-
-	/* import a device */
-	return import_device(sockfd, &reply.udev);
-}
-
-static int attach_device(char *host, char *busid)
-{
-	int sockfd;
-	int rc;
-	int rhport;
-
-	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
-	if (sockfd < 0) {
-		err("tcp connect");
-		return -1;
-	}
-
-	rhport = query_import_device(sockfd, busid);
-	if (rhport < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-
-	rc = record_connection(host, usbip_port_string, busid, rhport);
-	if (rc < 0) {
-		err("record connection");
-		return -1;
-	}
-
-	return 0;
-}
-
-int usbip_attach(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "remote", required_argument, NULL, 'r' },
-		{ "busid",  required_argument, NULL, 'b' },
-		{ NULL, 0,  NULL, 0 }
-	};
-	char *host = NULL;
-	char *busid = NULL;
-	int opt;
-	int ret = -1;
-
-	for (;;) {
-		opt = getopt_long(argc, argv, "r:b:", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'r':
-			host = optarg;
-			break;
-		case 'b':
-			busid = optarg;
-			break;
-		default:
-			goto err_out;
-		}
-	}
-
-	if (!host || !busid)
-		goto err_out;
-
-	ret = attach_device(host, busid);
-	goto out;
-
-err_out:
-	usbip_attach_usage();
-out:
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
deleted file mode 100644
index fa46141..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ /dev/null
@@ -1,214 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <libudev.h>
-
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include <getopt.h>
-
-#include "usbip_common.h"
-#include "utils.h"
-#include "usbip.h"
-#include "sysfs_utils.h"
-
-enum unbind_status {
-	UNBIND_ST_OK,
-	UNBIND_ST_USBIP_HOST,
-	UNBIND_ST_FAILED
-};
-
-static const char usbip_bind_usage_string[] =
-	"usbip bind <args>\n"
-	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
-	"on <busid>\n";
-
-void usbip_bind_usage(void)
-{
-	printf("usage: %s", usbip_bind_usage_string);
-}
-
-/* call at unbound state */
-static int bind_usbip(char *busid)
-{
-	char attr_name[] = "bind";
-	char bind_attr_path[SYSFS_PATH_MAX];
-	int rc = -1;
-
-	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
-		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
-		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
-
-	rc = write_sysfs_attribute(bind_attr_path, busid, strlen(busid));
-	if (rc < 0) {
-		err("error binding device %s to driver: %s", busid,
-		    strerror(errno));
-		return -1;
-	}
-
-	return 0;
-}
-
-/* buggy driver may cause dead lock */
-static int unbind_other(char *busid)
-{
-	enum unbind_status status = UNBIND_ST_OK;
-
-	char attr_name[] = "unbind";
-	char unbind_attr_path[SYSFS_PATH_MAX];
-	int rc = -1;
-
-	struct udev *udev;
-	struct udev_device *dev;
-	const char *driver;
-	const char *bDevClass;
-
-	/* Create libudev context. */
-	udev = udev_new();
-
-	/* Get the device. */
-	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
-	if (!dev) {
-		dbg("unable to find device with bus ID %s", busid);
-		goto err_close_busid_dev;
-	}
-
-	/* Check what kind of device it is. */
-	bDevClass  = udev_device_get_sysattr_value(dev, "bDeviceClass");
-	if (!bDevClass) {
-		dbg("unable to get bDevClass device attribute");
-		goto err_close_busid_dev;
-	}
-
-	if (!strncmp(bDevClass, "09", strlen(bDevClass))) {
-		dbg("skip unbinding of hub");
-		goto err_close_busid_dev;
-	}
-
-	/* Get the device driver. */
-	driver = udev_device_get_driver(dev);
-	if (!driver) {
-		/* No driver bound to this device. */
-		goto out;
-	}
-
-	if (!strncmp(USBIP_HOST_DRV_NAME, driver,
-				strlen(USBIP_HOST_DRV_NAME))) {
-		/* Already bound to usbip-host. */
-		status = UNBIND_ST_USBIP_HOST;
-		goto out;
-	}
-
-	/* Unbind device from driver. */
-	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
-		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
-		 SYSFS_DRIVERS_NAME, driver, attr_name);
-
-	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
-	if (rc < 0) {
-		err("error unbinding device %s from driver", busid);
-		goto err_close_busid_dev;
-	}
-
-	goto out;
-
-err_close_busid_dev:
-	status = UNBIND_ST_FAILED;
-out:
-	udev_device_unref(dev);
-	udev_unref(udev);
-
-	return status;
-}
-
-static int bind_device(char *busid)
-{
-	int rc;
-	struct udev *udev;
-	struct udev_device *dev;
-
-	/* Check whether the device with this bus ID exists. */
-	udev = udev_new();
-	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
-	if (!dev) {
-		err("device with the specified bus ID does not exist");
-		return -1;
-	}
-	udev_unref(udev);
-
-	rc = unbind_other(busid);
-	if (rc == UNBIND_ST_FAILED) {
-		err("could not unbind driver from device on busid %s", busid);
-		return -1;
-	} else if (rc == UNBIND_ST_USBIP_HOST) {
-		err("device on busid %s is already bound to %s", busid,
-		    USBIP_HOST_DRV_NAME);
-		return -1;
-	}
-
-	rc = modify_match_busid(busid, 1);
-	if (rc < 0) {
-		err("unable to bind device on %s", busid);
-		return -1;
-	}
-
-	rc = bind_usbip(busid);
-	if (rc < 0) {
-		err("could not bind device to %s", USBIP_HOST_DRV_NAME);
-		modify_match_busid(busid, 0);
-		return -1;
-	}
-
-	info("bind device on busid %s: complete", busid);
-
-	return 0;
-}
-
-int usbip_bind(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "busid", required_argument, NULL, 'b' },
-		{ NULL,    0,                 NULL,  0  }
-	};
-
-	int opt;
-	int ret = -1;
-
-	for (;;) {
-		opt = getopt_long(argc, argv, "b:", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'b':
-			ret = bind_device(optarg);
-			goto out;
-		default:
-			goto err_out;
-		}
-	}
-
-err_out:
-	usbip_bind_usage();
-out:
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_detach.c b/drivers/staging/usbip/userspace/src/usbip_detach.c
deleted file mode 100644
index 05c6d15..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_detach.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <ctype.h>
-#include <limits.h>
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include <getopt.h>
-#include <unistd.h>
-
-#include "vhci_driver.h"
-#include "usbip_common.h"
-#include "usbip_network.h"
-#include "usbip.h"
-
-static const char usbip_detach_usage_string[] =
-	"usbip detach <args>\n"
-	"    -p, --port=<port>    " USBIP_VHCI_DRV_NAME
-	" port the device is on\n";
-
-void usbip_detach_usage(void)
-{
-	printf("usage: %s", usbip_detach_usage_string);
-}
-
-static int detach_port(char *port)
-{
-	int ret;
-	uint8_t portnum;
-	char path[PATH_MAX+1];
-
-	for (unsigned int i = 0; i < strlen(port); i++)
-		if (!isdigit(port[i])) {
-			err("invalid port %s", port);
-			return -1;
-		}
-
-	/* check max port */
-
-	portnum = atoi(port);
-
-	/* remove the port state file */
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", portnum);
-
-	remove(path);
-	rmdir(VHCI_STATE_PATH);
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	ret = usbip_vhci_detach_device(portnum);
-	if (ret < 0)
-		return -1;
-
-	usbip_vhci_driver_close();
-
-	return ret;
-}
-
-int usbip_detach(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "port", required_argument, NULL, 'p' },
-		{ NULL, 0, NULL, 0 }
-	};
-	int opt;
-	int ret = -1;
-
-	for (;;) {
-		opt = getopt_long(argc, argv, "p:", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'p':
-			ret = detach_port(optarg);
-			goto out;
-		default:
-			goto err_out;
-		}
-	}
-
-err_out:
-	usbip_detach_usage();
-out:
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
deleted file mode 100644
index d5ce34a..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ /dev/null
@@ -1,283 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <sys/types.h>
-#include <libudev.h>
-
-#include <errno.h>
-#include <stdbool.h>
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#include <getopt.h>
-#include <netdb.h>
-#include <unistd.h>
-
-#include "usbip_common.h"
-#include "usbip_network.h"
-#include "usbip.h"
-
-static const char usbip_list_usage_string[] =
-	"usbip list [-p|--parsable] <args>\n"
-	"    -p, --parsable         Parsable list format\n"
-	"    -r, --remote=<host>    List the exportable USB devices on <host>\n"
-	"    -l, --local            List the local USB devices\n";
-
-void usbip_list_usage(void)
-{
-	printf("usage: %s", usbip_list_usage_string);
-}
-
-static int get_exported_devices(char *host, int sockfd)
-{
-	char product_name[100];
-	char class_name[100];
-	struct op_devlist_reply reply;
-	uint16_t code = OP_REP_DEVLIST;
-	struct usbip_usb_device udev;
-	struct usbip_usb_interface uintf;
-	unsigned int i;
-	int rc, j;
-
-	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if (rc < 0) {
-		dbg("usbip_net_send_op_common failed");
-		return -1;
-	}
-
-	rc = usbip_net_recv_op_common(sockfd, &code);
-	if (rc < 0) {
-		dbg("usbip_net_recv_op_common failed");
-		return -1;
-	}
-
-	memset(&reply, 0, sizeof(reply));
-	rc = usbip_net_recv(sockfd, &reply, sizeof(reply));
-	if (rc < 0) {
-		dbg("usbip_net_recv_op_devlist failed");
-		return -1;
-	}
-	PACK_OP_DEVLIST_REPLY(0, &reply);
-	dbg("exportable devices: %d\n", reply.ndev);
-
-	if (reply.ndev == 0) {
-		info("no exportable devices found on %s", host);
-		return 0;
-	}
-
-	printf("Exportable USB devices\n");
-	printf("======================\n");
-	printf(" - %s\n", host);
-
-	for (i = 0; i < reply.ndev; i++) {
-		memset(&udev, 0, sizeof(udev));
-		rc = usbip_net_recv(sockfd, &udev, sizeof(udev));
-		if (rc < 0) {
-			dbg("usbip_net_recv failed: usbip_usb_device[%d]", i);
-			return -1;
-		}
-		usbip_net_pack_usb_device(0, &udev);
-
-		usbip_names_get_product(product_name, sizeof(product_name),
-					udev.idVendor, udev.idProduct);
-		usbip_names_get_class(class_name, sizeof(class_name),
-				      udev.bDeviceClass, udev.bDeviceSubClass,
-				      udev.bDeviceProtocol);
-		printf("%11s: %s\n", udev.busid, product_name);
-		printf("%11s: %s\n", "", udev.path);
-		printf("%11s: %s\n", "", class_name);
-
-		for (j = 0; j < udev.bNumInterfaces; j++) {
-			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
-			if (rc < 0) {
-				err("usbip_net_recv failed: usbip_usb_intf[%d]",
-						j);
-
-				return -1;
-			}
-			usbip_net_pack_usb_interface(0, &uintf);
-
-			usbip_names_get_class(class_name, sizeof(class_name),
-					uintf.bInterfaceClass,
-					uintf.bInterfaceSubClass,
-					uintf.bInterfaceProtocol);
-			printf("%11s: %2d - %s\n", "", j, class_name);
-		}
-
-		printf("\n");
-	}
-
-	return 0;
-}
-
-static int list_exported_devices(char *host)
-{
-	int rc;
-	int sockfd;
-
-	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
-	if (sockfd < 0) {
-		err("could not connect to %s:%s: %s", host,
-		    usbip_port_string, gai_strerror(sockfd));
-		return -1;
-	}
-	dbg("connected to %s:%s", host, usbip_port_string);
-
-	rc = get_exported_devices(host, sockfd);
-	if (rc < 0) {
-		err("failed to get device list from %s", host);
-		return -1;
-	}
-
-	close(sockfd);
-
-	return 0;
-}
-
-static void print_device(const char *busid, const char *vendor,
-			 const char *product, bool parsable)
-{
-	if (parsable)
-		printf("busid=%s#usbid=%.4s:%.4s#", busid, vendor, product);
-	else
-		printf(" - busid %s (%.4s:%.4s)\n", busid, vendor, product);
-}
-
-static void print_product_name(char *product_name, bool parsable)
-{
-	if (!parsable)
-		printf("   %s\n", product_name);
-}
-
-static int list_devices(bool parsable)
-{
-	struct udev *udev;
-	struct udev_enumerate *enumerate;
-	struct udev_list_entry *devices, *dev_list_entry;
-	struct udev_device *dev;
-	const char *path;
-	const char *idVendor;
-	const char *idProduct;
-	const char *bConfValue;
-	const char *bNumIntfs;
-	const char *busid;
-	char product_name[128];
-	int ret = -1;
-
-	/* Create libudev context. */
-	udev = udev_new();
-
-	/* Create libudev device enumeration. */
-	enumerate = udev_enumerate_new(udev);
-
-	/* Take only USB devices that are not hubs and do not have
-	 * the bInterfaceNumber attribute, i.e. are not interfaces.
-	 */
-	udev_enumerate_add_match_subsystem(enumerate, "usb");
-	udev_enumerate_add_nomatch_sysattr(enumerate, "bDeviceClass", "09");
-	udev_enumerate_add_nomatch_sysattr(enumerate, "bInterfaceNumber", NULL);
-	udev_enumerate_scan_devices(enumerate);
-
-	devices = udev_enumerate_get_list_entry(enumerate);
-
-	/* Show information about each device. */
-	udev_list_entry_foreach(dev_list_entry, devices) {
-		path = udev_list_entry_get_name(dev_list_entry);
-		dev = udev_device_new_from_syspath(udev, path);
-
-		/* Get device information. */
-		idVendor = udev_device_get_sysattr_value(dev, "idVendor");
-		idProduct = udev_device_get_sysattr_value(dev, "idProduct");
-		bConfValue = udev_device_get_sysattr_value(dev, "bConfigurationValue");
-		bNumIntfs = udev_device_get_sysattr_value(dev, "bNumInterfaces");
-		busid = udev_device_get_sysname(dev);
-		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs) {
-			err("problem getting device attributes: %s",
-			    strerror(errno));
-			goto err_out;
-		}
-
-		/* Get product name. */
-		usbip_names_get_product(product_name, sizeof(product_name),
-					strtol(idVendor, NULL, 16),
-					strtol(idProduct, NULL, 16));
-
-		/* Print information. */
-		print_device(busid, idVendor, idProduct, parsable);
-		print_product_name(product_name, parsable);
-
-		printf("\n");
-
-		udev_device_unref(dev);
-	}
-
-	ret = 0;
-
-err_out:
-	udev_enumerate_unref(enumerate);
-	udev_unref(udev);
-
-	return ret;
-}
-
-int usbip_list(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "parsable", no_argument,       NULL, 'p' },
-		{ "remote",   required_argument, NULL, 'r' },
-		{ "local",    no_argument,       NULL, 'l' },
-		{ NULL,       0,                 NULL,  0  }
-	};
-
-	bool parsable = false;
-	int opt;
-	int ret = -1;
-
-	if (usbip_names_init(USBIDS_FILE))
-		err("failed to open %s", USBIDS_FILE);
-
-	for (;;) {
-		opt = getopt_long(argc, argv, "pr:l", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'p':
-			parsable = true;
-			break;
-		case 'r':
-			ret = list_exported_devices(optarg);
-			goto out;
-		case 'l':
-			ret = list_devices(parsable);
-			goto out;
-		default:
-			goto err_out;
-		}
-	}
-
-err_out:
-	usbip_list_usage();
-out:
-	usbip_names_free();
-
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
deleted file mode 100644
index b4c37e7..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ /dev/null
@@ -1,303 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <sys/socket.h>
-
-#include <string.h>
-
-#include <arpa/inet.h>
-#include <netdb.h>
-#include <netinet/tcp.h>
-#include <unistd.h>
-
-#ifdef HAVE_LIBWRAP
-#include <tcpd.h>
-#endif
-
-#include "usbip_common.h"
-#include "usbip_network.h"
-
-int usbip_port = 3240;
-char *usbip_port_string = "3240";
-
-void usbip_setup_port_number(char *arg)
-{
-	dbg("parsing port arg '%s'", arg);
-	char *end;
-	unsigned long int port = strtoul(arg, &end, 10);
-
-	if (end == arg) {
-		err("port: could not parse '%s' as a decimal integer", arg);
-		return;
-	}
-
-	if (*end != '\0') {
-		err("port: garbage at end of '%s'", arg);
-		return;
-	}
-
-	if (port > UINT16_MAX) {
-		err("port: %s too high (max=%d)",
-		    arg, UINT16_MAX);
-		return;
-	}
-
-	usbip_port = port;
-	usbip_port_string = arg;
-	info("using port %d (\"%s\")", usbip_port, usbip_port_string);
-}
-
-void usbip_net_pack_uint32_t(int pack, uint32_t *num)
-{
-	uint32_t i;
-
-	if (pack)
-		i = htonl(*num);
-	else
-		i = ntohl(*num);
-
-	*num = i;
-}
-
-void usbip_net_pack_uint16_t(int pack, uint16_t *num)
-{
-	uint16_t i;
-
-	if (pack)
-		i = htons(*num);
-	else
-		i = ntohs(*num);
-
-	*num = i;
-}
-
-void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev)
-{
-	usbip_net_pack_uint32_t(pack, &udev->busnum);
-	usbip_net_pack_uint32_t(pack, &udev->devnum);
-	usbip_net_pack_uint32_t(pack, &udev->speed);
-
-	usbip_net_pack_uint16_t(pack, &udev->idVendor);
-	usbip_net_pack_uint16_t(pack, &udev->idProduct);
-	usbip_net_pack_uint16_t(pack, &udev->bcdDevice);
-}
-
-void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
-				  struct usbip_usb_interface *udev
-				  __attribute__((unused)))
-{
-	/* uint8_t members need nothing */
-}
-
-static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
-			      int sending)
-{
-	ssize_t nbytes;
-	ssize_t total = 0;
-
-	if (!bufflen)
-		return 0;
-
-	do {
-		if (sending)
-			nbytes = send(sockfd, buff, bufflen, 0);
-		else
-			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
-
-		if (nbytes <= 0)
-			return -1;
-
-		buff	 = (void *)((intptr_t) buff + nbytes);
-		bufflen	-= nbytes;
-		total	+= nbytes;
-
-	} while (bufflen > 0);
-
-	return total;
-}
-
-ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen)
-{
-	return usbip_net_xmit(sockfd, buff, bufflen, 0);
-}
-
-ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen)
-{
-	return usbip_net_xmit(sockfd, buff, bufflen, 1);
-}
-
-int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
-{
-	struct op_common op_common;
-	int rc;
-
-	memset(&op_common, 0, sizeof(op_common));
-
-	op_common.version = USBIP_VERSION;
-	op_common.code    = code;
-	op_common.status  = status;
-
-	PACK_OP_COMMON(1, &op_common);
-
-	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
-	if (rc < 0) {
-		dbg("usbip_net_send failed: %d", rc);
-		return -1;
-	}
-
-	return 0;
-}
-
-int usbip_net_recv_op_common(int sockfd, uint16_t *code)
-{
-	struct op_common op_common;
-	int rc;
-
-	memset(&op_common, 0, sizeof(op_common));
-
-	rc = usbip_net_recv(sockfd, &op_common, sizeof(op_common));
-	if (rc < 0) {
-		dbg("usbip_net_recv failed: %d", rc);
-		goto err;
-	}
-
-	PACK_OP_COMMON(0, &op_common);
-
-	if (op_common.version != USBIP_VERSION) {
-		dbg("version mismatch: %d %d", op_common.version,
-		    USBIP_VERSION);
-		goto err;
-	}
-
-	switch (*code) {
-	case OP_UNSPEC:
-		break;
-	default:
-		if (op_common.code != *code) {
-			dbg("unexpected pdu %#0x for %#0x", op_common.code,
-			    *code);
-			goto err;
-		}
-	}
-
-	if (op_common.status != ST_OK) {
-		dbg("request failed at peer: %d", op_common.status);
-		goto err;
-	}
-
-	*code = op_common.code;
-
-	return 0;
-err:
-	return -1;
-}
-
-int usbip_net_set_reuseaddr(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
-	if (ret < 0)
-		dbg("setsockopt: SO_REUSEADDR");
-
-	return ret;
-}
-
-int usbip_net_set_nodelay(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
-	if (ret < 0)
-		dbg("setsockopt: TCP_NODELAY");
-
-	return ret;
-}
-
-int usbip_net_set_keepalive(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &val, sizeof(val));
-	if (ret < 0)
-		dbg("setsockopt: SO_KEEPALIVE");
-
-	return ret;
-}
-
-int usbip_net_set_v6only(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, IPPROTO_IPV6, IPV6_V6ONLY, &val, sizeof(val));
-	if (ret < 0)
-		dbg("setsockopt: IPV6_V6ONLY");
-
-	return ret;
-}
-
-/*
- * IPv6 Ready
- */
-int usbip_net_tcp_connect(char *hostname, char *service)
-{
-	struct addrinfo hints, *res, *rp;
-	int sockfd;
-	int ret;
-
-	memset(&hints, 0, sizeof(hints));
-	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = SOCK_STREAM;
-
-	/* get all possible addresses */
-	ret = getaddrinfo(hostname, service, &hints, &res);
-	if (ret < 0) {
-		dbg("getaddrinfo: %s service %s: %s", hostname, service,
-		    gai_strerror(ret));
-		return ret;
-	}
-
-	/* try the addresses */
-	for (rp = res; rp; rp = rp->ai_next) {
-		sockfd = socket(rp->ai_family, rp->ai_socktype,
-				rp->ai_protocol);
-		if (sockfd < 0)
-			continue;
-
-		/* should set TCP_NODELAY for usbip */
-		usbip_net_set_nodelay(sockfd);
-		/* TODO: write code for heartbeat */
-		usbip_net_set_keepalive(sockfd);
-
-		if (connect(sockfd, rp->ai_addr, rp->ai_addrlen) == 0)
-			break;
-
-		close(sockfd);
-	}
-
-	freeaddrinfo(res);
-
-	if (!rp)
-		return EAI_SYSTEM;
-
-	return sockfd;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
deleted file mode 100644
index c1e875c..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef __USBIP_NETWORK_H
-#define __USBIP_NETWORK_H
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include <sys/types.h>
-
-#include <stdint.h>
-
-extern int usbip_port;
-extern char *usbip_port_string;
-void usbip_setup_port_number(char *arg);
-
-/* ---------------------------------------------------------------------- */
-/* Common header for all the kinds of PDUs. */
-struct op_common {
-	uint16_t version;
-
-#define OP_REQUEST	(0x80 << 8)
-#define OP_REPLY	(0x00 << 8)
-	uint16_t code;
-
-	/* add more error code */
-#define ST_OK	0x00
-#define ST_NA	0x01
-	uint32_t status; /* op_code status (for reply) */
-
-} __attribute__((packed));
-
-#define PACK_OP_COMMON(pack, op_common)  do {\
-	usbip_net_pack_uint16_t(pack, &(op_common)->version);\
-	usbip_net_pack_uint16_t(pack, &(op_common)->code);\
-	usbip_net_pack_uint32_t(pack, &(op_common)->status);\
-} while (0)
-
-/* ---------------------------------------------------------------------- */
-/* Dummy Code */
-#define OP_UNSPEC	0x00
-#define OP_REQ_UNSPEC	OP_UNSPEC
-#define OP_REP_UNSPEC	OP_UNSPEC
-
-/* ---------------------------------------------------------------------- */
-/* Retrieve USB device information. (still not used) */
-#define OP_DEVINFO	0x02
-#define OP_REQ_DEVINFO	(OP_REQUEST | OP_DEVINFO)
-#define OP_REP_DEVINFO	(OP_REPLY   | OP_DEVINFO)
-
-struct op_devinfo_request {
-	char busid[SYSFS_BUS_ID_SIZE];
-} __attribute__((packed));
-
-struct op_devinfo_reply {
-	struct usbip_usb_device udev;
-	struct usbip_usb_interface uinf[];
-} __attribute__((packed));
-
-/* ---------------------------------------------------------------------- */
-/* Import a remote USB device. */
-#define OP_IMPORT	0x03
-#define OP_REQ_IMPORT	(OP_REQUEST | OP_IMPORT)
-#define OP_REP_IMPORT   (OP_REPLY   | OP_IMPORT)
-
-struct op_import_request {
-	char busid[SYSFS_BUS_ID_SIZE];
-} __attribute__((packed));
-
-struct op_import_reply {
-	struct usbip_usb_device udev;
-//	struct usbip_usb_interface uinf[];
-} __attribute__((packed));
-
-#define PACK_OP_IMPORT_REQUEST(pack, request)  do {\
-} while (0)
-
-#define PACK_OP_IMPORT_REPLY(pack, reply)  do {\
-	usbip_net_pack_usb_device(pack, &(reply)->udev);\
-} while (0)
-
-/* ---------------------------------------------------------------------- */
-/* Export a USB device to a remote host. */
-#define OP_EXPORT	0x06
-#define OP_REQ_EXPORT	(OP_REQUEST | OP_EXPORT)
-#define OP_REP_EXPORT	(OP_REPLY   | OP_EXPORT)
-
-struct op_export_request {
-	struct usbip_usb_device udev;
-} __attribute__((packed));
-
-struct op_export_reply {
-	int returncode;
-} __attribute__((packed));
-
-
-#define PACK_OP_EXPORT_REQUEST(pack, request)  do {\
-	usbip_net_pack_usb_device(pack, &(request)->udev);\
-} while (0)
-
-#define PACK_OP_EXPORT_REPLY(pack, reply)  do {\
-} while (0)
-
-/* ---------------------------------------------------------------------- */
-/* un-Export a USB device from a remote host. */
-#define OP_UNEXPORT	0x07
-#define OP_REQ_UNEXPORT	(OP_REQUEST | OP_UNEXPORT)
-#define OP_REP_UNEXPORT	(OP_REPLY   | OP_UNEXPORT)
-
-struct op_unexport_request {
-	struct usbip_usb_device udev;
-} __attribute__((packed));
-
-struct op_unexport_reply {
-	int returncode;
-} __attribute__((packed));
-
-#define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
-	usbip_net_pack_usb_device(pack, &(request)->udev);\
-} while (0)
-
-#define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
-} while (0)
-
-/* ---------------------------------------------------------------------- */
-/* Negotiate IPSec encryption key. (still not used) */
-#define OP_CRYPKEY	0x04
-#define OP_REQ_CRYPKEY	(OP_REQUEST | OP_CRYPKEY)
-#define OP_REP_CRYPKEY	(OP_REPLY   | OP_CRYPKEY)
-
-struct op_crypkey_request {
-	/* 128bit key */
-	uint32_t key[4];
-} __attribute__((packed));
-
-struct op_crypkey_reply {
-	uint32_t __reserved;
-} __attribute__((packed));
-
-
-/* ---------------------------------------------------------------------- */
-/* Retrieve the list of exported USB devices. */
-#define OP_DEVLIST	0x05
-#define OP_REQ_DEVLIST	(OP_REQUEST | OP_DEVLIST)
-#define OP_REP_DEVLIST	(OP_REPLY   | OP_DEVLIST)
-
-struct op_devlist_request {
-} __attribute__((packed));
-
-struct op_devlist_reply {
-	uint32_t ndev;
-	/* followed by reply_extra[] */
-} __attribute__((packed));
-
-struct op_devlist_reply_extra {
-	struct usbip_usb_device    udev;
-	struct usbip_usb_interface uinf[];
-} __attribute__((packed));
-
-#define PACK_OP_DEVLIST_REQUEST(pack, request)  do {\
-} while (0)
-
-#define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
-	usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
-} while (0)
-
-void usbip_net_pack_uint32_t(int pack, uint32_t *num);
-void usbip_net_pack_uint16_t(int pack, uint16_t *num);
-void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
-void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
-
-ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen);
-ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen);
-int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status);
-int usbip_net_recv_op_common(int sockfd, uint16_t *code);
-int usbip_net_set_reuseaddr(int sockfd);
-int usbip_net_set_nodelay(int sockfd);
-int usbip_net_set_keepalive(int sockfd);
-int usbip_net_set_v6only(int sockfd);
-int usbip_net_tcp_connect(char *hostname, char *port);
-
-#endif /* __USBIP_NETWORK_H */
diff --git a/drivers/staging/usbip/userspace/src/usbip_port.c b/drivers/staging/usbip/userspace/src/usbip_port.c
deleted file mode 100644
index 52aa168..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_port.c
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-#include "vhci_driver.h"
-#include "usbip_common.h"
-
-static int list_imported_devices()
-{
-	int i;
-	struct usbip_imported_device *idev;
-	int ret;
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	printf("Imported USB devices\n");
-	printf("====================\n");
-
-	for (i = 0; i < vhci_driver->nports; i++) {
-		idev = &vhci_driver->idev[i];
-
-		if (usbip_vhci_imported_device_dump(idev) < 0)
-			ret = -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return ret;
-
-}
-
-int usbip_port_show(__attribute__((unused)) int argc,
-		    __attribute__((unused)) char *argv[])
-{
-	int ret;
-
-	ret = list_imported_devices();
-	if (ret < 0)
-		err("list imported devices");
-
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
deleted file mode 100644
index a4a496c..0000000
--- a/drivers/staging/usbip/userspace/src/usbip_unbind.c
+++ /dev/null
@@ -1,141 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <libudev.h>
-
-#include <errno.h>
-#include <stdio.h>
-#include <string.h>
-
-#include <getopt.h>
-
-#include "usbip_common.h"
-#include "utils.h"
-#include "usbip.h"
-#include "sysfs_utils.h"
-
-static const char usbip_unbind_usage_string[] =
-	"usbip unbind <args>\n"
-	"    -b, --busid=<busid>    Unbind " USBIP_HOST_DRV_NAME ".ko from "
-	"device on <busid>\n";
-
-void usbip_unbind_usage(void)
-{
-	printf("usage: %s", usbip_unbind_usage_string);
-}
-
-static int unbind_device(char *busid)
-{
-	char bus_type[] = "usb";
-	int rc, ret = -1;
-
-	char unbind_attr_name[] = "unbind";
-	char unbind_attr_path[SYSFS_PATH_MAX];
-	char rebind_attr_name[] = "rebind";
-	char rebind_attr_path[SYSFS_PATH_MAX];
-
-	struct udev *udev;
-	struct udev_device *dev;
-	const char *driver;
-
-	/* Create libudev context. */
-	udev = udev_new();
-
-	/* Check whether the device with this bus ID exists. */
-	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
-	if (!dev) {
-		err("device with the specified bus ID does not exist");
-		goto err_close_udev;
-	}
-
-	/* Check whether the device is using usbip-host driver. */
-	driver = udev_device_get_driver(dev);
-	if (!driver || strcmp(driver, "usbip-host")) {
-		err("device is not bound to usbip-host driver");
-		goto err_close_udev;
-	}
-
-	/* Unbind device from driver. */
-	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
-		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
-		 USBIP_HOST_DRV_NAME, unbind_attr_name);
-
-	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
-	if (rc < 0) {
-		err("error unbinding device %s from driver", busid);
-		goto err_close_udev;
-	}
-
-	/* Notify driver of unbind. */
-	rc = modify_match_busid(busid, 0);
-	if (rc < 0) {
-		err("unable to unbind device on %s", busid);
-		goto err_close_udev;
-	}
-
-	/* Trigger new probing. */
-	snprintf(rebind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
-			SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
-			USBIP_HOST_DRV_NAME, rebind_attr_name);
-
-	rc = write_sysfs_attribute(rebind_attr_path, busid, strlen(busid));
-	if (rc < 0) {
-		err("error rebinding");
-		goto err_close_udev;
-	}
-
-	ret = 0;
-	info("unbind device on busid %s: complete", busid);
-
-err_close_udev:
-	udev_device_unref(dev);
-	udev_unref(udev);
-
-	return ret;
-}
-
-int usbip_unbind(int argc, char *argv[])
-{
-	static const struct option opts[] = {
-		{ "busid", required_argument, NULL, 'b' },
-		{ NULL,    0,                 NULL,  0  }
-	};
-
-	int opt;
-	int ret = -1;
-
-	for (;;) {
-		opt = getopt_long(argc, argv, "b:", opts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case 'b':
-			ret = unbind_device(optarg);
-			goto out;
-		default:
-			goto err_out;
-		}
-	}
-
-err_out:
-	usbip_unbind_usage();
-out:
-	return ret;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
deleted file mode 100644
index 2cae4ce..0000000
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ /dev/null
@@ -1,675 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#define _GNU_SOURCE
-#include <errno.h>
-#include <unistd.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <arpa/inet.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-
-#ifdef HAVE_LIBWRAP
-#include <tcpd.h>
-#endif
-
-#include <getopt.h>
-#include <signal.h>
-#include <poll.h>
-
-#include "usbip_host_driver.h"
-#include "usbip_common.h"
-#include "usbip_network.h"
-#include "list.h"
-
-#undef  PROGNAME
-#define PROGNAME "usbipd"
-#define MAXSOCKFD 20
-
-#define MAIN_LOOP_TIMEOUT 10
-
-#define DEFAULT_PID_FILE "/var/run/" PROGNAME ".pid"
-
-static const char usbip_version_string[] = PACKAGE_STRING;
-
-static const char usbipd_help_string[] =
-	"usage: usbipd [options]\n"
-	"\n"
-	"	-4, --ipv4\n"
-	"		Bind to IPv4. Default is both.\n"
-	"\n"
-	"	-6, --ipv6\n"
-	"		Bind to IPv6. Default is both.\n"
-	"\n"
-	"	-D, --daemon\n"
-	"		Run as a daemon process.\n"
-	"\n"
-	"	-d, --debug\n"
-	"		Print debugging information.\n"
-	"\n"
-	"	-PFILE, --pid FILE\n"
-	"		Write process id to FILE.\n"
-	"		If no FILE specified, use " DEFAULT_PID_FILE "\n"
-	"\n"
-	"	-tPORT, --tcp-port PORT\n"
-	"		Listen on TCP/IP port PORT.\n"
-	"\n"
-	"	-h, --help\n"
-	"		Print this help.\n"
-	"\n"
-	"	-v, --version\n"
-	"		Show version.\n";
-
-static void usbipd_help(void)
-{
-	printf("%s\n", usbipd_help_string);
-}
-
-static int recv_request_import(int sockfd)
-{
-	struct op_import_request req;
-	struct op_common reply;
-	struct usbip_exported_device *edev;
-	struct usbip_usb_device pdu_udev;
-	struct list_head *i;
-	int found = 0;
-	int error = 0;
-	int rc;
-
-	memset(&req, 0, sizeof(req));
-	memset(&reply, 0, sizeof(reply));
-
-	rc = usbip_net_recv(sockfd, &req, sizeof(req));
-	if (rc < 0) {
-		dbg("usbip_net_recv failed: import request");
-		return -1;
-	}
-	PACK_OP_IMPORT_REQUEST(0, &req);
-
-	list_for_each(i, &host_driver->edev_list) {
-		edev = list_entry(i, struct usbip_exported_device, node);
-		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
-			info("found requested device: %s", req.busid);
-			found = 1;
-			break;
-		}
-	}
-
-	if (found) {
-		/* should set TCP_NODELAY for usbip */
-		usbip_net_set_nodelay(sockfd);
-
-		/* export device needs a TCP/IP socket descriptor */
-		rc = usbip_host_export_device(edev, sockfd);
-		if (rc < 0)
-			error = 1;
-	} else {
-		info("requested device not found: %s", req.busid);
-		error = 1;
-	}
-
-	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT,
-				      (!error ? ST_OK : ST_NA));
-	if (rc < 0) {
-		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_IMPORT);
-		return -1;
-	}
-
-	if (error) {
-		dbg("import request busid %s: failed", req.busid);
-		return -1;
-	}
-
-	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-	usbip_net_pack_usb_device(1, &pdu_udev);
-
-	rc = usbip_net_send(sockfd, &pdu_udev, sizeof(pdu_udev));
-	if (rc < 0) {
-		dbg("usbip_net_send failed: devinfo");
-		return -1;
-	}
-
-	dbg("import request busid %s: complete", req.busid);
-
-	return 0;
-}
-
-static int send_reply_devlist(int connfd)
-{
-	struct usbip_exported_device *edev;
-	struct usbip_usb_device pdu_udev;
-	struct usbip_usb_interface pdu_uinf;
-	struct op_devlist_reply reply;
-	struct list_head *j;
-	int rc, i;
-
-	reply.ndev = 0;
-	/* number of exported devices */
-	list_for_each(j, &host_driver->edev_list) {
-		reply.ndev += 1;
-	}
-	info("exportable devices: %d", reply.ndev);
-
-	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
-	if (rc < 0) {
-		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_DEVLIST);
-		return -1;
-	}
-	PACK_OP_DEVLIST_REPLY(1, &reply);
-
-	rc = usbip_net_send(connfd, &reply, sizeof(reply));
-	if (rc < 0) {
-		dbg("usbip_net_send failed: %#0x", OP_REP_DEVLIST);
-		return -1;
-	}
-
-	list_for_each(j, &host_driver->edev_list) {
-		edev = list_entry(j, struct usbip_exported_device, node);
-		dump_usb_device(&edev->udev);
-		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-		usbip_net_pack_usb_device(1, &pdu_udev);
-
-		rc = usbip_net_send(connfd, &pdu_udev, sizeof(pdu_udev));
-		if (rc < 0) {
-			dbg("usbip_net_send failed: pdu_udev");
-			return -1;
-		}
-
-		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
-			dump_usb_interface(&edev->uinf[i]);
-			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
-			usbip_net_pack_usb_interface(1, &pdu_uinf);
-
-			rc = usbip_net_send(connfd, &pdu_uinf,
-					sizeof(pdu_uinf));
-			if (rc < 0) {
-				err("usbip_net_send failed: pdu_uinf");
-				return -1;
-			}
-		}
-	}
-
-	return 0;
-}
-
-static int recv_request_devlist(int connfd)
-{
-	struct op_devlist_request req;
-	int rc;
-
-	memset(&req, 0, sizeof(req));
-
-	rc = usbip_net_recv(connfd, &req, sizeof(req));
-	if (rc < 0) {
-		dbg("usbip_net_recv failed: devlist request");
-		return -1;
-	}
-
-	rc = send_reply_devlist(connfd);
-	if (rc < 0) {
-		dbg("send_reply_devlist failed");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int recv_pdu(int connfd)
-{
-	uint16_t code = OP_UNSPEC;
-	int ret;
-
-	ret = usbip_net_recv_op_common(connfd, &code);
-	if (ret < 0) {
-		dbg("could not receive opcode: %#0x", code);
-		return -1;
-	}
-
-	ret = usbip_host_refresh_device_list();
-	if (ret < 0) {
-		dbg("could not refresh device list: %d", ret);
-		return -1;
-	}
-
-	info("received request: %#0x(%d)", code, connfd);
-	switch (code) {
-	case OP_REQ_DEVLIST:
-		ret = recv_request_devlist(connfd);
-		break;
-	case OP_REQ_IMPORT:
-		ret = recv_request_import(connfd);
-		break;
-	case OP_REQ_DEVINFO:
-	case OP_REQ_CRYPKEY:
-	default:
-		err("received an unknown opcode: %#0x", code);
-		ret = -1;
-	}
-
-	if (ret == 0)
-		info("request %#0x(%d): complete", code, connfd);
-	else
-		info("request %#0x(%d): failed", code, connfd);
-
-	return ret;
-}
-
-#ifdef HAVE_LIBWRAP
-static int tcpd_auth(int connfd)
-{
-	struct request_info request;
-	int rc;
-
-	request_init(&request, RQ_DAEMON, PROGNAME, RQ_FILE, connfd, 0);
-	fromhost(&request);
-	rc = hosts_access(&request);
-	if (rc == 0)
-		return -1;
-
-	return 0;
-}
-#endif
-
-static int do_accept(int listenfd)
-{
-	int connfd;
-	struct sockaddr_storage ss;
-	socklen_t len = sizeof(ss);
-	char host[NI_MAXHOST], port[NI_MAXSERV];
-	int rc;
-
-	memset(&ss, 0, sizeof(ss));
-
-	connfd = accept(listenfd, (struct sockaddr *)&ss, &len);
-	if (connfd < 0) {
-		err("failed to accept connection");
-		return -1;
-	}
-
-	rc = getnameinfo((struct sockaddr *)&ss, len, host, sizeof(host),
-			 port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
-	if (rc)
-		err("getnameinfo: %s", gai_strerror(rc));
-
-#ifdef HAVE_LIBWRAP
-	rc = tcpd_auth(connfd);
-	if (rc < 0) {
-		info("denied access from %s", host);
-		close(connfd);
-		return -1;
-	}
-#endif
-	info("connection from %s:%s", host, port);
-
-	return connfd;
-}
-
-int process_request(int listenfd)
-{
-	pid_t childpid;
-	int connfd;
-
-	connfd = do_accept(listenfd);
-	if (connfd < 0)
-		return -1;
-	childpid = fork();
-	if (childpid == 0) {
-		close(listenfd);
-		recv_pdu(connfd);
-		exit(0);
-	}
-	close(connfd);
-	return 0;
-}
-
-static void addrinfo_to_text(struct addrinfo *ai, char buf[],
-			     const size_t buf_size)
-{
-	char hbuf[NI_MAXHOST];
-	char sbuf[NI_MAXSERV];
-	int rc;
-
-	buf[0] = '\0';
-
-	rc = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
-			 sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
-	if (rc)
-		err("getnameinfo: %s", gai_strerror(rc));
-
-	snprintf(buf, buf_size, "%s:%s", hbuf, sbuf);
-}
-
-static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[],
-			     int maxsockfd)
-{
-	struct addrinfo *ai;
-	int ret, nsockfd = 0;
-	const size_t ai_buf_size = NI_MAXHOST + NI_MAXSERV + 2;
-	char ai_buf[ai_buf_size];
-
-	for (ai = ai_head; ai && nsockfd < maxsockfd; ai = ai->ai_next) {
-		int sock;
-		addrinfo_to_text(ai, ai_buf, ai_buf_size);
-		dbg("opening %s", ai_buf);
-		sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
-		if (sock < 0) {
-			err("socket: %s: %d (%s)",
-			    ai_buf, errno, strerror(errno));
-			continue;
-		}
-
-		usbip_net_set_reuseaddr(sock);
-		usbip_net_set_nodelay(sock);
-		/* We use seperate sockets for IPv4 and IPv6
-		 * (see do_standalone_mode()) */
-		usbip_net_set_v6only(sock);
-
-		if (sock >= FD_SETSIZE) {
-			err("FD_SETSIZE: %s: sock=%d, max=%d",
-			    ai_buf, sock, FD_SETSIZE);
-			close(sock);
-			continue;
-		}
-
-		ret = bind(sock, ai->ai_addr, ai->ai_addrlen);
-		if (ret < 0) {
-			err("bind: %s: %d (%s)",
-			    ai_buf, errno, strerror(errno));
-			close(sock);
-			continue;
-		}
-
-		ret = listen(sock, SOMAXCONN);
-		if (ret < 0) {
-			err("listen: %s: %d (%s)",
-			    ai_buf, errno, strerror(errno));
-			close(sock);
-			continue;
-		}
-
-		info("listening on %s", ai_buf);
-		sockfdlist[nsockfd++] = sock;
-	}
-
-	return nsockfd;
-}
-
-static struct addrinfo *do_getaddrinfo(char *host, int ai_family)
-{
-	struct addrinfo hints, *ai_head;
-	int rc;
-
-	memset(&hints, 0, sizeof(hints));
-	hints.ai_family   = ai_family;
-	hints.ai_socktype = SOCK_STREAM;
-	hints.ai_flags    = AI_PASSIVE;
-
-	rc = getaddrinfo(host, usbip_port_string, &hints, &ai_head);
-	if (rc) {
-		err("failed to get a network address %s: %s", usbip_port_string,
-		    gai_strerror(rc));
-		return NULL;
-	}
-
-	return ai_head;
-}
-
-static void signal_handler(int i)
-{
-	dbg("received '%s' signal", strsignal(i));
-}
-
-static void set_signal(void)
-{
-	struct sigaction act;
-
-	memset(&act, 0, sizeof(act));
-	act.sa_handler = signal_handler;
-	sigemptyset(&act.sa_mask);
-	sigaction(SIGTERM, &act, NULL);
-	sigaction(SIGINT, &act, NULL);
-	act.sa_handler = SIG_IGN;
-	sigaction(SIGCLD, &act, NULL);
-}
-
-static const char *pid_file;
-
-static void write_pid_file()
-{
-	if (pid_file) {
-		dbg("creating pid file %s", pid_file);
-		FILE *fp = fopen(pid_file, "w");
-		if (!fp) {
-			err("pid_file: %s: %d (%s)",
-			    pid_file, errno, strerror(errno));
-			return;
-		}
-		fprintf(fp, "%d\n", getpid());
-		fclose(fp);
-	}
-}
-
-static void remove_pid_file()
-{
-	if (pid_file) {
-		dbg("removing pid file %s", pid_file);
-		unlink(pid_file);
-	}
-}
-
-static int do_standalone_mode(int daemonize, int ipv4, int ipv6)
-{
-	struct addrinfo *ai_head;
-	int sockfdlist[MAXSOCKFD];
-	int nsockfd, family;
-	int i, terminate;
-	struct pollfd *fds;
-	struct timespec timeout;
-	sigset_t sigmask;
-
-	if (usbip_host_driver_open()) {
-		err("please load " USBIP_CORE_MOD_NAME ".ko and "
-		    USBIP_HOST_DRV_NAME ".ko!");
-		return -1;
-	}
-
-	if (daemonize) {
-		if (daemon(0, 0) < 0) {
-			err("daemonizing failed: %s", strerror(errno));
-			usbip_host_driver_close();
-			return -1;
-		}
-		umask(0);
-		usbip_use_syslog = 1;
-	}
-	set_signal();
-	write_pid_file();
-
-	info("starting " PROGNAME " (%s)", usbip_version_string);
-
-	/*
-	 * To suppress warnings on systems with bindv6only disabled
-	 * (default), we use seperate sockets for IPv6 and IPv4 and set
-	 * IPV6_V6ONLY on the IPv6 sockets.
-	 */
-	if (ipv4 && ipv6)
-		family = AF_UNSPEC;
-	else if (ipv4)
-		family = AF_INET;
-	else
-		family = AF_INET6;
-
-	ai_head = do_getaddrinfo(NULL, family);
-	if (!ai_head) {
-		usbip_host_driver_close();
-		return -1;
-	}
-	nsockfd = listen_all_addrinfo(ai_head, sockfdlist,
-		sizeof(sockfdlist) / sizeof(*sockfdlist));
-	freeaddrinfo(ai_head);
-	if (nsockfd <= 0) {
-		err("failed to open a listening socket");
-		usbip_host_driver_close();
-		return -1;
-	}
-
-	dbg("listening on %d address%s", nsockfd, (nsockfd == 1) ? "" : "es");
-
-	fds = calloc(nsockfd, sizeof(struct pollfd));
-	for (i = 0; i < nsockfd; i++) {
-		fds[i].fd = sockfdlist[i];
-		fds[i].events = POLLIN;
-	}
-	timeout.tv_sec = MAIN_LOOP_TIMEOUT;
-	timeout.tv_nsec = 0;
-
-	sigfillset(&sigmask);
-	sigdelset(&sigmask, SIGTERM);
-	sigdelset(&sigmask, SIGINT);
-
-	terminate = 0;
-	while (!terminate) {
-		int r;
-
-		r = ppoll(fds, nsockfd, &timeout, &sigmask);
-		if (r < 0) {
-			dbg("%s", strerror(errno));
-			terminate = 1;
-		} else if (r) {
-			for (i = 0; i < nsockfd; i++) {
-				if (fds[i].revents & POLLIN) {
-					dbg("read event on fd[%d]=%d",
-					    i, sockfdlist[i]);
-					process_request(sockfdlist[i]);
-				}
-			}
-		} else {
-			dbg("heartbeat timeout on ppoll()");
-		}
-	}
-
-	info("shutting down " PROGNAME);
-	free(fds);
-	usbip_host_driver_close();
-
-	return 0;
-}
-
-int main(int argc, char *argv[])
-{
-	static const struct option longopts[] = {
-		{ "ipv4",     no_argument,       NULL, '4' },
-		{ "ipv6",     no_argument,       NULL, '6' },
-		{ "daemon",   no_argument,       NULL, 'D' },
-		{ "daemon",   no_argument,       NULL, 'D' },
-		{ "debug",    no_argument,       NULL, 'd' },
-		{ "pid",      optional_argument, NULL, 'P' },
-		{ "tcp-port", required_argument, NULL, 't' },
-		{ "help",     no_argument,       NULL, 'h' },
-		{ "version",  no_argument,       NULL, 'v' },
-		{ NULL,	      0,                 NULL,  0  }
-	};
-
-	enum {
-		cmd_standalone_mode = 1,
-		cmd_help,
-		cmd_version
-	} cmd;
-
-	int daemonize = 0;
-	int ipv4 = 0, ipv6 = 0;
-	int opt, rc = -1;
-	pid_file = NULL;
-
-	usbip_use_stderr = 1;
-	usbip_use_syslog = 0;
-
-	if (geteuid() != 0)
-		err("not running as root?");
-
-	cmd = cmd_standalone_mode;
-	for (;;) {
-		opt = getopt_long(argc, argv, "46DdP::t:hv", longopts, NULL);
-
-		if (opt == -1)
-			break;
-
-		switch (opt) {
-		case '4':
-			ipv4 = 1;
-			break;
-		case '6':
-			ipv6 = 1;
-			break;
-		case 'D':
-			daemonize = 1;
-			break;
-		case 'd':
-			usbip_use_debug = 1;
-			break;
-		case 'h':
-			cmd = cmd_help;
-			break;
-		case 'P':
-			pid_file = optarg ? optarg : DEFAULT_PID_FILE;
-			break;
-		case 't':
-			usbip_setup_port_number(optarg);
-			break;
-		case 'v':
-			cmd = cmd_version;
-			break;
-		case '?':
-			usbipd_help();
-		default:
-			goto err_out;
-		}
-	}
-
-	if (!ipv4 && !ipv6)
-		ipv4 = ipv6 = 1;
-
-	switch (cmd) {
-	case cmd_standalone_mode:
-		rc = do_standalone_mode(daemonize, ipv4, ipv6);
-		remove_pid_file();
-		break;
-	case cmd_version:
-		printf(PROGNAME " (%s)\n", usbip_version_string);
-		rc = 0;
-		break;
-	case cmd_help:
-		usbipd_help();
-		rc = 0;
-		break;
-	default:
-		usbipd_help();
-		goto err_out;
-	}
-
-err_out:
-	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
-}
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
deleted file mode 100644
index 2b3d6d2..0000000
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <errno.h>
-#include <stdio.h>
-#include <string.h>
-
-#include "usbip_common.h"
-#include "utils.h"
-#include "sysfs_utils.h"
-
-int modify_match_busid(char *busid, int add)
-{
-	char attr_name[] = "match_busid";
-	char command[SYSFS_BUS_ID_SIZE + 4];
-	char match_busid_attr_path[SYSFS_PATH_MAX];
-	int rc;
-
-	snprintf(match_busid_attr_path, sizeof(match_busid_attr_path),
-		 "%s/%s/%s/%s/%s/%s", SYSFS_MNT_PATH, SYSFS_BUS_NAME,
-		 SYSFS_BUS_TYPE, SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME,
-		 attr_name);
-
-	if (add)
-		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
-	else
-		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
-
-	rc = write_sysfs_attribute(match_busid_attr_path, command,
-				   sizeof(command));
-	if (rc < 0) {
-		dbg("failed to write match_busid: %s", strerror(errno));
-		return -1;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
deleted file mode 100644
index 5916fd3..0000000
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
- *               2005-2007 Takahiro Hirofuchi
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program. If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __UTILS_H
-#define __UTILS_H
-
-int modify_match_busid(char *busid, int add);
-
-#endif /* __UTILS_H */
-
diff --git a/tools/usb/usbip/.gitignore b/tools/usb/usbip/.gitignore
new file mode 100644
index 0000000..9aad9e3
--- /dev/null
+++ b/tools/usb/usbip/.gitignore
@@ -0,0 +1,28 @@
+Makefile
+Makefile.in
+aclocal.m4
+autom4te.cache/
+config.guess
+config.h
+config.h.in
+config.log
+config.status
+config.sub
+configure
+depcomp
+install-sh
+libsrc/Makefile
+libsrc/Makefile.in
+libtool
+ltmain.sh
+missing
+src/Makefile
+src/Makefile.in
+stamp-h1
+libsrc/libusbip.la
+libsrc/libusbip_la-names.lo
+libsrc/libusbip_la-usbip_common.lo
+libsrc/libusbip_la-usbip_host_driver.lo
+libsrc/libusbip_la-vhci_driver.lo
+src/usbip
+src/usbipd
diff --git a/tools/usb/usbip/AUTHORS b/tools/usb/usbip/AUTHORS
new file mode 100644
index 0000000..a27ea8d
--- /dev/null
+++ b/tools/usb/usbip/AUTHORS
@@ -0,0 +1,3 @@
+Takahiro Hirofuchi
+Robert Leibl
+matt mooney <mfm@muteddisk.com>
diff --git a/tools/usb/usbip/COPYING b/tools/usb/usbip/COPYING
new file mode 100644
index 0000000..c5611e4
--- /dev/null
+++ b/tools/usb/usbip/COPYING
@@ -0,0 +1,340 @@
+		    GNU GENERAL PUBLIC LICENSE
+		       Version 2, June 1991
+
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.
+     51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+			    Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+License is intended to guarantee your freedom to share and change free
+software--to make sure the software is free for all its users.  This
+General Public License applies to most of the Free Software
+Foundation's software and to any other program whose authors commit to
+using it.  (Some other Free Software Foundation software is covered by
+the GNU Library General Public License instead.)  You can apply it to
+your programs, too.
+
+  When we speak of free software, we are referring to freedom, not
+price.  Our General Public Licenses are designed to make sure that you
+have the freedom to distribute copies of free software (and charge for
+this service if you wish), that you receive source code or can get it
+if you want it, that you can change the software or use pieces of it
+in new free programs; and that you know you can do these things.
+
+  To protect your rights, we need to make restrictions that forbid
+anyone to deny you these rights or to ask you to surrender the rights.
+These restrictions translate to certain responsibilities for you if you
+distribute copies of the software, or if you modify it.
+
+  For example, if you distribute copies of such a program, whether
+gratis or for a fee, you must give the recipients all the rights that
+you have.  You must make sure that they, too, receive or can get the
+source code.  And you must show them these terms so they know their
+rights.
+
+  We protect your rights with two steps: (1) copyright the software, and
+(2) offer you this license which gives you legal permission to copy,
+distribute and/or modify the software.
+
+  Also, for each author's protection and ours, we want to make certain
+that everyone understands that there is no warranty for this free
+software.  If the software is modified by someone else and passed on, we
+want its recipients to know that what they have is not the original, so
+that any problems introduced by others will not reflect on the original
+authors' reputations.
+
+  Finally, any free program is threatened constantly by software
+patents.  We wish to avoid the danger that redistributors of a free
+program will individually obtain patent licenses, in effect making the
+program proprietary.  To prevent this, we have made it clear that any
+patent must be licensed for everyone's free use or not licensed at all.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.
+
+		    GNU GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License applies to any program or other work which contains
+a notice placed by the copyright holder saying it may be distributed
+under the terms of this General Public License.  The "Program", below,
+refers to any such program or work, and a "work based on the Program"
+means either the Program or any derivative work under copyright law:
+that is to say, a work containing the Program or a portion of it,
+either verbatim or with modifications and/or translated into another
+language.  (Hereinafter, translation is included without limitation in
+the term "modification".)  Each licensee is addressed as "you".
+
+Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running the Program is not restricted, and the output from the Program
+is covered only if its contents constitute a work based on the
+Program (independent of having been made by running the Program).
+Whether that is true depends on what the Program does.
+
+  1. You may copy and distribute verbatim copies of the Program's
+source code as you receive it, in any medium, provided that you
+conspicuously and appropriately publish on each copy an appropriate
+copyright notice and disclaimer of warranty; keep intact all the
+notices that refer to this License and to the absence of any warranty;
+and give any other recipients of the Program a copy of this License
+along with the Program.
+
+You may charge a fee for the physical act of transferring a copy, and
+you may at your option offer warranty protection in exchange for a fee.
+
+  2. You may modify your copy or copies of the Program or any portion
+of it, thus forming a work based on the Program, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) You must cause the modified files to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    b) You must cause any work that you distribute or publish, that in
+    whole or in part contains or is derived from the Program or any
+    part thereof, to be licensed as a whole at no charge to all third
+    parties under the terms of this License.
+
+    c) If the modified program normally reads commands interactively
+    when run, you must cause it, when started running for such
+    interactive use in the most ordinary way, to print or display an
+    announcement including an appropriate copyright notice and a
+    notice that there is no warranty (or else, saying that you provide
+    a warranty) and that users may redistribute the program under
+    these conditions, and telling the user how to view a copy of this
+    License.  (Exception: if the Program itself is interactive but
+    does not normally print such an announcement, your work based on
+    the Program is not required to print an announcement.)
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Program,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Program, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Program.
+
+In addition, mere aggregation of another work not based on the Program
+with the Program (or with a work based on the Program) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may copy and distribute the Program (or a work based on it,
+under Section 2) in object code or executable form under the terms of
+Sections 1 and 2 above provided that you also do one of the following:
+
+    a) Accompany it with the complete corresponding machine-readable
+    source code, which must be distributed under the terms of Sections
+    1 and 2 above on a medium customarily used for software interchange; or,
+
+    b) Accompany it with a written offer, valid for at least three
+    years, to give any third party, for a charge no more than your
+    cost of physically performing source distribution, a complete
+    machine-readable copy of the corresponding source code, to be
+    distributed under the terms of Sections 1 and 2 above on a medium
+    customarily used for software interchange; or,
+
+    c) Accompany it with the information you received as to the offer
+    to distribute corresponding source code.  (This alternative is
+    allowed only for noncommercial distribution and only if you
+    received the program in object code or executable form with such
+    an offer, in accord with Subsection b above.)
+
+The source code for a work means the preferred form of the work for
+making modifications to it.  For an executable work, complete source
+code means all the source code for all modules it contains, plus any
+associated interface definition files, plus the scripts used to
+control compilation and installation of the executable.  However, as a
+special exception, the source code distributed need not include
+anything that is normally distributed (in either source or binary
+form) with the major components (compiler, kernel, and so on) of the
+operating system on which the executable runs, unless that component
+itself accompanies the executable.
+
+If distribution of executable or object code is made by offering
+access to copy from a designated place, then offering equivalent
+access to copy the source code from the same place counts as
+distribution of the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+  4. You may not copy, modify, sublicense, or distribute the Program
+except as expressly provided under this License.  Any attempt
+otherwise to copy, modify, sublicense or distribute the Program is
+void, and will automatically terminate your rights under this License.
+However, parties who have received copies, or rights, from you under
+this License will not have their licenses terminated so long as such
+parties remain in full compliance.
+
+  5. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Program or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Program (or any work based on the
+Program), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Program or works based on it.
+
+  6. Each time you redistribute the Program (or any work based on the
+Program), the recipient automatically receives a license from the
+original licensor to copy, distribute or modify the Program subject to
+these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties to
+this License.
+
+  7. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Program at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Program by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Program.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system, which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+  8. If the distribution and/or use of the Program is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Program under this License
+may add an explicit geographical distribution limitation excluding
+those countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  9. The Free Software Foundation may publish revised and/or new versions
+of the General Public License from time to time.  Such new versions will
+be similar in spirit to the present version, but may differ in detail to
+address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Program
+specifies a version number of this License which applies to it and "any
+later version", you have the option of following the terms and conditions
+either of that version or of any later version published by the Free
+Software Foundation.  If the Program does not specify a version number of
+this License, you may choose any version ever published by the Free Software
+Foundation.
+
+  10. If you wish to incorporate parts of the Program into other free
+programs whose distribution conditions are different, write to the author
+to ask for permission.  For software which is copyrighted by the Free
+Software Foundation, write to the Free Software Foundation; we sometimes
+make exceptions for this.  Our decision will be guided by the two goals
+of preserving the free status of all derivatives of our free software and
+of promoting the sharing and reuse of software generally.
+
+			    NO WARRANTY
+
+  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+REPAIR OR CORRECTION.
+
+  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGES.
+
+		     END OF TERMS AND CONDITIONS
+
+	    How to Apply These Terms to Your New Programs
+
+  If you develop a new program, and you want it to be of the greatest
+possible use to the public, the best way to achieve this is to make it
+free software which everyone can redistribute and change under these terms.
+
+  To do so, attach the following notices to the program.  It is safest
+to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least
+the "copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the program's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+
+
+Also add information on how to contact you by electronic and paper mail.
+
+If the program is interactive, make it output a short notice like this
+when it starts in an interactive mode:
+
+    Gnomovision version 69, Copyright (C) year  name of author
+    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+    This is free software, and you are welcome to redistribute it
+    under certain conditions; type `show c' for details.
+
+The hypothetical commands `show w' and `show c' should show the appropriate
+parts of the General Public License.  Of course, the commands you use may
+be called something other than `show w' and `show c'; they could even be
+mouse-clicks or menu items--whatever suits your program.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the program, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+  `Gnomovision' (which makes passes at compilers) written by James Hacker.
+
+  <signature of Ty Coon>, 1 April 1989
+  Ty Coon, President of Vice
+
+This General Public License does not permit incorporating your program into
+proprietary programs.  If your program is a subroutine library, you may
+consider it more useful to permit linking proprietary applications with the
+library.  If this is what you want to do, use the GNU Library General
+Public License instead of this License.
diff --git a/tools/usb/usbip/INSTALL b/tools/usb/usbip/INSTALL
new file mode 100644
index 0000000..d3c5b40
--- /dev/null
+++ b/tools/usb/usbip/INSTALL
@@ -0,0 +1,237 @@
+Installation Instructions
+*************************
+
+Copyright (C) 1994, 1995, 1996, 1999, 2000, 2001, 2002, 2004, 2005,
+2006, 2007 Free Software Foundation, Inc.
+
+This file is free documentation; the Free Software Foundation gives
+unlimited permission to copy, distribute and modify it.
+
+Basic Installation
+==================
+
+Briefly, the shell commands `./configure; make; make install' should
+configure, build, and install this package.  The following
+more-detailed instructions are generic; see the `README' file for
+instructions specific to this package.
+
+   The `configure' shell script attempts to guess correct values for
+various system-dependent variables used during compilation.  It uses
+those values to create a `Makefile' in each directory of the package.
+It may also create one or more `.h' files containing system-dependent
+definitions.  Finally, it creates a shell script `config.status' that
+you can run in the future to recreate the current configuration, and a
+file `config.log' containing compiler output (useful mainly for
+debugging `configure').
+
+   It can also use an optional file (typically called `config.cache'
+and enabled with `--cache-file=config.cache' or simply `-C') that saves
+the results of its tests to speed up reconfiguring.  Caching is
+disabled by default to prevent problems with accidental use of stale
+cache files.
+
+   If you need to do unusual things to compile the package, please try
+to figure out how `configure' could check whether to do them, and mail
+diffs or instructions to the address given in the `README' so they can
+be considered for the next release.  If you are using the cache, and at
+some point `config.cache' contains results you don't want to keep, you
+may remove or edit it.
+
+   The file `configure.ac' (or `configure.in') is used to create
+`configure' by a program called `autoconf'.  You need `configure.ac' if
+you want to change it or regenerate `configure' using a newer version
+of `autoconf'.
+
+The simplest way to compile this package is:
+
+  1. `cd' to the directory containing the package's source code and type
+     `./configure' to configure the package for your system.
+
+     Running `configure' might take a while.  While running, it prints
+     some messages telling which features it is checking for.
+
+  2. Type `make' to compile the package.
+
+  3. Optionally, type `make check' to run any self-tests that come with
+     the package.
+
+  4. Type `make install' to install the programs and any data files and
+     documentation.
+
+  5. You can remove the program binaries and object files from the
+     source code directory by typing `make clean'.  To also remove the
+     files that `configure' created (so you can compile the package for
+     a different kind of computer), type `make distclean'.  There is
+     also a `make maintainer-clean' target, but that is intended mainly
+     for the package's developers.  If you use it, you may have to get
+     all sorts of other programs in order to regenerate files that came
+     with the distribution.
+
+  6. Often, you can also type `make uninstall' to remove the installed
+     files again.
+
+Compilers and Options
+=====================
+
+Some systems require unusual options for compilation or linking that the
+`configure' script does not know about.  Run `./configure --help' for
+details on some of the pertinent environment variables.
+
+   You can give `configure' initial values for configuration parameters
+by setting variables in the command line or in the environment.  Here
+is an example:
+
+     ./configure CC=c99 CFLAGS=-g LIBS=-lposix
+
+   *Note Defining Variables::, for more details.
+
+Compiling For Multiple Architectures
+====================================
+
+You can compile the package for more than one kind of computer at the
+same time, by placing the object files for each architecture in their
+own directory.  To do this, you can use GNU `make'.  `cd' to the
+directory where you want the object files and executables to go and run
+the `configure' script.  `configure' automatically checks for the
+source code in the directory that `configure' is in and in `..'.
+
+   With a non-GNU `make', it is safer to compile the package for one
+architecture at a time in the source code directory.  After you have
+installed the package for one architecture, use `make distclean' before
+reconfiguring for another architecture.
+
+Installation Names
+==================
+
+By default, `make install' installs the package's commands under
+`/usr/local/bin', include files under `/usr/local/include', etc.  You
+can specify an installation prefix other than `/usr/local' by giving
+`configure' the option `--prefix=PREFIX'.
+
+   You can specify separate installation prefixes for
+architecture-specific files and architecture-independent files.  If you
+pass the option `--exec-prefix=PREFIX' to `configure', the package uses
+PREFIX as the prefix for installing programs and libraries.
+Documentation and other data files still use the regular prefix.
+
+   In addition, if you use an unusual directory layout you can give
+options like `--bindir=DIR' to specify different values for particular
+kinds of files.  Run `configure --help' for a list of the directories
+you can set and what kinds of files go in them.
+
+   If the package supports it, you can cause programs to be installed
+with an extra prefix or suffix on their names by giving `configure' the
+option `--program-prefix=PREFIX' or `--program-suffix=SUFFIX'.
+
+Optional Features
+=================
+
+Some packages pay attention to `--enable-FEATURE' options to
+`configure', where FEATURE indicates an optional part of the package.
+They may also pay attention to `--with-PACKAGE' options, where PACKAGE
+is something like `gnu-as' or `x' (for the X Window System).  The
+`README' should mention any `--enable-' and `--with-' options that the
+package recognizes.
+
+   For packages that use the X Window System, `configure' can usually
+find the X include and library files automatically, but if it doesn't,
+you can use the `configure' options `--x-includes=DIR' and
+`--x-libraries=DIR' to specify their locations.
+
+Specifying the System Type
+==========================
+
+There may be some features `configure' cannot figure out automatically,
+but needs to determine by the type of machine the package will run on.
+Usually, assuming the package is built to be run on the _same_
+architectures, `configure' can figure that out, but if it prints a
+message saying it cannot guess the machine type, give it the
+`--build=TYPE' option.  TYPE can either be a short name for the system
+type, such as `sun4', or a canonical name which has the form:
+
+     CPU-COMPANY-SYSTEM
+
+where SYSTEM can have one of these forms:
+
+     OS KERNEL-OS
+
+   See the file `config.sub' for the possible values of each field.  If
+`config.sub' isn't included in this package, then this package doesn't
+need to know the machine type.
+
+   If you are _building_ compiler tools for cross-compiling, you should
+use the option `--target=TYPE' to select the type of system they will
+produce code for.
+
+   If you want to _use_ a cross compiler, that generates code for a
+platform different from the build platform, you should specify the
+"host" platform (i.e., that on which the generated programs will
+eventually be run) with `--host=TYPE'.
+
+Sharing Defaults
+================
+
+If you want to set default values for `configure' scripts to share, you
+can create a site shell script called `config.site' that gives default
+values for variables like `CC', `cache_file', and `prefix'.
+`configure' looks for `PREFIX/share/config.site' if it exists, then
+`PREFIX/etc/config.site' if it exists.  Or, you can set the
+`CONFIG_SITE' environment variable to the location of the site script.
+A warning: not all `configure' scripts look for a site script.
+
+Defining Variables
+==================
+
+Variables not defined in a site shell script can be set in the
+environment passed to `configure'.  However, some packages may run
+configure again during the build, and the customized values of these
+variables may be lost.  In order to avoid this problem, you should set
+them in the `configure' command line, using `VAR=value'.  For example:
+
+     ./configure CC=/usr/local2/bin/gcc
+
+causes the specified `gcc' to be used as the C compiler (unless it is
+overridden in the site shell script).
+
+Unfortunately, this technique does not work for `CONFIG_SHELL' due to
+an Autoconf bug.  Until the bug is fixed you can use this workaround:
+
+     CONFIG_SHELL=/bin/bash /bin/bash ./configure CONFIG_SHELL=/bin/bash
+
+`configure' Invocation
+======================
+
+`configure' recognizes the following options to control how it operates.
+
+`--help'
+`-h'
+     Print a summary of the options to `configure', and exit.
+
+`--version'
+`-V'
+     Print the version of Autoconf used to generate the `configure'
+     script, and exit.
+
+`--cache-file=FILE'
+     Enable the cache: use and save the results of the tests in FILE,
+     traditionally `config.cache'.  FILE defaults to `/dev/null' to
+     disable caching.
+
+`--config-cache'
+`-C'
+     Alias for `--cache-file=config.cache'.
+
+`--quiet'
+`--silent'
+`-q'
+     Do not print messages saying which checks are being made.  To
+     suppress all normal output, redirect it to `/dev/null' (any error
+     messages will still be shown).
+
+`--srcdir=DIR'
+     Look for the package's source code in directory DIR.  Usually
+     `configure' can determine that directory automatically.
+
+`configure' also accepts some other, not widely useful, options.  Run
+`configure --help' for more details.
+
diff --git a/tools/usb/usbip/Makefile.am b/tools/usb/usbip/Makefile.am
new file mode 100644
index 0000000..66f8bf0
--- /dev/null
+++ b/tools/usb/usbip/Makefile.am
@@ -0,0 +1,6 @@
+SUBDIRS := libsrc src
+includedir = @includedir@/usbip
+include_HEADERS := $(addprefix libsrc/, \
+		     usbip_common.h vhci_driver.h usbip_host_driver.h)
+
+dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8)
diff --git a/tools/usb/usbip/README b/tools/usb/usbip/README
new file mode 100644
index 0000000..f528ba4
--- /dev/null
+++ b/tools/usb/usbip/README
@@ -0,0 +1,203 @@
+#
+# README for usbip-utils
+#
+# Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+#               2005-2008 Takahiro Hirofuchi
+
+
+[Requirements]
+    - USB/IP device drivers
+	Found in the staging directory of the Linux kernel.
+
+    - libudev >= 2.0
+	libudev library
+
+    - libwrap0-dev
+	tcp wrapper library
+
+    - gcc >= 4.0
+
+    - libtool, automake >= 1.9, autoconf >= 2.5.0, pkg-config
+
+[Optional]
+    - hwdata
+        Contains USB device identification data.
+
+
+[Install]
+    0. Generate configuration scripts.
+	$ ./autogen.sh
+
+    1. Compile & install the userspace utilities.
+	$ ./configure [--with-tcp-wrappers=no] [--with-usbids-dir=<dir>]
+	$ make install
+
+    2. Compile & install USB/IP drivers.
+
+
+[Usage]
+    server:# (Physically attach your USB device.)
+
+    server:# insmod usbip-core.ko
+    server:# insmod usbip-host.ko
+
+    server:# usbipd -D
+	- Start usbip daemon.
+
+    server:# usbip list -l
+	- List driver assignments for USB devices.
+
+    server:# usbip bind --busid 1-2
+	- Bind usbip-host.ko to the device with busid 1-2.
+	- The USB device 1-2 is now exportable to other hosts!
+	- Use `usbip unbind --busid 1-2' to stop exporting the device.
+
+    client:# insmod usbip-core.ko
+    client:# insmod vhci-hcd.ko
+
+    client:# usbip list --remote <host>
+	- List exported USB devices on the <host>.
+
+    client:# usbip attach --remote <host> --busid 1-2
+	- Connect the remote USB device.
+
+    client:# usbip port
+	- Show virtual port status.
+
+    client:# usbip detach --port <port>
+	- Detach the USB device.
+
+
+[Example]
+---------------------------
+	SERVER SIDE
+---------------------------
+Physically attach your USB devices to this host.
+
+    trois:# insmod path/to/usbip-core.ko
+    trois:# insmod path/to/usbip-host.ko
+    trois:# usbipd -D
+
+In another terminal, let's look up what USB devices are physically
+attached to this host.
+
+    trois:# usbip list -l
+    Local USB devices
+    =================
+     - busid 1-1 (05a9:a511)
+	     1-1:1.0 -> ov511
+
+     - busid 3-2 (0711:0902)
+	     3-2:1.0 -> none
+
+     - busid 3-3.1 (08bb:2702)
+	     3-3.1:1.0 -> snd-usb-audio
+	     3-3.1:1.1 -> snd-usb-audio
+
+     - busid 3-3.2 (04bb:0206)
+	     3-3.2:1.0 -> usb-storage
+
+     - busid 3-3 (0409:0058)
+	     3-3:1.0 -> hub
+
+     - busid 4-1 (046d:08b2)
+	     4-1:1.0 -> none
+	     4-1:1.1 -> none
+	     4-1:1.2 -> none
+
+     - busid 5-2 (058f:9254)
+	     5-2:1.0 -> hub
+
+A USB storage device of busid 3-3.2 is now bound to the usb-storage
+driver. To export this device, we first mark the device as
+"exportable"; the device is bound to the usbip-host driver. Please
+remember you can not export a USB hub.
+
+Mark the device of busid 3-3.2 as exportable:
+
+    trois:# usbip --debug bind --busid 3-3.2
+    ...
+    usbip debug: usbip_bind.c:162:[unbind_other] 3-3.2:1.0 -> usb-storage
+    ...
+    bind device on busid 3-3.2: complete
+
+    trois:# usbip list -l
+    Local USB devices
+    =================
+    ...
+
+     - busid 3-3.2 (04bb:0206)
+	     3-3.2:1.0 -> usbip-host
+    ...
+
+---------------------------
+	CLIENT SIDE
+---------------------------
+First, let's list available remote devices that are marked as
+exportable on the host.
+
+    deux:# insmod path/to/usbip-core.ko
+    deux:# insmod path/to/vhci-hcd.ko
+
+    deux:# usbip list --remote 10.0.0.3
+    Exportable USB devices
+    ======================
+     - 10.0.0.3
+	    1-1: Prolific Technology, Inc. : unknown product (067b:3507)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
+
+	1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
+
+	1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
+	       : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
+
+	    3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
+	       : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
+	       : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
+	       :  0 - Data / unknown subclass / unknown protocol (0a/ff/00)
+	       :  1 - Audio / Control Device / unknown protocol (01/01/00)
+	       :  2 - Audio / Streaming / unknown protocol (01/02/00)
+
+Attach a remote USB device:
+
+    deux:# usbip attach --remote 10.0.0.3 --busid 1-1
+    port 0 attached
+
+Show the devices attached to this client:
+
+    deux:# usbip port
+    Port 00: <Port in Use> at Full Speed(12Mbps)
+	   Prolific Technology, Inc. : unknown product (067b:3507)
+	   6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
+	   6-1:1.0 used by usb-storage
+			  /sys/class/scsi_device/0:0:0:0/device
+			  /sys/class/scsi_host/host0/device
+			  /sys/block/sda/device
+
+Detach the imported device:
+
+    deux:# usbip detach --port 0
+    port 0 detached
+
+
+[Checklist]
+    - See 'Debug Tips' on the project wiki.
+	- http://usbip.wiki.sourceforge.net/how-to-debug-usbip
+    - usbip-host.ko must be bound to the target device.
+	- See /proc/bus/usb/devices and find "Driver=..." lines of the device.
+    - Shutdown firewall.
+	- usbip now uses TCP port 3240.
+    - Disable SELinux.
+    - If possible, compile your kernel with CONFIG_USB_DEBUG flag and try again.
+    - Check the kernel and daemon messages.
+
+
+[Contact]
+    Mailing List: linux-usb@vger.kernel.org
diff --git a/tools/usb/usbip/autogen.sh b/tools/usb/usbip/autogen.sh
new file mode 100755
index 0000000..e1112d3
--- /dev/null
+++ b/tools/usb/usbip/autogen.sh
@@ -0,0 +1,9 @@
+#!/bin/sh -x
+
+#aclocal
+#autoheader
+#libtoolize --copy --force
+#automake-1.9 -acf
+#autoconf
+
+autoreconf -i -f -v
diff --git a/tools/usb/usbip/cleanup.sh b/tools/usb/usbip/cleanup.sh
new file mode 100755
index 0000000..955c3cc
--- /dev/null
+++ b/tools/usb/usbip/cleanup.sh
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+if [ -r Makefile ]; then
+	make distclean
+fi
+
+FILES="aclocal.m4 autom4te.cache compile config.guess config.h.in config.log \
+       config.status config.sub configure cscope.out depcomp install-sh      \
+       libsrc/Makefile libsrc/Makefile.in libtool ltmain.sh Makefile         \
+       Makefile.in missing src/Makefile src/Makefile.in"
+
+rm -vRf $FILES
diff --git a/tools/usb/usbip/configure.ac b/tools/usb/usbip/configure.ac
new file mode 100644
index 0000000..607d05c
--- /dev/null
+++ b/tools/usb/usbip/configure.ac
@@ -0,0 +1,111 @@
+dnl Process this file with autoconf to produce a configure script.
+
+AC_PREREQ(2.59)
+AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
+AC_DEFINE([USBIP_VERSION], [0x00000111], [binary-coded decimal version number])
+
+CURRENT=0
+REVISION=1
+AGE=0
+AC_SUBST([LIBUSBIP_VERSION], [$CURRENT:$REVISION:$AGE], [library version])
+
+AC_CONFIG_SRCDIR([src/usbipd.c])
+AC_CONFIG_HEADERS([config.h])
+
+AM_INIT_AUTOMAKE([foreign])
+LT_INIT
+
+# Silent build for automake >= 1.11
+m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
+
+AC_SUBST([EXTRA_CFLAGS], ["-Wall -Werror -Wextra -std=gnu99"])
+
+# Checks for programs.
+AC_PROG_CC
+AC_PROG_INSTALL
+AC_PROG_MAKE_SET
+
+# Checks for header files.
+AC_HEADER_DIRENT
+AC_HEADER_STDC
+AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h netinet/in.h stdint.h stdlib.h dnl
+		  string.h sys/socket.h syslog.h unistd.h])
+
+# Checks for typedefs, structures, and compiler characteristics.
+AC_TYPE_INT32_T
+AC_TYPE_SIZE_T
+AC_TYPE_SSIZE_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT8_T
+
+# Checks for library functions.
+AC_FUNC_REALLOC
+AC_CHECK_FUNCS([memset mkdir regcomp socket strchr strerror strstr dnl
+		strtoul])
+
+AC_CHECK_HEADER([libudev.h],
+		[AC_CHECK_LIB([udev], [udev_new],
+			      [LIBS="$LIBS -ludev"],
+			      [AC_MSG_ERROR([Missing udev library!])])],
+		[AC_MSG_ERROR([Missing /usr/include/libudev.h])])
+
+# Checks for libwrap library.
+AC_MSG_CHECKING([whether to use the libwrap (TCP wrappers) library])
+AC_ARG_WITH([tcp-wrappers],
+	    [AS_HELP_STRING([--with-tcp-wrappers],
+			    [use the libwrap (TCP wrappers) library])],
+	    dnl [ACTION-IF-GIVEN]
+	    [if test "$withval" = "yes"; then
+		     AC_MSG_RESULT([yes])
+		     AC_MSG_CHECKING([for hosts_access in -lwrap])
+		     saved_LIBS="$LIBS"
+		     LIBS="-lwrap $saved_LIBS"
+		     AC_TRY_LINK(
+		       [int hosts_access(); int allow_severity, deny_severity;],
+		       [hosts_access()],
+		       [AC_MSG_RESULT([yes]);
+			AC_DEFINE([HAVE_LIBWRAP], [1],
+				  [use tcp wrapper]) wrap_LIB="-lwrap"],
+		       [AC_MSG_RESULT([not found]); exit 1])
+	     else
+		     AC_MSG_RESULT([no]);
+	     fi],
+	    dnl [ACTION-IF-NOT-GIVEN]
+	    [AC_MSG_RESULT([(default)])
+	     AC_MSG_CHECKING([for hosts_access in -lwrap])
+	     saved_LIBS="$LIBS"
+	     LIBS="-lwrap $saved_LIBS"
+	     AC_TRY_LINK(
+	       [int hosts_access(); int allow_severity, deny_severity;],
+	       [hosts_access()],
+	       [AC_MSG_RESULT([yes]);
+		AC_DEFINE([HAVE_LIBWRAP], [1], [use tcp wrapper])],
+	       [AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])])
+
+# Sets directory containing usb.ids.
+AC_ARG_WITH([usbids-dir],
+	    [AS_HELP_STRING([--with-usbids-dir=DIR],
+	       [where usb.ids is found (default /usr/share/hwdata/)])],
+	    [USBIDS_DIR=$withval], [USBIDS_DIR="/usr/share/hwdata/"])
+AC_SUBST([USBIDS_DIR])
+
+# use _FORTIFY_SOURCE
+AC_MSG_CHECKING([whether to use fortify])
+AC_ARG_WITH([fortify],
+	    [AS_HELP_STRING([--with-fortify],
+			    [use _FORTIFY_SROUCE option when compiling)])],
+			    dnl [ACTION-IF-GIVEN]
+			    [if test "$withval" = "yes"; then
+				AC_MSG_RESULT([yes])
+				CFLAGS="$CFLAGS -D_FORTIFY_SOURCE -O"
+			     else
+			     	AC_MSG_RESULT([no])
+				CFLAGS="$CFLAGS -U_FORTIFY_SOURCE"
+			     fi
+			    ],
+			    dnl [ACTION-IF-NOT-GIVEN]
+			    [AC_MSG_RESULT([default])])
+
+AC_CONFIG_FILES([Makefile libsrc/Makefile src/Makefile])
+AC_OUTPUT
diff --git a/tools/usb/usbip/doc/usbip.8 b/tools/usb/usbip/doc/usbip.8
new file mode 100644
index 0000000..a6097be
--- /dev/null
+++ b/tools/usb/usbip/doc/usbip.8
@@ -0,0 +1,95 @@
+.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
+.SH NAME
+usbip \- manage USB/IP devices
+.SH SYNOPSIS
+.B usbip
+[\fIoptions\fR] <\fIcommand\fR> <\fIargs\fR>
+
+.SH DESCRIPTION
+On a USB/IP server, devices can be listed, bound, and unbound using
+this program.  On a USB/IP client, devices exported by USB/IP servers
+can be listed, attached and detached.
+
+.SH OPTIONS
+.HP
+\fB\-\-debug\fR
+.IP
+Print debugging information.
+.PP
+
+.HP
+\fB\-\-log\fR
+.IP
+Log to syslog.
+.PP
+
+.HP
+\fB\-\-tcp-port PORT\fR
+.IP
+Connect to PORT on remote host (used for attach and list --remote).
+.PP
+
+.SH COMMANDS
+.HP
+\fBversion\fR
+.IP
+Show version and exit.
+.PP
+
+.HP
+\fBhelp\fR [\fIcommand\fR]
+.IP
+Print the program help message, or help on a specific command, and
+then exit.
+.PP
+
+.HP
+\fBattach\fR \-\-remote=<\fIhost\fR> \-\-busid=<\fIbus_id\fR>
+.IP
+Attach a remote USB device.
+.PP
+
+.HP
+\fBdetach\fR \-\-port=<\fIport\fR>
+.IP
+Detach an imported USB device.
+.PP
+
+.HP
+\fBbind\fR \-\-busid=<\fIbusid\fR>
+.IP
+Make a device exportable.
+.PP
+
+.HP
+\fBunbind\fR \-\-busid=<\fIbusid\fR>
+.IP
+Stop exporting a device so it can be used by a local driver.
+.PP
+
+.HP
+\fBlist\fR \-\-remote=<\fIhost\fR>
+.IP
+List USB devices exported by a remote host.
+.PP
+
+.HP
+\fBlist\fR \-\-local
+.IP
+List local USB devices.
+.PP
+
+
+.SH EXAMPLES
+
+    client:# usbip list --remote=server
+        - List exportable usb devices on the server.
+
+    client:# usbip attach --remote=server --busid=1-2
+        - Connect the remote USB device.
+
+    client:# usbip detach --port=0
+        - Detach the usb device.
+
+.SH "SEE ALSO"
+\fBusbipd\fP\fB(8)\fB\fP
diff --git a/tools/usb/usbip/doc/usbipd.8 b/tools/usb/usbip/doc/usbipd.8
new file mode 100644
index 0000000..ac4635d
--- /dev/null
+++ b/tools/usb/usbip/doc/usbipd.8
@@ -0,0 +1,91 @@
+.TH USBIP "8" "February 2009" "usbip" "System Administration Utilities"
+.SH NAME
+usbipd \- USB/IP server daemon
+.SH SYNOPSIS
+.B usbipd
+[\fIoptions\fR]
+
+.SH DESCRIPTION
+.B usbipd
+provides USB/IP clients access to exported USB devices.
+
+Devices have to explicitly be exported using
+.B usbip bind
+before usbipd makes them available to other hosts.
+
+The daemon accepts connections from USB/IP clients
+on TCP port 3240 by default.
+
+.SH OPTIONS
+.HP
+\fB\-4\fR, \fB\-\-ipv4\fR
+.IP
+Bind to IPv4. Default is both.
+.PP
+
+.HP
+\fB\-6\fR, \fB\-\-ipv6\fR
+.IP
+Bind to IPv6. Default is both.
+.PP
+
+.HP
+\fB\-D\fR, \fB\-\-daemon\fR
+.IP
+Run as a daemon process.
+.PP
+
+.HP
+\fB\-d\fR, \fB\-\-debug\fR
+.IP
+Print debugging information.
+.PP
+
+.HP
+\fB\-PFILE\fR, \fB\-\-pid FILE\fR
+.IP
+Write process id to FILE.
+.br
+If no FILE specified, use /var/run/usbipd.pid
+.PP
+
+\fB\-tPORT\fR, \fB\-\-tcp\-port PORT\fR
+.IP
+Listen on TCP/IP port PORT.
+.PP
+
+\fB\-h\fR, \fB\-\-help\fR
+.IP
+Print the program help message and exit.
+.PP
+
+.HP
+\fB\-v\fR, \fB\-\-version\fR
+.IP
+Show version.
+.PP
+
+.SH LIMITATIONS
+
+.B usbipd
+offers no authentication or authorization for USB/IP. Any
+USB/IP client can connect and use exported devices.
+
+.SH EXAMPLES
+
+    server:# modprobe usbip
+
+    server:# usbipd -D
+        - Start usbip daemon.
+
+    server:# usbip list --local
+        - List driver assignments for usb devices.
+
+    server:# usbip bind --busid=1-2
+        - Bind usbip-host.ko to the device of busid 1-2.
+        - A usb device 1-2 is now exportable to other hosts!
+        - Use 'usbip unbind --busid=1-2' when you want to shutdown exporting and use the device locally.
+
+.SH "SEE ALSO"
+\fBusbip\fP\fB(8)\fB\fP
+
diff --git a/tools/usb/usbip/libsrc/Makefile.am b/tools/usb/usbip/libsrc/Makefile.am
new file mode 100644
index 0000000..7c8f8a4
--- /dev/null
+++ b/tools/usb/usbip/libsrc/Makefile.am
@@ -0,0 +1,8 @@
+libusbip_la_CPPFLAGS = -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+libusbip_la_CFLAGS   = @EXTRA_CFLAGS@
+libusbip_la_LDFLAGS  = -version-info @LIBUSBIP_VERSION@
+
+lib_LTLIBRARIES := libusbip.la
+libusbip_la_SOURCES := names.c names.h usbip_host_driver.c usbip_host_driver.h \
+		       usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h \
+		       sysfs_utils.c sysfs_utils.h
diff --git a/tools/usb/usbip/libsrc/list.h b/tools/usb/usbip/libsrc/list.h
new file mode 100644
index 0000000..8d0c936
--- /dev/null
+++ b/tools/usb/usbip/libsrc/list.h
@@ -0,0 +1,136 @@
+#ifndef _LIST_H
+#define _LIST_H
+
+/* Stripped down implementation of linked list taken
+ * from the Linux Kernel.
+ */
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+static inline void INIT_LIST_HEAD(struct list_head *list)
+{
+	list->next = list;
+	list->prev = list;
+}
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/**
+ * list_add - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head * prev, struct list_head * next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+#define POISON_POINTER_DELTA 0
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
+
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty() on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void __list_del_entry(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+/**
+ * list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * list_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+#endif
diff --git a/tools/usb/usbip/libsrc/names.c b/tools/usb/usbip/libsrc/names.c
new file mode 100644
index 0000000..81ff852
--- /dev/null
+++ b/tools/usb/usbip/libsrc/names.c
@@ -0,0 +1,504 @@
+/*
+ *      names.c  --  USB name database manipulation routines
+ *
+ *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *
+ *
+ *
+ *	Copyright (C) 2005 Takahiro Hirofuchi
+ *		- names_deinit() is added.
+ *
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <ctype.h>
+
+#include "names.h"
+#include "usbip_common.h"
+
+struct vendor {
+	struct vendor *next;
+	u_int16_t vendorid;
+	char name[1];
+};
+
+struct product {
+	struct product *next;
+	u_int16_t vendorid, productid;
+	char name[1];
+};
+
+struct class {
+	struct class *next;
+	u_int8_t classid;
+	char name[1];
+};
+
+struct subclass {
+	struct subclass *next;
+	u_int8_t classid, subclassid;
+	char name[1];
+};
+
+struct protocol {
+	struct protocol *next;
+	u_int8_t classid, subclassid, protocolid;
+	char name[1];
+};
+
+struct genericstrtable {
+	struct genericstrtable *next;
+	unsigned int num;
+	char name[1];
+};
+
+
+#define HASH1  0x10
+#define HASH2  0x02
+#define HASHSZ 16
+
+static unsigned int hashnum(unsigned int num)
+{
+	unsigned int mask1 = HASH1 << 27, mask2 = HASH2 << 27;
+
+	for (; mask1 >= HASH1; mask1 >>= 1, mask2 >>= 1)
+		if (num & mask1)
+			num ^= mask2;
+	return num & (HASHSZ-1);
+}
+
+
+static struct vendor *vendors[HASHSZ] = { NULL, };
+static struct product *products[HASHSZ] = { NULL, };
+static struct class *classes[HASHSZ] = { NULL, };
+static struct subclass *subclasses[HASHSZ] = { NULL, };
+static struct protocol *protocols[HASHSZ] = { NULL, };
+
+const char *names_vendor(u_int16_t vendorid)
+{
+	struct vendor *v;
+
+	v = vendors[hashnum(vendorid)];
+	for (; v; v = v->next)
+		if (v->vendorid == vendorid)
+			return v->name;
+	return NULL;
+}
+
+const char *names_product(u_int16_t vendorid, u_int16_t productid)
+{
+	struct product *p;
+
+	p = products[hashnum((vendorid << 16) | productid)];
+	for (; p; p = p->next)
+		if (p->vendorid == vendorid && p->productid == productid)
+			return p->name;
+	return NULL;
+}
+
+const char *names_class(u_int8_t classid)
+{
+	struct class *c;
+
+	c = classes[hashnum(classid)];
+	for (; c; c = c->next)
+		if (c->classid == classid)
+			return c->name;
+	return NULL;
+}
+
+const char *names_subclass(u_int8_t classid, u_int8_t subclassid)
+{
+	struct subclass *s;
+
+	s = subclasses[hashnum((classid << 8) | subclassid)];
+	for (; s; s = s->next)
+		if (s->classid == classid && s->subclassid == subclassid)
+			return s->name;
+	return NULL;
+}
+
+const char *names_protocol(u_int8_t classid, u_int8_t subclassid,
+			   u_int8_t protocolid)
+{
+	struct protocol *p;
+
+	p = protocols[hashnum((classid << 16) | (subclassid << 8)
+			      | protocolid)];
+	for (; p; p = p->next)
+		if (p->classid == classid && p->subclassid == subclassid &&
+		    p->protocolid == protocolid)
+			return p->name;
+	return NULL;
+}
+
+/* add a cleanup function by takahiro */
+struct pool {
+	struct pool *next;
+	void *mem;
+};
+
+static struct pool *pool_head;
+
+static void *my_malloc(size_t size)
+{
+	struct pool *p;
+
+	p = calloc(1, sizeof(struct pool));
+	if (!p)
+		return NULL;
+
+	p->mem = calloc(1, size);
+	if (!p->mem) {
+		free(p);
+		return NULL;
+	}
+
+	p->next = pool_head;
+	pool_head = p;
+
+	return p->mem;
+}
+
+void names_free(void)
+{
+	struct pool *pool;
+
+	if (!pool_head)
+		return;
+
+	for (pool = pool_head; pool != NULL; ) {
+		struct pool *tmp;
+
+		if (pool->mem)
+			free(pool->mem);
+
+		tmp = pool;
+		pool = pool->next;
+		free(tmp);
+	}
+}
+
+static int new_vendor(const char *name, u_int16_t vendorid)
+{
+	struct vendor *v;
+	unsigned int h = hashnum(vendorid);
+
+	v = vendors[h];
+	for (; v; v = v->next)
+		if (v->vendorid == vendorid)
+			return -1;
+	v = my_malloc(sizeof(struct vendor) + strlen(name));
+	if (!v)
+		return -1;
+	strcpy(v->name, name);
+	v->vendorid = vendorid;
+	v->next = vendors[h];
+	vendors[h] = v;
+	return 0;
+}
+
+static int new_product(const char *name, u_int16_t vendorid,
+		       u_int16_t productid)
+{
+	struct product *p;
+	unsigned int h = hashnum((vendorid << 16) | productid);
+
+	p = products[h];
+	for (; p; p = p->next)
+		if (p->vendorid == vendorid && p->productid == productid)
+			return -1;
+	p = my_malloc(sizeof(struct product) + strlen(name));
+	if (!p)
+		return -1;
+	strcpy(p->name, name);
+	p->vendorid = vendorid;
+	p->productid = productid;
+	p->next = products[h];
+	products[h] = p;
+	return 0;
+}
+
+static int new_class(const char *name, u_int8_t classid)
+{
+	struct class *c;
+	unsigned int h = hashnum(classid);
+
+	c = classes[h];
+	for (; c; c = c->next)
+		if (c->classid == classid)
+			return -1;
+	c = my_malloc(sizeof(struct class) + strlen(name));
+	if (!c)
+		return -1;
+	strcpy(c->name, name);
+	c->classid = classid;
+	c->next = classes[h];
+	classes[h] = c;
+	return 0;
+}
+
+static int new_subclass(const char *name, u_int8_t classid, u_int8_t subclassid)
+{
+	struct subclass *s;
+	unsigned int h = hashnum((classid << 8) | subclassid);
+
+	s = subclasses[h];
+	for (; s; s = s->next)
+		if (s->classid == classid && s->subclassid == subclassid)
+			return -1;
+	s = my_malloc(sizeof(struct subclass) + strlen(name));
+	if (!s)
+		return -1;
+	strcpy(s->name, name);
+	s->classid = classid;
+	s->subclassid = subclassid;
+	s->next = subclasses[h];
+	subclasses[h] = s;
+	return 0;
+}
+
+static int new_protocol(const char *name, u_int8_t classid, u_int8_t subclassid,
+			u_int8_t protocolid)
+{
+	struct protocol *p;
+	unsigned int h = hashnum((classid << 16) | (subclassid << 8)
+				 | protocolid);
+
+	p = protocols[h];
+	for (; p; p = p->next)
+		if (p->classid == classid && p->subclassid == subclassid
+		    && p->protocolid == protocolid)
+			return -1;
+	p = my_malloc(sizeof(struct protocol) + strlen(name));
+	if (!p)
+		return -1;
+	strcpy(p->name, name);
+	p->classid = classid;
+	p->subclassid = subclassid;
+	p->protocolid = protocolid;
+	p->next = protocols[h];
+	protocols[h] = p;
+	return 0;
+}
+
+static void parse(FILE *f)
+{
+	char buf[512], *cp;
+	unsigned int linectr = 0;
+	int lastvendor = -1;
+	int lastclass = -1;
+	int lastsubclass = -1;
+	int lasthut = -1;
+	int lastlang = -1;
+	unsigned int u;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		linectr++;
+		/* remove line ends */
+		cp = strchr(buf, '\r');
+		if (cp)
+			*cp = 0;
+		cp = strchr(buf, '\n');
+		if (cp)
+			*cp = 0;
+		if (buf[0] == '#' || !buf[0])
+			continue;
+		cp = buf;
+		if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' &&
+		    buf[3] == 'S' && buf[4] == 'D' &&
+		    buf[5] == 'E' && buf[6] == 'S' && /*isspace(buf[7])*/
+		    buf[7] == ' ') {
+			continue;
+		}
+		if (buf[0] == 'P' && buf[1] == 'H' &&
+		    buf[2] == 'Y' && /*isspace(buf[3])*/ buf[3] == ' ') {
+			continue;
+		}
+		if (buf[0] == 'B' && buf[1] == 'I' && buf[2] == 'A' &&
+		    buf[3] == 'S' && /*isspace(buf[4])*/ buf[4] == ' ') {
+			continue;
+		}
+		if (buf[0] == 'L' && /*isspace(buf[1])*/ buf[1] == ' ') {
+			lasthut = lastclass = lastvendor = lastsubclass = -1;
+			/*
+			 * set 1 as pseudo-id to indicate that the parser is
+			 * in a `L' section.
+			 */
+			lastlang = 1;
+			continue;
+		}
+		if (buf[0] == 'C' && /*isspace(buf[1])*/ buf[1] == ' ') {
+			/* class spec */
+			cp = buf+2;
+			while (isspace(*cp))
+				cp++;
+			if (!isxdigit(*cp)) {
+				err("Invalid class spec at line %u", linectr);
+				continue;
+			}
+			u = strtoul(cp, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				err("Invalid class spec at line %u", linectr);
+				continue;
+			}
+			if (new_class(cp, u))
+				err("Duplicate class spec at line %u class %04x %s",
+				    linectr, u, cp);
+			dbg("line %5u class %02x %s", linectr, u, cp);
+			lasthut = lastlang = lastvendor = lastsubclass = -1;
+			lastclass = u;
+			continue;
+		}
+		if (buf[0] == 'A' && buf[1] == 'T' && isspace(buf[2])) {
+			/* audio terminal type spec */
+			continue;
+		}
+		if (buf[0] == 'H' && buf[1] == 'C' && buf[2] == 'C'
+		    && isspace(buf[3])) {
+			/* HID Descriptor bCountryCode */
+			continue;
+		}
+		if (isxdigit(*cp)) {
+			/* vendor */
+			u = strtoul(cp, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				err("Invalid vendor spec at line %u", linectr);
+				continue;
+			}
+			if (new_vendor(cp, u))
+				err("Duplicate vendor spec at line %u vendor %04x %s",
+				    linectr, u, cp);
+			dbg("line %5u vendor %04x %s", linectr, u, cp);
+			lastvendor = u;
+			lasthut = lastlang = lastclass = lastsubclass = -1;
+			continue;
+		}
+		if (buf[0] == '\t' && isxdigit(buf[1])) {
+			/* product or subclass spec */
+			u = strtoul(buf+1, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				err("Invalid product/subclass spec at line %u",
+				    linectr);
+				continue;
+			}
+			if (lastvendor != -1) {
+				if (new_product(cp, lastvendor, u))
+					err("Duplicate product spec at line %u product %04x:%04x %s",
+					    linectr, lastvendor, u, cp);
+				dbg("line %5u product %04x:%04x %s", linectr,
+				    lastvendor, u, cp);
+				continue;
+			}
+			if (lastclass != -1) {
+				if (new_subclass(cp, lastclass, u))
+					err("Duplicate subclass spec at line %u class %02x:%02x %s",
+					    linectr, lastclass, u, cp);
+				dbg("line %5u subclass %02x:%02x %s", linectr,
+				    lastclass, u, cp);
+				lastsubclass = u;
+				continue;
+			}
+			if (lasthut != -1) {
+				/* do not store hut */
+				continue;
+			}
+			if (lastlang != -1) {
+				/* do not store langid */
+				continue;
+			}
+			err("Product/Subclass spec without prior Vendor/Class spec at line %u",
+			    linectr);
+			continue;
+		}
+		if (buf[0] == '\t' && buf[1] == '\t' && isxdigit(buf[2])) {
+			/* protocol spec */
+			u = strtoul(buf+2, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				err("Invalid protocol spec at line %u",
+				    linectr);
+				continue;
+			}
+			if (lastclass != -1 && lastsubclass != -1) {
+				if (new_protocol(cp, lastclass, lastsubclass,
+						 u))
+					err("Duplicate protocol spec at line %u class %02x:%02x:%02x %s",
+					    linectr, lastclass, lastsubclass,
+					    u, cp);
+				dbg("line %5u protocol %02x:%02x:%02x %s",
+				    linectr, lastclass, lastsubclass, u, cp);
+				continue;
+			}
+			err("Protocol spec without prior Class and Subclass spec at line %u",
+			    linectr);
+			continue;
+		}
+		if (buf[0] == 'H' && buf[1] == 'I' &&
+		    buf[2] == 'D' && /*isspace(buf[3])*/ buf[3] == ' ') {
+			continue;
+		}
+		if (buf[0] == 'H' && buf[1] == 'U' &&
+		    buf[2] == 'T' && /*isspace(buf[3])*/ buf[3] == ' ') {
+			lastlang = lastclass = lastvendor = lastsubclass = -1;
+			/*
+			 * set 1 as pseudo-id to indicate that the parser is
+			 * in a `HUT' section.
+			 */
+			lasthut = 1;
+			continue;
+		}
+		if (buf[0] == 'R' && buf[1] == ' ')
+			continue;
+
+		if (buf[0] == 'V' && buf[1] == 'T')
+			continue;
+
+		err("Unknown line at line %u", linectr);
+	}
+}
+
+
+int names_init(char *n)
+{
+	FILE *f;
+
+	f = fopen(n, "r");
+	if (!f)
+		return errno;
+
+	parse(f);
+	fclose(f);
+	return 0;
+}
diff --git a/tools/usb/usbip/libsrc/names.h b/tools/usb/usbip/libsrc/names.h
new file mode 100644
index 0000000..6809265
--- /dev/null
+++ b/tools/usb/usbip/libsrc/names.h
@@ -0,0 +1,41 @@
+/*
+ *      names.h  --  USB name database manipulation routines
+ *
+ *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *
+ *	Copyright (C) 2005 Takahiro Hirofuchi
+ *	       - names_free() is added.
+ */
+
+#ifndef _NAMES_H
+#define _NAMES_H
+
+#include <sys/types.h>
+
+/* used by usbip_common.c */
+extern const char *names_vendor(u_int16_t vendorid);
+extern const char *names_product(u_int16_t vendorid, u_int16_t productid);
+extern const char *names_class(u_int8_t classid);
+extern const char *names_subclass(u_int8_t classid, u_int8_t subclassid);
+extern const char *names_protocol(u_int8_t classid, u_int8_t subclassid,
+				  u_int8_t protocolid);
+extern int  names_init(char *n);
+extern void names_free(void);
+
+#endif /* _NAMES_H */
diff --git a/tools/usb/usbip/libsrc/sysfs_utils.c b/tools/usb/usbip/libsrc/sysfs_utils.c
new file mode 100644
index 0000000..36ac88e
--- /dev/null
+++ b/tools/usb/usbip/libsrc/sysfs_utils.c
@@ -0,0 +1,31 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "sysfs_utils.h"
+#include "usbip_common.h"
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len)
+{
+	int fd;
+	int length;
+
+	fd = open(attr_path, O_WRONLY);
+	if (fd < 0) {
+		dbg("error opening attribute %s", attr_path);
+		return -1;
+	}
+
+	length = write(fd, new_value, len);
+	if (length < 0) {
+		dbg("error writing to attribute %s", attr_path);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
diff --git a/tools/usb/usbip/libsrc/sysfs_utils.h b/tools/usb/usbip/libsrc/sysfs_utils.h
new file mode 100644
index 0000000..32ac1d1
--- /dev/null
+++ b/tools/usb/usbip/libsrc/sysfs_utils.h
@@ -0,0 +1,8 @@
+
+#ifndef __SYSFS_UTILS_H
+#define __SYSFS_UTILS_H
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len);
+
+#endif
diff --git a/tools/usb/usbip/libsrc/usbip_common.c b/tools/usb/usbip/libsrc/usbip_common.c
new file mode 100644
index 0000000..238bf5b
--- /dev/null
+++ b/tools/usb/usbip/libsrc/usbip_common.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include <libudev.h>
+#include "usbip_common.h"
+#include "names.h"
+
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
+int usbip_use_syslog;
+int usbip_use_stderr;
+int usbip_use_debug;
+
+extern struct udev *udev_context;
+
+struct speed_string {
+	int num;
+	char *speed;
+	char *desc;
+};
+
+static const struct speed_string speed_strings[] = {
+	{ USB_SPEED_UNKNOWN, "unknown", "Unknown Speed"},
+	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
+	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
+	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
+	{ USB_SPEED_WIRELESS, "53.3-480", "Wireless"},
+	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
+	{ 0, NULL, NULL }
+};
+
+struct portst_string {
+	int num;
+	char *desc;
+};
+
+static struct portst_string portst_strings[] = {
+	{ SDEV_ST_AVAILABLE,	"Device Available" },
+	{ SDEV_ST_USED,		"Device in Use" },
+	{ SDEV_ST_ERROR,	"Device Error"},
+	{ VDEV_ST_NULL,		"Port Available"},
+	{ VDEV_ST_NOTASSIGNED,	"Port Initializing"},
+	{ VDEV_ST_USED,		"Port in Use"},
+	{ VDEV_ST_ERROR,	"Port Error"},
+	{ 0, NULL}
+};
+
+const char *usbip_status_string(int32_t status)
+{
+	for (int i = 0; portst_strings[i].desc != NULL; i++)
+		if (portst_strings[i].num == status)
+			return portst_strings[i].desc;
+
+	return "Unknown Status";
+}
+
+const char *usbip_speed_string(int num)
+{
+	for (int i = 0; speed_strings[i].speed != NULL; i++)
+		if (speed_strings[i].num == num)
+			return speed_strings[i].desc;
+
+	return "Unknown Speed";
+}
+
+
+#define DBG_UDEV_INTEGER(name)\
+	dbg("%-20s = %x", to_string(name), (int) udev->name)
+
+#define DBG_UINF_INTEGER(name)\
+	dbg("%-20s = %x", to_string(name), (int) uinf->name)
+
+void dump_usb_interface(struct usbip_usb_interface *uinf)
+{
+	char buff[100];
+	usbip_names_get_class(buff, sizeof(buff),
+			uinf->bInterfaceClass,
+			uinf->bInterfaceSubClass,
+			uinf->bInterfaceProtocol);
+	dbg("%-20s = %s", "Interface(C/SC/P)", buff);
+}
+
+void dump_usb_device(struct usbip_usb_device *udev)
+{
+	char buff[100];
+
+
+	dbg("%-20s = %s", "path",  udev->path);
+	dbg("%-20s = %s", "busid", udev->busid);
+
+	usbip_names_get_class(buff, sizeof(buff),
+			udev->bDeviceClass,
+			udev->bDeviceSubClass,
+			udev->bDeviceProtocol);
+	dbg("%-20s = %s", "Device(C/SC/P)", buff);
+
+	DBG_UDEV_INTEGER(bcdDevice);
+
+	usbip_names_get_product(buff, sizeof(buff),
+			udev->idVendor,
+			udev->idProduct);
+	dbg("%-20s = %s", "Vendor/Product", buff);
+
+	DBG_UDEV_INTEGER(bNumConfigurations);
+	DBG_UDEV_INTEGER(bNumInterfaces);
+
+	dbg("%-20s = %s", "speed",
+			usbip_speed_string(udev->speed));
+
+	DBG_UDEV_INTEGER(busnum);
+	DBG_UDEV_INTEGER(devnum);
+}
+
+
+int read_attr_value(struct udev_device *dev, const char *name,
+		    const char *format)
+{
+	const char *attr;
+	int num = 0;
+	int ret;
+
+	attr = udev_device_get_sysattr_value(dev, name);
+	if (!attr) {
+		err("udev_device_get_sysattr_value failed");
+		goto err;
+	}
+
+	/* The client chooses the device configuration
+	 * when attaching it so right after being bound
+	 * to usbip-host on the server the device will
+	 * have no configuration.
+	 * Therefore, attributes such as bConfigurationValue
+	 * and bNumInterfaces will not exist and sscanf will
+	 * fail. Check for these cases and don't treat them
+	 * as errors.
+	 */
+
+	ret = sscanf(attr, format, &num);
+	if (ret < 1) {
+		if (strcmp(name, "bConfigurationValue") &&
+				strcmp(name, "bNumInterfaces")) {
+			err("sscanf failed for attribute %s", name);
+			goto err;
+		}
+	}
+
+err:
+
+	return num;
+}
+
+
+int read_attr_speed(struct udev_device *dev)
+{
+	const char *speed;
+
+	speed = udev_device_get_sysattr_value(dev, "speed");
+	if (!speed) {
+		err("udev_device_get_sysattr_value failed");
+		goto err;
+	}
+
+	for (int i = 0; speed_strings[i].speed != NULL; i++) {
+		if (!strcmp(speed, speed_strings[i].speed))
+			return speed_strings[i].num;
+	}
+
+err:
+
+	return USB_SPEED_UNKNOWN;
+}
+
+#define READ_ATTR(object, type, dev, name, format)			      \
+	do {								      \
+		(object)->name = (type) read_attr_value(dev, to_string(name), \
+							format);	      \
+	} while (0)
+
+
+int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev)
+{
+	uint32_t busnum, devnum;
+	const char *path, *name;
+
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceClass,		"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceSubClass,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceProtocol,	"%02x\n");
+
+	READ_ATTR(udev, uint16_t, sdev, idVendor,		"%04x\n");
+	READ_ATTR(udev, uint16_t, sdev, idProduct,		"%04x\n");
+	READ_ATTR(udev, uint16_t, sdev, bcdDevice,		"%04x\n");
+
+	READ_ATTR(udev, uint8_t,  sdev, bConfigurationValue,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bNumConfigurations,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bNumInterfaces,		"%02x\n");
+
+	READ_ATTR(udev, uint8_t,  sdev, devnum,			"%d\n");
+	udev->speed = read_attr_speed(sdev);
+
+	path = udev_device_get_syspath(sdev);
+	name = udev_device_get_sysname(sdev);
+
+	strncpy(udev->path,  path,  SYSFS_PATH_MAX);
+	strncpy(udev->busid, name, SYSFS_BUS_ID_SIZE);
+
+	sscanf(name, "%u-%u", &busnum, &devnum);
+	udev->busnum = busnum;
+
+	return 0;
+}
+
+int read_usb_interface(struct usbip_usb_device *udev, int i,
+		       struct usbip_usb_interface *uinf)
+{
+	char busid[SYSFS_BUS_ID_SIZE];
+	struct udev_device *sif;
+
+	sprintf(busid, "%s:%d.%d", udev->busid, udev->bConfigurationValue, i);
+
+	sif = udev_device_new_from_subsystem_sysname(udev_context, "usb", busid);
+	if (!sif) {
+		err("udev_device_new_from_subsystem_sysname %s failed", busid);
+		return -1;
+	}
+
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceClass,		"%02x\n");
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceSubClass,	"%02x\n");
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceProtocol,	"%02x\n");
+
+	return 0;
+}
+
+int usbip_names_init(char *f)
+{
+	return names_init(f);
+}
+
+void usbip_names_free()
+{
+	names_free();
+}
+
+void usbip_names_get_product(char *buff, size_t size, uint16_t vendor,
+			     uint16_t product)
+{
+	const char *prod, *vend;
+
+	prod = names_product(vendor, product);
+	if (!prod)
+		prod = "unknown product";
+
+
+	vend = names_vendor(vendor);
+	if (!vend)
+		vend = "unknown vendor";
+
+	snprintf(buff, size, "%s : %s (%04x:%04x)", vend, prod, vendor, product);
+}
+
+void usbip_names_get_class(char *buff, size_t size, uint8_t class,
+			   uint8_t subclass, uint8_t protocol)
+{
+	const char *c, *s, *p;
+
+	if (class == 0 && subclass == 0 && protocol == 0) {
+		snprintf(buff, size, "(Defined at Interface level) (%02x/%02x/%02x)", class, subclass, protocol);
+		return;
+	}
+
+	p = names_protocol(class, subclass, protocol);
+	if (!p)
+		p = "unknown protocol";
+
+	s = names_subclass(class, subclass);
+	if (!s)
+		s = "unknown subclass";
+
+	c = names_class(class);
+	if (!c)
+		c = "unknown class";
+
+	snprintf(buff, size, "%s / %s / %s (%02x/%02x/%02x)", c, s, p, class, subclass, protocol);
+}
diff --git a/tools/usb/usbip/libsrc/usbip_common.h b/tools/usb/usbip/libsrc/usbip_common.h
new file mode 100644
index 0000000..23be848
--- /dev/null
+++ b/tools/usb/usbip/libsrc/usbip_common.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef __USBIP_COMMON_H
+#define __USBIP_COMMON_H
+
+#include <libudev.h>
+
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <syslog.h>
+#include <unistd.h>
+#include <linux/usb/ch9.h>
+#include "../../uapi/usbip.h"
+
+#ifndef USBIDS_FILE
+#define USBIDS_FILE "/usr/share/hwdata/usb.ids"
+#endif
+
+#ifndef VHCI_STATE_PATH
+#define VHCI_STATE_PATH "/var/run/vhci_hcd"
+#endif
+
+/* kernel module names */
+#define USBIP_CORE_MOD_NAME	"usbip-core"
+#define USBIP_HOST_DRV_NAME	"usbip-host"
+#define USBIP_VHCI_DRV_NAME	"vhci_hcd"
+
+/* sysfs constants */
+#define SYSFS_MNT_PATH         "/sys"
+#define SYSFS_BUS_NAME         "bus"
+#define SYSFS_BUS_TYPE         "usb"
+#define SYSFS_DRIVERS_NAME     "drivers"
+
+#define SYSFS_PATH_MAX		256
+#define SYSFS_BUS_ID_SIZE	32
+
+extern int usbip_use_syslog;
+extern int usbip_use_stderr;
+extern int usbip_use_debug ;
+
+#define PROGNAME "usbip"
+
+#define pr_fmt(fmt)	"%s: %s: " fmt "\n", PROGNAME
+#define dbg_fmt(fmt)	pr_fmt("%s:%d:[%s] " fmt), "debug",	\
+		        __FILE__, __LINE__, __FUNCTION__
+
+#define err(fmt, args...)						\
+	do {								\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_ERR, pr_fmt(fmt), "error", ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, pr_fmt(fmt), "error", ##args);	\
+		}							\
+	} while (0)
+
+#define info(fmt, args...)						\
+	do {								\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_INFO, pr_fmt(fmt), "info", ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, pr_fmt(fmt), "info", ##args);	\
+		}							\
+	} while (0)
+
+#define dbg(fmt, args...)						\
+	do {								\
+	if (usbip_use_debug) {						\
+		if (usbip_use_syslog) {					\
+			syslog(LOG_DEBUG, dbg_fmt(fmt), ##args);	\
+		}							\
+		if (usbip_use_stderr) {					\
+			fprintf(stderr, dbg_fmt(fmt), ##args);		\
+		}							\
+	}								\
+	} while (0)
+
+#define BUG()						\
+	do {						\
+		err("sorry, it's a bug!");		\
+		abort();				\
+	} while (0)
+
+struct usbip_usb_interface {
+	uint8_t bInterfaceClass;
+	uint8_t bInterfaceSubClass;
+	uint8_t bInterfaceProtocol;
+	uint8_t padding;	/* alignment */
+} __attribute__((packed));
+
+struct usbip_usb_device {
+	char path[SYSFS_PATH_MAX];
+	char busid[SYSFS_BUS_ID_SIZE];
+
+	uint32_t busnum;
+	uint32_t devnum;
+	uint32_t speed;
+
+	uint16_t idVendor;
+	uint16_t idProduct;
+	uint16_t bcdDevice;
+
+	uint8_t bDeviceClass;
+	uint8_t bDeviceSubClass;
+	uint8_t bDeviceProtocol;
+	uint8_t bConfigurationValue;
+	uint8_t bNumConfigurations;
+	uint8_t bNumInterfaces;
+} __attribute__((packed));
+
+#define to_string(s)	#s
+
+void dump_usb_interface(struct usbip_usb_interface *);
+void dump_usb_device(struct usbip_usb_device *);
+int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev);
+int read_attr_value(struct udev_device *dev, const char *name,
+		    const char *format);
+int read_usb_interface(struct usbip_usb_device *udev, int i,
+		       struct usbip_usb_interface *uinf);
+
+const char *usbip_speed_string(int num);
+const char *usbip_status_string(int32_t status);
+
+int usbip_names_init(char *);
+void usbip_names_free(void);
+void usbip_names_get_product(char *buff, size_t size, uint16_t vendor,
+			     uint16_t product);
+void usbip_names_get_class(char *buff, size_t size, uint8_t class,
+			   uint8_t subclass, uint8_t protocol);
+
+#endif /* __USBIP_COMMON_H */
diff --git a/tools/usb/usbip/libsrc/usbip_host_driver.c b/tools/usb/usbip/libsrc/usbip_host_driver.c
new file mode 100644
index 0000000..c5bf60b
--- /dev/null
+++ b/tools/usb/usbip/libsrc/usbip_host_driver.c
@@ -0,0 +1,276 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <errno.h>
+#include <unistd.h>
+
+#include <libudev.h>
+
+#include "usbip_common.h"
+#include "usbip_host_driver.h"
+#include "list.h"
+#include "sysfs_utils.h"
+
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
+struct usbip_host_driver *host_driver;
+struct udev *udev_context;
+
+static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
+{
+	char status_attr_path[SYSFS_PATH_MAX];
+	int fd;
+	int length;
+	char status;
+	int value = 0;
+
+	snprintf(status_attr_path, SYSFS_PATH_MAX, "%s/usbip_status",
+		 udev->path);
+
+	if ((fd = open(status_attr_path, O_RDONLY)) < 0) {
+		err("error opening attribute %s", status_attr_path);
+		return -1;
+	}
+
+	length = read(fd, &status, 1);
+	if (length < 0) {
+		err("error reading attribute %s", status_attr_path);
+		close(fd);
+		return -1;
+	}
+
+	value = atoi(&status);
+
+	return value;
+}
+
+static
+struct usbip_exported_device *usbip_exported_device_new(const char *sdevpath)
+{
+	struct usbip_exported_device *edev = NULL;
+	struct usbip_exported_device *edev_old;
+	size_t size;
+	int i;
+
+	edev = calloc(1, sizeof(struct usbip_exported_device));
+
+	edev->sudev = udev_device_new_from_syspath(udev_context, sdevpath);
+	if (!edev->sudev) {
+		err("udev_device_new_from_syspath: %s", sdevpath);
+		goto err;
+	}
+
+	read_usb_device(edev->sudev, &edev->udev);
+
+	edev->status = read_attr_usbip_status(&edev->udev);
+	if (edev->status < 0)
+		goto err;
+
+	/* reallocate buffer to include usb interface data */
+	size = sizeof(struct usbip_exported_device) + edev->udev.bNumInterfaces *
+		sizeof(struct usbip_usb_interface);
+
+	edev_old = edev;
+	edev = realloc(edev, size);
+	if (!edev) {
+		edev = edev_old;
+		dbg("realloc failed");
+		goto err;
+	}
+
+	for (i = 0; i < edev->udev.bNumInterfaces; i++)
+		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
+
+	return edev;
+err:
+	if (edev->sudev)
+		udev_device_unref(edev->sudev);
+	if (edev)
+		free(edev);
+
+	return NULL;
+}
+
+static int refresh_exported_devices(void)
+{
+	struct usbip_exported_device *edev;
+	struct udev_enumerate *enumerate;
+	struct udev_list_entry *devices, *dev_list_entry;
+	struct udev_device *dev;
+	const char *path;
+
+	enumerate = udev_enumerate_new(udev_context);
+	udev_enumerate_add_match_subsystem(enumerate, "usb");
+	udev_enumerate_scan_devices(enumerate);
+
+	devices = udev_enumerate_get_list_entry(enumerate);
+
+	udev_list_entry_foreach(dev_list_entry, devices) {
+		path = udev_list_entry_get_name(dev_list_entry);
+		dev = udev_device_new_from_syspath(udev_context, path);
+
+		/* Check whether device uses usbip-host driver. */
+		if (!strcmp(udev_device_get_driver(dev),
+			    USBIP_HOST_DRV_NAME)) {
+			edev = usbip_exported_device_new(path);
+			if (!edev) {
+				dbg("usbip_exported_device_new failed");
+				continue;
+			}
+
+			list_add(&edev->node, &host_driver->edev_list);
+			host_driver->ndevs++;
+		}
+	}
+
+	return 0;
+}
+
+static void usbip_exported_device_destroy(void)
+{
+	struct list_head *i, *tmp;
+	struct usbip_exported_device *edev;
+
+	list_for_each_safe(i, tmp, &host_driver->edev_list) {
+		edev = list_entry(i, struct usbip_exported_device, node);
+		list_del(i);
+		free(edev);
+	}
+}
+
+int usbip_host_driver_open(void)
+{
+	int rc;
+
+	udev_context = udev_new();
+	if (!udev_context) {
+		err("udev_new failed");
+		return -1;
+	}
+
+	host_driver = calloc(1, sizeof(*host_driver));
+
+	host_driver->ndevs = 0;
+	INIT_LIST_HEAD(&host_driver->edev_list);
+
+	rc = refresh_exported_devices();
+	if (rc < 0)
+		goto err_free_host_driver;
+
+	return 0;
+
+err_free_host_driver:
+	free(host_driver);
+	host_driver = NULL;
+
+	udev_unref(udev_context);
+
+	return -1;
+}
+
+void usbip_host_driver_close(void)
+{
+	if (!host_driver)
+		return;
+
+	usbip_exported_device_destroy();
+
+	free(host_driver);
+	host_driver = NULL;
+
+	udev_unref(udev_context);
+}
+
+int usbip_host_refresh_device_list(void)
+{
+	int rc;
+
+	usbip_exported_device_destroy();
+
+	host_driver->ndevs = 0;
+	INIT_LIST_HEAD(&host_driver->edev_list);
+
+	rc = refresh_exported_devices();
+	if (rc < 0)
+		return -1;
+
+	return 0;
+}
+
+int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
+{
+	char attr_name[] = "usbip_sockfd";
+	char sockfd_attr_path[SYSFS_PATH_MAX];
+	char sockfd_buff[30];
+	int ret;
+
+	if (edev->status != SDEV_ST_AVAILABLE) {
+		dbg("device not available: %s", edev->udev.busid);
+		switch (edev->status) {
+		case SDEV_ST_ERROR:
+			dbg("status SDEV_ST_ERROR");
+			break;
+		case SDEV_ST_USED:
+			dbg("status SDEV_ST_USED");
+			break;
+		default:
+			dbg("status unknown: 0x%x", edev->status);
+		}
+		return -1;
+	}
+
+	/* only the first interface is true */
+	snprintf(sockfd_attr_path, sizeof(sockfd_attr_path), "%s/%s",
+		 edev->udev.path, attr_name);
+
+	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
+
+	ret = write_sysfs_attribute(sockfd_attr_path, sockfd_buff,
+				    strlen(sockfd_buff));
+	if (ret < 0) {
+		err("write_sysfs_attribute failed: sockfd %s to %s",
+		    sockfd_buff, sockfd_attr_path);
+		return ret;
+	}
+
+	info("connect: %s", edev->udev.busid);
+
+	return ret;
+}
+
+struct usbip_exported_device *usbip_host_get_device(int num)
+{
+	struct list_head *i;
+	struct usbip_exported_device *edev;
+	int cnt = 0;
+
+	list_for_each(i, &host_driver->edev_list) {
+		edev = list_entry(i, struct usbip_exported_device, node);
+		if (num == cnt)
+			return edev;
+		else
+			cnt++;
+	}
+
+	return NULL;
+}
diff --git a/tools/usb/usbip/libsrc/usbip_host_driver.h b/tools/usb/usbip/libsrc/usbip_host_driver.h
new file mode 100644
index 0000000..2a31f85
--- /dev/null
+++ b/tools/usb/usbip/libsrc/usbip_host_driver.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __USBIP_HOST_DRIVER_H
+#define __USBIP_HOST_DRIVER_H
+
+#include <stdint.h>
+#include "usbip_common.h"
+#include "list.h"
+
+struct usbip_host_driver {
+	int ndevs;
+	/* list of exported device */
+	struct list_head edev_list;
+};
+
+struct usbip_exported_device {
+	struct udev_device *sudev;
+	int32_t status;
+	struct usbip_usb_device udev;
+	struct list_head node;
+	struct usbip_usb_interface uinf[];
+};
+
+extern struct usbip_host_driver *host_driver;
+
+int usbip_host_driver_open(void);
+void usbip_host_driver_close(void);
+
+int usbip_host_refresh_device_list(void);
+int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd);
+struct usbip_exported_device *usbip_host_get_device(int num);
+
+#endif /* __USBIP_HOST_DRIVER_H */
diff --git a/tools/usb/usbip/libsrc/vhci_driver.c b/tools/usb/usbip/libsrc/vhci_driver.c
new file mode 100644
index 0000000..8901fcb
--- /dev/null
+++ b/tools/usb/usbip/libsrc/vhci_driver.c
@@ -0,0 +1,411 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include "usbip_common.h"
+#include "vhci_driver.h"
+#include <limits.h>
+#include <netdb.h>
+#include <libudev.h>
+#include "sysfs_utils.h"
+
+#undef  PROGNAME
+#define PROGNAME "libusbip"
+
+struct usbip_vhci_driver *vhci_driver;
+struct udev *udev_context;
+
+static struct usbip_imported_device *
+imported_device_init(struct usbip_imported_device *idev, char *busid)
+{
+	struct udev_device *sudev;
+
+	sudev = udev_device_new_from_subsystem_sysname(udev_context,
+						       "usb", busid);
+	if (!sudev) {
+		dbg("udev_device_new_from_subsystem_sysname failed: %s", busid);
+		goto err;
+	}
+	read_usb_device(sudev, &idev->udev);
+	udev_device_unref(sudev);
+
+	return idev;
+
+err:
+	return NULL;
+}
+
+
+
+static int parse_status(const char *value)
+{
+	int ret = 0;
+	char *c;
+
+
+	for (int i = 0; i < vhci_driver->nports; i++)
+		memset(&vhci_driver->idev[i], 0, sizeof(vhci_driver->idev[i]));
+
+
+	/* skip a header line */
+	c = strchr(value, '\n');
+	if (!c)
+		return -1;
+	c++;
+
+	while (*c != '\0') {
+		int port, status, speed, devid;
+		unsigned long socket;
+		char lbusid[SYSFS_BUS_ID_SIZE];
+
+		ret = sscanf(c, "%d %d %d %x %lx %31s\n",
+				&port, &status, &speed,
+				&devid, &socket, lbusid);
+
+		if (ret < 5) {
+			dbg("sscanf failed: %d", ret);
+			BUG();
+		}
+
+		dbg("port %d status %d speed %d devid %x",
+				port, status, speed, devid);
+		dbg("socket %lx lbusid %s", socket, lbusid);
+
+
+		/* if a device is connected, look at it */
+		{
+			struct usbip_imported_device *idev = &vhci_driver->idev[port];
+
+			idev->port	= port;
+			idev->status	= status;
+
+			idev->devid	= devid;
+
+			idev->busnum	= (devid >> 16);
+			idev->devnum	= (devid & 0x0000ffff);
+
+			if (idev->status != VDEV_ST_NULL
+			    && idev->status != VDEV_ST_NOTASSIGNED) {
+				idev = imported_device_init(idev, lbusid);
+				if (!idev) {
+					dbg("imported_device_init failed");
+					return -1;
+				}
+			}
+		}
+
+
+		/* go to the next line */
+		c = strchr(c, '\n');
+		if (!c)
+			break;
+		c++;
+	}
+
+	dbg("exit");
+
+	return 0;
+}
+
+static int refresh_imported_device_list(void)
+{
+	const char *attr_status;
+
+	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
+					       "status");
+	if (!attr_status) {
+		err("udev_device_get_sysattr_value failed");
+		return -1;
+	}
+
+	return parse_status(attr_status);
+}
+
+static int get_nports(void)
+{
+	char *c;
+	int nports = 0;
+	const char *attr_status;
+
+	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
+					       "status");
+	if (!attr_status) {
+		err("udev_device_get_sysattr_value failed");
+		return -1;
+	}
+
+	/* skip a header line */
+	c = strchr(attr_status, '\n');
+	if (!c)
+		return 0;
+	c++;
+
+	while (*c != '\0') {
+		/* go to the next line */
+		c = strchr(c, '\n');
+		if (!c)
+			return nports;
+		c++;
+		nports += 1;
+	}
+
+	return nports;
+}
+
+/*
+ * Read the given port's record.
+ *
+ * To avoid buffer overflow we will read the entire line and
+ * validate each part's size. The initial buffer is padded by 4 to
+ * accommodate the 2 spaces, 1 newline and an additional character
+ * which is needed to properly validate the 3rd part without it being
+ * truncated to an acceptable length.
+ */
+static int read_record(int rhport, char *host, unsigned long host_len,
+		char *port, unsigned long port_len, char *busid)
+{
+	int part;
+	FILE *file;
+	char path[PATH_MAX+1];
+	char *buffer, *start, *end;
+	char delim[] = {' ', ' ', '\n'};
+	int max_len[] = {(int)host_len, (int)port_len, SYSFS_BUS_ID_SIZE};
+	size_t buffer_len = host_len + port_len + SYSFS_BUS_ID_SIZE + 4;
+
+	buffer = malloc(buffer_len);
+	if (!buffer)
+		return -1;
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	file = fopen(path, "r");
+	if (!file) {
+		err("fopen");
+		free(buffer);
+		return -1;
+	}
+
+	if (fgets(buffer, buffer_len, file) == NULL) {
+		err("fgets");
+		free(buffer);
+		fclose(file);
+		return -1;
+	}
+	fclose(file);
+
+	/* validate the length of each of the 3 parts */
+	start = buffer;
+	for (part = 0; part < 3; part++) {
+		end = strchr(start, delim[part]);
+		if (end == NULL || (end - start) > max_len[part]) {
+			free(buffer);
+			return -1;
+		}
+		start = end + 1;
+	}
+
+	if (sscanf(buffer, "%s %s %s\n", host, port, busid) != 3) {
+		err("sscanf");
+		free(buffer);
+		return -1;
+	}
+
+	free(buffer);
+
+	return 0;
+}
+
+/* ---------------------------------------------------------------------- */
+
+int usbip_vhci_driver_open(void)
+{
+	udev_context = udev_new();
+	if (!udev_context) {
+		err("udev_new failed");
+		return -1;
+	}
+
+	vhci_driver = calloc(1, sizeof(struct usbip_vhci_driver));
+
+	/* will be freed in usbip_driver_close() */
+	vhci_driver->hc_device =
+		udev_device_new_from_subsystem_sysname(udev_context,
+						       USBIP_VHCI_BUS_TYPE,
+						       USBIP_VHCI_DRV_NAME);
+	if (!vhci_driver->hc_device) {
+		err("udev_device_new_from_subsystem_sysname failed");
+		goto err;
+	}
+
+	vhci_driver->nports = get_nports();
+
+	dbg("available ports: %d", vhci_driver->nports);
+
+	if (refresh_imported_device_list())
+		goto err;
+
+	return 0;
+
+err:
+	udev_device_unref(vhci_driver->hc_device);
+
+	if (vhci_driver)
+		free(vhci_driver);
+
+	vhci_driver = NULL;
+
+	udev_unref(udev_context);
+
+	return -1;
+}
+
+
+void usbip_vhci_driver_close()
+{
+	if (!vhci_driver)
+		return;
+
+	udev_device_unref(vhci_driver->hc_device);
+
+	free(vhci_driver);
+
+	vhci_driver = NULL;
+
+	udev_unref(udev_context);
+}
+
+
+int usbip_vhci_refresh_device_list(void)
+{
+
+	if (refresh_imported_device_list())
+		goto err;
+
+	return 0;
+err:
+	dbg("failed to refresh device list");
+	return -1;
+}
+
+
+int usbip_vhci_get_free_port(void)
+{
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		if (vhci_driver->idev[i].status == VDEV_ST_NULL)
+			return i;
+	}
+
+	return -1;
+}
+
+int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
+		uint32_t speed) {
+	char buff[200]; /* what size should be ? */
+	char attach_attr_path[SYSFS_PATH_MAX];
+	char attr_attach[] = "attach";
+	const char *path;
+	int ret;
+
+	snprintf(buff, sizeof(buff), "%u %d %u %u",
+			port, sockfd, devid, speed);
+	dbg("writing: %s", buff);
+
+	path = udev_device_get_syspath(vhci_driver->hc_device);
+	snprintf(attach_attr_path, sizeof(attach_attr_path), "%s/%s",
+		 path, attr_attach);
+	dbg("attach attribute path: %s", attach_attr_path);
+
+	ret = write_sysfs_attribute(attach_attr_path, buff, strlen(buff));
+	if (ret < 0) {
+		dbg("write_sysfs_attribute failed");
+		return -1;
+	}
+
+	dbg("attached port: %d", port);
+
+	return 0;
+}
+
+static unsigned long get_devid(uint8_t busnum, uint8_t devnum)
+{
+	return (busnum << 16) | devnum;
+}
+
+/* will be removed */
+int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
+		uint8_t devnum, uint32_t speed)
+{
+	int devid = get_devid(busnum, devnum);
+
+	return usbip_vhci_attach_device2(port, sockfd, devid, speed);
+}
+
+int usbip_vhci_detach_device(uint8_t port)
+{
+	char detach_attr_path[SYSFS_PATH_MAX];
+	char attr_detach[] = "detach";
+	char buff[200]; /* what size should be ? */
+	const char *path;
+	int ret;
+
+	snprintf(buff, sizeof(buff), "%u", port);
+	dbg("writing: %s", buff);
+
+	path = udev_device_get_syspath(vhci_driver->hc_device);
+	snprintf(detach_attr_path, sizeof(detach_attr_path), "%s/%s",
+		 path, attr_detach);
+	dbg("detach attribute path: %s", detach_attr_path);
+
+	ret = write_sysfs_attribute(detach_attr_path, buff, strlen(buff));
+	if (ret < 0) {
+		dbg("write_sysfs_attribute failed");
+		return -1;
+	}
+
+	dbg("detached port: %d", port);
+
+	return 0;
+}
+
+int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
+{
+	char product_name[100];
+	char host[NI_MAXHOST] = "unknown host";
+	char serv[NI_MAXSERV] = "unknown port";
+	char remote_busid[SYSFS_BUS_ID_SIZE];
+	int ret;
+	int read_record_error = 0;
+
+	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED)
+		return 0;
+
+	ret = read_record(idev->port, host, sizeof(host), serv, sizeof(serv),
+			  remote_busid);
+	if (ret) {
+		err("read_record");
+		read_record_error = 1;
+	}
+
+	printf("Port %02d: <%s> at %s\n", idev->port,
+	       usbip_status_string(idev->status),
+	       usbip_speed_string(idev->udev.speed));
+
+	usbip_names_get_product(product_name, sizeof(product_name),
+				idev->udev.idVendor, idev->udev.idProduct);
+
+	printf("       %s\n",  product_name);
+
+	if (!read_record_error) {
+		printf("%10s -> usbip://%s:%s/%s\n", idev->udev.busid,
+		       host, serv, remote_busid);
+		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
+		       idev->busnum, idev->devnum);
+	} else {
+		printf("%10s -> unknown host, remote port and remote busid\n",
+		       idev->udev.busid);
+		printf("%10s -> remote bus/dev %03d/%03d\n", " ",
+		       idev->busnum, idev->devnum);
+	}
+
+	return 0;
+}
diff --git a/tools/usb/usbip/libsrc/vhci_driver.h b/tools/usb/usbip/libsrc/vhci_driver.h
new file mode 100644
index 0000000..fa2316c
--- /dev/null
+++ b/tools/usb/usbip/libsrc/vhci_driver.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef __VHCI_DRIVER_H
+#define __VHCI_DRIVER_H
+
+#include <libudev.h>
+#include <stdint.h>
+
+#include "usbip_common.h"
+
+#define USBIP_VHCI_BUS_TYPE "platform"
+#define MAXNPORT 128
+
+struct usbip_imported_device {
+	uint8_t port;
+	uint32_t status;
+
+	uint32_t devid;
+
+	uint8_t busnum;
+	uint8_t devnum;
+
+	/* usbip_class_device list */
+	struct usbip_usb_device udev;
+};
+
+struct usbip_vhci_driver {
+
+	/* /sys/devices/platform/vhci_hcd */
+	struct udev_device *hc_device;
+
+	int nports;
+	struct usbip_imported_device idev[MAXNPORT];
+};
+
+
+extern struct usbip_vhci_driver *vhci_driver;
+
+int usbip_vhci_driver_open(void);
+void usbip_vhci_driver_close(void);
+
+int  usbip_vhci_refresh_device_list(void);
+
+
+int usbip_vhci_get_free_port(void);
+int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
+		uint32_t speed);
+
+/* will be removed */
+int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
+		uint8_t devnum, uint32_t speed);
+
+int usbip_vhci_detach_device(uint8_t port);
+
+int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev);
+
+#endif /* __VHCI_DRIVER_H */
diff --git a/tools/usb/usbip/src/Makefile.am b/tools/usb/usbip/src/Makefile.am
new file mode 100644
index 0000000..e81a4eb
--- /dev/null
+++ b/tools/usb/usbip/src/Makefile.am
@@ -0,0 +1,11 @@
+AM_CPPFLAGS = -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+AM_CFLAGS   = @EXTRA_CFLAGS@
+LDADD       = $(top_builddir)/libsrc/libusbip.la
+
+sbin_PROGRAMS := usbip usbipd
+
+usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
+		 usbip_attach.c usbip_detach.c usbip_list.c \
+		 usbip_bind.c usbip_unbind.c usbip_port.c
+
+usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
diff --git a/tools/usb/usbip/src/usbip.c b/tools/usb/usbip/src/usbip.c
new file mode 100644
index 0000000..d7599d9
--- /dev/null
+++ b/tools/usb/usbip/src/usbip.c
@@ -0,0 +1,201 @@
+/*
+ * command structure borrowed from udev
+ * (git://git.kernel.org/pub/scm/linux/hotplug/udev.git)
+ *
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <getopt.h>
+#include <syslog.h>
+
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static int usbip_help(int argc, char *argv[]);
+static int usbip_version(int argc, char *argv[]);
+
+static const char usbip_version_string[] = PACKAGE_STRING;
+
+static const char usbip_usage_string[] =
+	"usbip [--debug] [--log] [--tcp-port PORT] [version]\n"
+	"             [help] <command> <args>\n";
+
+static void usbip_usage(void)
+{
+	printf("usage: %s", usbip_usage_string);
+}
+
+struct command {
+	const char *name;
+	int (*fn)(int argc, char *argv[]);
+	const char *help;
+	void (*usage)(void);
+};
+
+static const struct command cmds[] = {
+	{
+		.name  = "help",
+		.fn    = usbip_help,
+		.help  = NULL,
+		.usage = NULL
+	},
+	{
+		.name  = "version",
+		.fn    = usbip_version,
+		.help  = NULL,
+		.usage = NULL
+	},
+	{
+		.name  = "attach",
+		.fn    = usbip_attach,
+		.help  = "Attach a remote USB device",
+		.usage = usbip_attach_usage
+	},
+	{
+		.name  = "detach",
+		.fn    = usbip_detach,
+		.help  = "Detach a remote USB device",
+		.usage = usbip_detach_usage
+	},
+	{
+		.name  = "list",
+		.fn    = usbip_list,
+		.help  = "List exportable or local USB devices",
+		.usage = usbip_list_usage
+	},
+	{
+		.name  = "bind",
+		.fn    = usbip_bind,
+		.help  = "Bind device to " USBIP_HOST_DRV_NAME ".ko",
+		.usage = usbip_bind_usage
+	},
+	{
+		.name  = "unbind",
+		.fn    = usbip_unbind,
+		.help  = "Unbind device from " USBIP_HOST_DRV_NAME ".ko",
+		.usage = usbip_unbind_usage
+	},
+	{
+		.name  = "port",
+		.fn    = usbip_port_show,
+		.help  = "Show imported USB devices",
+		.usage = NULL
+	},
+	{ NULL, NULL, NULL, NULL }
+};
+
+static int usbip_help(int argc, char *argv[])
+{
+	const struct command *cmd;
+	int i;
+	int ret = 0;
+
+	if (argc > 1 && argv++) {
+		for (i = 0; cmds[i].name != NULL; i++)
+			if (!strcmp(cmds[i].name, argv[0]) && cmds[i].usage) {
+				cmds[i].usage();
+				goto done;
+			}
+		ret = -1;
+	}
+
+	usbip_usage();
+	printf("\n");
+	for (cmd = cmds; cmd->name != NULL; cmd++)
+		if (cmd->help != NULL)
+			printf("  %-10s %s\n", cmd->name, cmd->help);
+	printf("\n");
+done:
+	return ret;
+}
+
+static int usbip_version(int argc, char *argv[])
+{
+	(void) argc;
+	(void) argv;
+
+	printf(PROGNAME " (%s)\n", usbip_version_string);
+	return 0;
+}
+
+static int run_command(const struct command *cmd, int argc, char *argv[])
+{
+	dbg("running command: `%s'", cmd->name);
+	return cmd->fn(argc, argv);
+}
+
+int main(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "debug",    no_argument,       NULL, 'd' },
+		{ "log",      no_argument,       NULL, 'l' },
+		{ "tcp-port", required_argument, NULL, 't' },
+		{ NULL,       0,                 NULL,  0  }
+	};
+
+	char *cmd;
+	int opt;
+	int i, rc = -1;
+
+	usbip_use_stderr = 1;
+	opterr = 0;
+	for (;;) {
+		opt = getopt_long(argc, argv, "+dlt:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'd':
+			usbip_use_debug = 1;
+			break;
+		case 'l':
+			usbip_use_syslog = 1;
+			openlog("", LOG_PID, LOG_USER);
+			break;
+		case 't':
+			usbip_setup_port_number(optarg);
+			break;
+		case '?':
+			printf("usbip: invalid option\n");
+		default:
+			usbip_usage();
+			goto out;
+		}
+	}
+
+	cmd = argv[optind];
+	if (cmd) {
+		for (i = 0; cmds[i].name != NULL; i++)
+			if (!strcmp(cmds[i].name, cmd)) {
+				argc -= optind;
+				argv += optind;
+				optind = 0;
+				rc = run_command(&cmds[i], argc, argv);
+				goto out;
+			}
+	}
+
+	/* invalid command */
+	usbip_help(0, NULL);
+out:
+	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
+}
diff --git a/tools/usb/usbip/src/usbip.h b/tools/usb/usbip/src/usbip.h
new file mode 100644
index 0000000..84fe66a
--- /dev/null
+++ b/tools/usb/usbip/src/usbip.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __USBIP_H
+#define __USBIP_H
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+/* usbip commands */
+int usbip_attach(int argc, char *argv[]);
+int usbip_detach(int argc, char *argv[]);
+int usbip_list(int argc, char *argv[]);
+int usbip_bind(int argc, char *argv[]);
+int usbip_unbind(int argc, char *argv[]);
+int usbip_port_show(int argc, char *argv[]);
+
+void usbip_attach_usage(void);
+void usbip_detach_usage(void);
+void usbip_list_usage(void);
+void usbip_bind_usage(void);
+void usbip_unbind_usage(void);
+
+#endif /* __USBIP_H */
diff --git a/tools/usb/usbip/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
new file mode 100644
index 0000000..716a79e
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_attach.c
@@ -0,0 +1,240 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/stat.h>
+
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <fcntl.h>
+#include <getopt.h>
+#include <unistd.h>
+#include <errno.h>
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static const char usbip_attach_usage_string[] =
+	"usbip attach <args>\n"
+	"    -r, --remote=<host>      The machine with exported USB devices\n"
+	"    -b, --busid=<busid>    Busid of the device on <host>\n";
+
+void usbip_attach_usage(void)
+{
+	printf("usage: %s", usbip_attach_usage_string);
+}
+
+#define MAX_BUFF 100
+static int record_connection(char *host, char *port, char *busid, int rhport)
+{
+	int fd;
+	char path[PATH_MAX+1];
+	char buff[MAX_BUFF+1];
+	int ret;
+
+	ret = mkdir(VHCI_STATE_PATH, 0700);
+	if (ret < 0) {
+		/* if VHCI_STATE_PATH exists, then it better be a directory */
+		if (errno == EEXIST) {
+			struct stat s;
+			ret = stat(VHCI_STATE_PATH, &s);
+			if (ret < 0)
+				return -1;
+			if (!(s.st_mode & S_IFDIR))
+				return -1;
+		} else
+			return -1;
+	}
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
+	if (fd < 0)
+		return -1;
+
+	snprintf(buff, MAX_BUFF, "%s %s %s\n",
+			host, port, busid);
+
+	ret = write(fd, buff, strlen(buff));
+	if (ret != (ssize_t) strlen(buff)) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int import_device(int sockfd, struct usbip_usb_device *udev)
+{
+	int rc;
+	int port;
+
+	rc = usbip_vhci_driver_open();
+	if (rc < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	port = usbip_vhci_get_free_port();
+	if (port < 0) {
+		err("no free port");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
+				      udev->devnum, udev->speed);
+	if (rc < 0) {
+		err("import device");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return port;
+}
+
+static int query_import_device(int sockfd, char *busid)
+{
+	int rc;
+	struct op_import_request request;
+	struct op_import_reply   reply;
+	uint16_t code = OP_REP_IMPORT;
+
+	memset(&request, 0, sizeof(request));
+	memset(&reply, 0, sizeof(reply));
+
+	/* send a request */
+	rc = usbip_net_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	if (rc < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
+
+	PACK_OP_IMPORT_REQUEST(0, &request);
+
+	rc = usbip_net_send(sockfd, (void *) &request, sizeof(request));
+	if (rc < 0) {
+		err("send op_import_request");
+		return -1;
+	}
+
+	/* receive a reply */
+	rc = usbip_net_recv_op_common(sockfd, &code);
+	if (rc < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	rc = usbip_net_recv(sockfd, (void *) &reply, sizeof(reply));
+	if (rc < 0) {
+		err("recv op_import_reply");
+		return -1;
+	}
+
+	PACK_OP_IMPORT_REPLY(0, &reply);
+
+	/* check the reply */
+	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
+		err("recv different busid %s", reply.udev.busid);
+		return -1;
+	}
+
+	/* import a device */
+	return import_device(sockfd, &reply.udev);
+}
+
+static int attach_device(char *host, char *busid)
+{
+	int sockfd;
+	int rc;
+	int rhport;
+
+	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
+	if (sockfd < 0) {
+		err("tcp connect");
+		return -1;
+	}
+
+	rhport = query_import_device(sockfd, busid);
+	if (rhport < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+
+	rc = record_connection(host, usbip_port_string, busid, rhport);
+	if (rc < 0) {
+		err("record connection");
+		return -1;
+	}
+
+	return 0;
+}
+
+int usbip_attach(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "remote", required_argument, NULL, 'r' },
+		{ "busid",  required_argument, NULL, 'b' },
+		{ NULL, 0,  NULL, 0 }
+	};
+	char *host = NULL;
+	char *busid = NULL;
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "r:b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'r':
+			host = optarg;
+			break;
+		case 'b':
+			busid = optarg;
+			break;
+		default:
+			goto err_out;
+		}
+	}
+
+	if (!host || !busid)
+		goto err_out;
+
+	ret = attach_device(host, busid);
+	goto out;
+
+err_out:
+	usbip_attach_usage();
+out:
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbip_bind.c b/tools/usb/usbip/src/usbip_bind.c
new file mode 100644
index 0000000..fa46141
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_bind.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <libudev.h>
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <getopt.h>
+
+#include "usbip_common.h"
+#include "utils.h"
+#include "usbip.h"
+#include "sysfs_utils.h"
+
+enum unbind_status {
+	UNBIND_ST_OK,
+	UNBIND_ST_USBIP_HOST,
+	UNBIND_ST_FAILED
+};
+
+static const char usbip_bind_usage_string[] =
+	"usbip bind <args>\n"
+	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
+	"on <busid>\n";
+
+void usbip_bind_usage(void)
+{
+	printf("usage: %s", usbip_bind_usage_string);
+}
+
+/* call at unbound state */
+static int bind_usbip(char *busid)
+{
+	char attr_name[] = "bind";
+	char bind_attr_path[SYSFS_PATH_MAX];
+	int rc = -1;
+
+	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
+
+	rc = write_sysfs_attribute(bind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		err("error binding device %s to driver: %s", busid,
+		    strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+/* buggy driver may cause dead lock */
+static int unbind_other(char *busid)
+{
+	enum unbind_status status = UNBIND_ST_OK;
+
+	char attr_name[] = "unbind";
+	char unbind_attr_path[SYSFS_PATH_MAX];
+	int rc = -1;
+
+	struct udev *udev;
+	struct udev_device *dev;
+	const char *driver;
+	const char *bDevClass;
+
+	/* Create libudev context. */
+	udev = udev_new();
+
+	/* Get the device. */
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		dbg("unable to find device with bus ID %s", busid);
+		goto err_close_busid_dev;
+	}
+
+	/* Check what kind of device it is. */
+	bDevClass  = udev_device_get_sysattr_value(dev, "bDeviceClass");
+	if (!bDevClass) {
+		dbg("unable to get bDevClass device attribute");
+		goto err_close_busid_dev;
+	}
+
+	if (!strncmp(bDevClass, "09", strlen(bDevClass))) {
+		dbg("skip unbinding of hub");
+		goto err_close_busid_dev;
+	}
+
+	/* Get the device driver. */
+	driver = udev_device_get_driver(dev);
+	if (!driver) {
+		/* No driver bound to this device. */
+		goto out;
+	}
+
+	if (!strncmp(USBIP_HOST_DRV_NAME, driver,
+				strlen(USBIP_HOST_DRV_NAME))) {
+		/* Already bound to usbip-host. */
+		status = UNBIND_ST_USBIP_HOST;
+		goto out;
+	}
+
+	/* Unbind device from driver. */
+	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
+		 SYSFS_DRIVERS_NAME, driver, attr_name);
+
+	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		err("error unbinding device %s from driver", busid);
+		goto err_close_busid_dev;
+	}
+
+	goto out;
+
+err_close_busid_dev:
+	status = UNBIND_ST_FAILED;
+out:
+	udev_device_unref(dev);
+	udev_unref(udev);
+
+	return status;
+}
+
+static int bind_device(char *busid)
+{
+	int rc;
+	struct udev *udev;
+	struct udev_device *dev;
+
+	/* Check whether the device with this bus ID exists. */
+	udev = udev_new();
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		err("device with the specified bus ID does not exist");
+		return -1;
+	}
+	udev_unref(udev);
+
+	rc = unbind_other(busid);
+	if (rc == UNBIND_ST_FAILED) {
+		err("could not unbind driver from device on busid %s", busid);
+		return -1;
+	} else if (rc == UNBIND_ST_USBIP_HOST) {
+		err("device on busid %s is already bound to %s", busid,
+		    USBIP_HOST_DRV_NAME);
+		return -1;
+	}
+
+	rc = modify_match_busid(busid, 1);
+	if (rc < 0) {
+		err("unable to bind device on %s", busid);
+		return -1;
+	}
+
+	rc = bind_usbip(busid);
+	if (rc < 0) {
+		err("could not bind device to %s", USBIP_HOST_DRV_NAME);
+		modify_match_busid(busid, 0);
+		return -1;
+	}
+
+	info("bind device on busid %s: complete", busid);
+
+	return 0;
+}
+
+int usbip_bind(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "busid", required_argument, NULL, 'b' },
+		{ NULL,    0,                 NULL,  0  }
+	};
+
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'b':
+			ret = bind_device(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_bind_usage();
+out:
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbip_detach.c b/tools/usb/usbip/src/usbip_detach.c
new file mode 100644
index 0000000..05c6d15
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_detach.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <ctype.h>
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <getopt.h>
+#include <unistd.h>
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static const char usbip_detach_usage_string[] =
+	"usbip detach <args>\n"
+	"    -p, --port=<port>    " USBIP_VHCI_DRV_NAME
+	" port the device is on\n";
+
+void usbip_detach_usage(void)
+{
+	printf("usage: %s", usbip_detach_usage_string);
+}
+
+static int detach_port(char *port)
+{
+	int ret;
+	uint8_t portnum;
+	char path[PATH_MAX+1];
+
+	for (unsigned int i = 0; i < strlen(port); i++)
+		if (!isdigit(port[i])) {
+			err("invalid port %s", port);
+			return -1;
+		}
+
+	/* check max port */
+
+	portnum = atoi(port);
+
+	/* remove the port state file */
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", portnum);
+
+	remove(path);
+	rmdir(VHCI_STATE_PATH);
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	ret = usbip_vhci_detach_device(portnum);
+	if (ret < 0)
+		return -1;
+
+	usbip_vhci_driver_close();
+
+	return ret;
+}
+
+int usbip_detach(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "port", required_argument, NULL, 'p' },
+		{ NULL, 0, NULL, 0 }
+	};
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "p:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'p':
+			ret = detach_port(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_detach_usage();
+out:
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbip_list.c b/tools/usb/usbip/src/usbip_list.c
new file mode 100644
index 0000000..d5ce34a
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_list.c
@@ -0,0 +1,283 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/types.h>
+#include <libudev.h>
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <getopt.h>
+#include <netdb.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static const char usbip_list_usage_string[] =
+	"usbip list [-p|--parsable] <args>\n"
+	"    -p, --parsable         Parsable list format\n"
+	"    -r, --remote=<host>    List the exportable USB devices on <host>\n"
+	"    -l, --local            List the local USB devices\n";
+
+void usbip_list_usage(void)
+{
+	printf("usage: %s", usbip_list_usage_string);
+}
+
+static int get_exported_devices(char *host, int sockfd)
+{
+	char product_name[100];
+	char class_name[100];
+	struct op_devlist_reply reply;
+	uint16_t code = OP_REP_DEVLIST;
+	struct usbip_usb_device udev;
+	struct usbip_usb_interface uintf;
+	unsigned int i;
+	int rc, j;
+
+	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	if (rc < 0) {
+		dbg("usbip_net_send_op_common failed");
+		return -1;
+	}
+
+	rc = usbip_net_recv_op_common(sockfd, &code);
+	if (rc < 0) {
+		dbg("usbip_net_recv_op_common failed");
+		return -1;
+	}
+
+	memset(&reply, 0, sizeof(reply));
+	rc = usbip_net_recv(sockfd, &reply, sizeof(reply));
+	if (rc < 0) {
+		dbg("usbip_net_recv_op_devlist failed");
+		return -1;
+	}
+	PACK_OP_DEVLIST_REPLY(0, &reply);
+	dbg("exportable devices: %d\n", reply.ndev);
+
+	if (reply.ndev == 0) {
+		info("no exportable devices found on %s", host);
+		return 0;
+	}
+
+	printf("Exportable USB devices\n");
+	printf("======================\n");
+	printf(" - %s\n", host);
+
+	for (i = 0; i < reply.ndev; i++) {
+		memset(&udev, 0, sizeof(udev));
+		rc = usbip_net_recv(sockfd, &udev, sizeof(udev));
+		if (rc < 0) {
+			dbg("usbip_net_recv failed: usbip_usb_device[%d]", i);
+			return -1;
+		}
+		usbip_net_pack_usb_device(0, &udev);
+
+		usbip_names_get_product(product_name, sizeof(product_name),
+					udev.idVendor, udev.idProduct);
+		usbip_names_get_class(class_name, sizeof(class_name),
+				      udev.bDeviceClass, udev.bDeviceSubClass,
+				      udev.bDeviceProtocol);
+		printf("%11s: %s\n", udev.busid, product_name);
+		printf("%11s: %s\n", "", udev.path);
+		printf("%11s: %s\n", "", class_name);
+
+		for (j = 0; j < udev.bNumInterfaces; j++) {
+			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
+			if (rc < 0) {
+				err("usbip_net_recv failed: usbip_usb_intf[%d]",
+						j);
+
+				return -1;
+			}
+			usbip_net_pack_usb_interface(0, &uintf);
+
+			usbip_names_get_class(class_name, sizeof(class_name),
+					uintf.bInterfaceClass,
+					uintf.bInterfaceSubClass,
+					uintf.bInterfaceProtocol);
+			printf("%11s: %2d - %s\n", "", j, class_name);
+		}
+
+		printf("\n");
+	}
+
+	return 0;
+}
+
+static int list_exported_devices(char *host)
+{
+	int rc;
+	int sockfd;
+
+	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
+	if (sockfd < 0) {
+		err("could not connect to %s:%s: %s", host,
+		    usbip_port_string, gai_strerror(sockfd));
+		return -1;
+	}
+	dbg("connected to %s:%s", host, usbip_port_string);
+
+	rc = get_exported_devices(host, sockfd);
+	if (rc < 0) {
+		err("failed to get device list from %s", host);
+		return -1;
+	}
+
+	close(sockfd);
+
+	return 0;
+}
+
+static void print_device(const char *busid, const char *vendor,
+			 const char *product, bool parsable)
+{
+	if (parsable)
+		printf("busid=%s#usbid=%.4s:%.4s#", busid, vendor, product);
+	else
+		printf(" - busid %s (%.4s:%.4s)\n", busid, vendor, product);
+}
+
+static void print_product_name(char *product_name, bool parsable)
+{
+	if (!parsable)
+		printf("   %s\n", product_name);
+}
+
+static int list_devices(bool parsable)
+{
+	struct udev *udev;
+	struct udev_enumerate *enumerate;
+	struct udev_list_entry *devices, *dev_list_entry;
+	struct udev_device *dev;
+	const char *path;
+	const char *idVendor;
+	const char *idProduct;
+	const char *bConfValue;
+	const char *bNumIntfs;
+	const char *busid;
+	char product_name[128];
+	int ret = -1;
+
+	/* Create libudev context. */
+	udev = udev_new();
+
+	/* Create libudev device enumeration. */
+	enumerate = udev_enumerate_new(udev);
+
+	/* Take only USB devices that are not hubs and do not have
+	 * the bInterfaceNumber attribute, i.e. are not interfaces.
+	 */
+	udev_enumerate_add_match_subsystem(enumerate, "usb");
+	udev_enumerate_add_nomatch_sysattr(enumerate, "bDeviceClass", "09");
+	udev_enumerate_add_nomatch_sysattr(enumerate, "bInterfaceNumber", NULL);
+	udev_enumerate_scan_devices(enumerate);
+
+	devices = udev_enumerate_get_list_entry(enumerate);
+
+	/* Show information about each device. */
+	udev_list_entry_foreach(dev_list_entry, devices) {
+		path = udev_list_entry_get_name(dev_list_entry);
+		dev = udev_device_new_from_syspath(udev, path);
+
+		/* Get device information. */
+		idVendor = udev_device_get_sysattr_value(dev, "idVendor");
+		idProduct = udev_device_get_sysattr_value(dev, "idProduct");
+		bConfValue = udev_device_get_sysattr_value(dev, "bConfigurationValue");
+		bNumIntfs = udev_device_get_sysattr_value(dev, "bNumInterfaces");
+		busid = udev_device_get_sysname(dev);
+		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs) {
+			err("problem getting device attributes: %s",
+			    strerror(errno));
+			goto err_out;
+		}
+
+		/* Get product name. */
+		usbip_names_get_product(product_name, sizeof(product_name),
+					strtol(idVendor, NULL, 16),
+					strtol(idProduct, NULL, 16));
+
+		/* Print information. */
+		print_device(busid, idVendor, idProduct, parsable);
+		print_product_name(product_name, parsable);
+
+		printf("\n");
+
+		udev_device_unref(dev);
+	}
+
+	ret = 0;
+
+err_out:
+	udev_enumerate_unref(enumerate);
+	udev_unref(udev);
+
+	return ret;
+}
+
+int usbip_list(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "parsable", no_argument,       NULL, 'p' },
+		{ "remote",   required_argument, NULL, 'r' },
+		{ "local",    no_argument,       NULL, 'l' },
+		{ NULL,       0,                 NULL,  0  }
+	};
+
+	bool parsable = false;
+	int opt;
+	int ret = -1;
+
+	if (usbip_names_init(USBIDS_FILE))
+		err("failed to open %s", USBIDS_FILE);
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "pr:l", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'p':
+			parsable = true;
+			break;
+		case 'r':
+			ret = list_exported_devices(optarg);
+			goto out;
+		case 'l':
+			ret = list_devices(parsable);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_list_usage();
+out:
+	usbip_names_free();
+
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
new file mode 100644
index 0000000..b4c37e7
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_network.c
@@ -0,0 +1,303 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/socket.h>
+
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <netinet/tcp.h>
+#include <unistd.h>
+
+#ifdef HAVE_LIBWRAP
+#include <tcpd.h>
+#endif
+
+#include "usbip_common.h"
+#include "usbip_network.h"
+
+int usbip_port = 3240;
+char *usbip_port_string = "3240";
+
+void usbip_setup_port_number(char *arg)
+{
+	dbg("parsing port arg '%s'", arg);
+	char *end;
+	unsigned long int port = strtoul(arg, &end, 10);
+
+	if (end == arg) {
+		err("port: could not parse '%s' as a decimal integer", arg);
+		return;
+	}
+
+	if (*end != '\0') {
+		err("port: garbage at end of '%s'", arg);
+		return;
+	}
+
+	if (port > UINT16_MAX) {
+		err("port: %s too high (max=%d)",
+		    arg, UINT16_MAX);
+		return;
+	}
+
+	usbip_port = port;
+	usbip_port_string = arg;
+	info("using port %d (\"%s\")", usbip_port, usbip_port_string);
+}
+
+void usbip_net_pack_uint32_t(int pack, uint32_t *num)
+{
+	uint32_t i;
+
+	if (pack)
+		i = htonl(*num);
+	else
+		i = ntohl(*num);
+
+	*num = i;
+}
+
+void usbip_net_pack_uint16_t(int pack, uint16_t *num)
+{
+	uint16_t i;
+
+	if (pack)
+		i = htons(*num);
+	else
+		i = ntohs(*num);
+
+	*num = i;
+}
+
+void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev)
+{
+	usbip_net_pack_uint32_t(pack, &udev->busnum);
+	usbip_net_pack_uint32_t(pack, &udev->devnum);
+	usbip_net_pack_uint32_t(pack, &udev->speed);
+
+	usbip_net_pack_uint16_t(pack, &udev->idVendor);
+	usbip_net_pack_uint16_t(pack, &udev->idProduct);
+	usbip_net_pack_uint16_t(pack, &udev->bcdDevice);
+}
+
+void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
+				  struct usbip_usb_interface *udev
+				  __attribute__((unused)))
+{
+	/* uint8_t members need nothing */
+}
+
+static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
+			      int sending)
+{
+	ssize_t nbytes;
+	ssize_t total = 0;
+
+	if (!bufflen)
+		return 0;
+
+	do {
+		if (sending)
+			nbytes = send(sockfd, buff, bufflen, 0);
+		else
+			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
+
+		if (nbytes <= 0)
+			return -1;
+
+		buff	 = (void *)((intptr_t) buff + nbytes);
+		bufflen	-= nbytes;
+		total	+= nbytes;
+
+	} while (bufflen > 0);
+
+	return total;
+}
+
+ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen)
+{
+	return usbip_net_xmit(sockfd, buff, bufflen, 0);
+}
+
+ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen)
+{
+	return usbip_net_xmit(sockfd, buff, bufflen, 1);
+}
+
+int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
+{
+	struct op_common op_common;
+	int rc;
+
+	memset(&op_common, 0, sizeof(op_common));
+
+	op_common.version = USBIP_VERSION;
+	op_common.code    = code;
+	op_common.status  = status;
+
+	PACK_OP_COMMON(1, &op_common);
+
+	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
+	if (rc < 0) {
+		dbg("usbip_net_send failed: %d", rc);
+		return -1;
+	}
+
+	return 0;
+}
+
+int usbip_net_recv_op_common(int sockfd, uint16_t *code)
+{
+	struct op_common op_common;
+	int rc;
+
+	memset(&op_common, 0, sizeof(op_common));
+
+	rc = usbip_net_recv(sockfd, &op_common, sizeof(op_common));
+	if (rc < 0) {
+		dbg("usbip_net_recv failed: %d", rc);
+		goto err;
+	}
+
+	PACK_OP_COMMON(0, &op_common);
+
+	if (op_common.version != USBIP_VERSION) {
+		dbg("version mismatch: %d %d", op_common.version,
+		    USBIP_VERSION);
+		goto err;
+	}
+
+	switch (*code) {
+	case OP_UNSPEC:
+		break;
+	default:
+		if (op_common.code != *code) {
+			dbg("unexpected pdu %#0x for %#0x", op_common.code,
+			    *code);
+			goto err;
+		}
+	}
+
+	if (op_common.status != ST_OK) {
+		dbg("request failed at peer: %d", op_common.status);
+		goto err;
+	}
+
+	*code = op_common.code;
+
+	return 0;
+err:
+	return -1;
+}
+
+int usbip_net_set_reuseaddr(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	if (ret < 0)
+		dbg("setsockopt: SO_REUSEADDR");
+
+	return ret;
+}
+
+int usbip_net_set_nodelay(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+	if (ret < 0)
+		dbg("setsockopt: TCP_NODELAY");
+
+	return ret;
+}
+
+int usbip_net_set_keepalive(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &val, sizeof(val));
+	if (ret < 0)
+		dbg("setsockopt: SO_KEEPALIVE");
+
+	return ret;
+}
+
+int usbip_net_set_v6only(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, IPPROTO_IPV6, IPV6_V6ONLY, &val, sizeof(val));
+	if (ret < 0)
+		dbg("setsockopt: IPV6_V6ONLY");
+
+	return ret;
+}
+
+/*
+ * IPv6 Ready
+ */
+int usbip_net_tcp_connect(char *hostname, char *service)
+{
+	struct addrinfo hints, *res, *rp;
+	int sockfd;
+	int ret;
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+
+	/* get all possible addresses */
+	ret = getaddrinfo(hostname, service, &hints, &res);
+	if (ret < 0) {
+		dbg("getaddrinfo: %s service %s: %s", hostname, service,
+		    gai_strerror(ret));
+		return ret;
+	}
+
+	/* try the addresses */
+	for (rp = res; rp; rp = rp->ai_next) {
+		sockfd = socket(rp->ai_family, rp->ai_socktype,
+				rp->ai_protocol);
+		if (sockfd < 0)
+			continue;
+
+		/* should set TCP_NODELAY for usbip */
+		usbip_net_set_nodelay(sockfd);
+		/* TODO: write code for heartbeat */
+		usbip_net_set_keepalive(sockfd);
+
+		if (connect(sockfd, rp->ai_addr, rp->ai_addrlen) == 0)
+			break;
+
+		close(sockfd);
+	}
+
+	freeaddrinfo(res);
+
+	if (!rp)
+		return EAI_SYSTEM;
+
+	return sockfd;
+}
diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
new file mode 100644
index 0000000..c1e875c
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_network.h
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef __USBIP_NETWORK_H
+#define __USBIP_NETWORK_H
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#include <sys/types.h>
+
+#include <stdint.h>
+
+extern int usbip_port;
+extern char *usbip_port_string;
+void usbip_setup_port_number(char *arg);
+
+/* ---------------------------------------------------------------------- */
+/* Common header for all the kinds of PDUs. */
+struct op_common {
+	uint16_t version;
+
+#define OP_REQUEST	(0x80 << 8)
+#define OP_REPLY	(0x00 << 8)
+	uint16_t code;
+
+	/* add more error code */
+#define ST_OK	0x00
+#define ST_NA	0x01
+	uint32_t status; /* op_code status (for reply) */
+
+} __attribute__((packed));
+
+#define PACK_OP_COMMON(pack, op_common)  do {\
+	usbip_net_pack_uint16_t(pack, &(op_common)->version);\
+	usbip_net_pack_uint16_t(pack, &(op_common)->code);\
+	usbip_net_pack_uint32_t(pack, &(op_common)->status);\
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+/* Dummy Code */
+#define OP_UNSPEC	0x00
+#define OP_REQ_UNSPEC	OP_UNSPEC
+#define OP_REP_UNSPEC	OP_UNSPEC
+
+/* ---------------------------------------------------------------------- */
+/* Retrieve USB device information. (still not used) */
+#define OP_DEVINFO	0x02
+#define OP_REQ_DEVINFO	(OP_REQUEST | OP_DEVINFO)
+#define OP_REP_DEVINFO	(OP_REPLY   | OP_DEVINFO)
+
+struct op_devinfo_request {
+	char busid[SYSFS_BUS_ID_SIZE];
+} __attribute__((packed));
+
+struct op_devinfo_reply {
+	struct usbip_usb_device udev;
+	struct usbip_usb_interface uinf[];
+} __attribute__((packed));
+
+/* ---------------------------------------------------------------------- */
+/* Import a remote USB device. */
+#define OP_IMPORT	0x03
+#define OP_REQ_IMPORT	(OP_REQUEST | OP_IMPORT)
+#define OP_REP_IMPORT   (OP_REPLY   | OP_IMPORT)
+
+struct op_import_request {
+	char busid[SYSFS_BUS_ID_SIZE];
+} __attribute__((packed));
+
+struct op_import_reply {
+	struct usbip_usb_device udev;
+//	struct usbip_usb_interface uinf[];
+} __attribute__((packed));
+
+#define PACK_OP_IMPORT_REQUEST(pack, request)  do {\
+} while (0)
+
+#define PACK_OP_IMPORT_REPLY(pack, reply)  do {\
+	usbip_net_pack_usb_device(pack, &(reply)->udev);\
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+/* Export a USB device to a remote host. */
+#define OP_EXPORT	0x06
+#define OP_REQ_EXPORT	(OP_REQUEST | OP_EXPORT)
+#define OP_REP_EXPORT	(OP_REPLY   | OP_EXPORT)
+
+struct op_export_request {
+	struct usbip_usb_device udev;
+} __attribute__((packed));
+
+struct op_export_reply {
+	int returncode;
+} __attribute__((packed));
+
+
+#define PACK_OP_EXPORT_REQUEST(pack, request)  do {\
+	usbip_net_pack_usb_device(pack, &(request)->udev);\
+} while (0)
+
+#define PACK_OP_EXPORT_REPLY(pack, reply)  do {\
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+/* un-Export a USB device from a remote host. */
+#define OP_UNEXPORT	0x07
+#define OP_REQ_UNEXPORT	(OP_REQUEST | OP_UNEXPORT)
+#define OP_REP_UNEXPORT	(OP_REPLY   | OP_UNEXPORT)
+
+struct op_unexport_request {
+	struct usbip_usb_device udev;
+} __attribute__((packed));
+
+struct op_unexport_reply {
+	int returncode;
+} __attribute__((packed));
+
+#define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
+	usbip_net_pack_usb_device(pack, &(request)->udev);\
+} while (0)
+
+#define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+/* Negotiate IPSec encryption key. (still not used) */
+#define OP_CRYPKEY	0x04
+#define OP_REQ_CRYPKEY	(OP_REQUEST | OP_CRYPKEY)
+#define OP_REP_CRYPKEY	(OP_REPLY   | OP_CRYPKEY)
+
+struct op_crypkey_request {
+	/* 128bit key */
+	uint32_t key[4];
+} __attribute__((packed));
+
+struct op_crypkey_reply {
+	uint32_t __reserved;
+} __attribute__((packed));
+
+
+/* ---------------------------------------------------------------------- */
+/* Retrieve the list of exported USB devices. */
+#define OP_DEVLIST	0x05
+#define OP_REQ_DEVLIST	(OP_REQUEST | OP_DEVLIST)
+#define OP_REP_DEVLIST	(OP_REPLY   | OP_DEVLIST)
+
+struct op_devlist_request {
+} __attribute__((packed));
+
+struct op_devlist_reply {
+	uint32_t ndev;
+	/* followed by reply_extra[] */
+} __attribute__((packed));
+
+struct op_devlist_reply_extra {
+	struct usbip_usb_device    udev;
+	struct usbip_usb_interface uinf[];
+} __attribute__((packed));
+
+#define PACK_OP_DEVLIST_REQUEST(pack, request)  do {\
+} while (0)
+
+#define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
+	usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
+} while (0)
+
+void usbip_net_pack_uint32_t(int pack, uint32_t *num);
+void usbip_net_pack_uint16_t(int pack, uint16_t *num);
+void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
+void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
+
+ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen);
+ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen);
+int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status);
+int usbip_net_recv_op_common(int sockfd, uint16_t *code);
+int usbip_net_set_reuseaddr(int sockfd);
+int usbip_net_set_nodelay(int sockfd);
+int usbip_net_set_keepalive(int sockfd);
+int usbip_net_set_v6only(int sockfd);
+int usbip_net_tcp_connect(char *hostname, char *port);
+
+#endif /* __USBIP_NETWORK_H */
diff --git a/tools/usb/usbip/src/usbip_port.c b/tools/usb/usbip/src/usbip_port.c
new file mode 100644
index 0000000..52aa168
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_port.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+
+static int list_imported_devices()
+{
+	int i;
+	struct usbip_imported_device *idev;
+	int ret;
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	printf("Imported USB devices\n");
+	printf("====================\n");
+
+	for (i = 0; i < vhci_driver->nports; i++) {
+		idev = &vhci_driver->idev[i];
+
+		if (usbip_vhci_imported_device_dump(idev) < 0)
+			ret = -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return ret;
+
+}
+
+int usbip_port_show(__attribute__((unused)) int argc,
+		    __attribute__((unused)) char *argv[])
+{
+	int ret;
+
+	ret = list_imported_devices();
+	if (ret < 0)
+		err("list imported devices");
+
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbip_unbind.c b/tools/usb/usbip/src/usbip_unbind.c
new file mode 100644
index 0000000..a4a496c
--- /dev/null
+++ b/tools/usb/usbip/src/usbip_unbind.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <libudev.h>
+
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <getopt.h>
+
+#include "usbip_common.h"
+#include "utils.h"
+#include "usbip.h"
+#include "sysfs_utils.h"
+
+static const char usbip_unbind_usage_string[] =
+	"usbip unbind <args>\n"
+	"    -b, --busid=<busid>    Unbind " USBIP_HOST_DRV_NAME ".ko from "
+	"device on <busid>\n";
+
+void usbip_unbind_usage(void)
+{
+	printf("usage: %s", usbip_unbind_usage_string);
+}
+
+static int unbind_device(char *busid)
+{
+	char bus_type[] = "usb";
+	int rc, ret = -1;
+
+	char unbind_attr_name[] = "unbind";
+	char unbind_attr_path[SYSFS_PATH_MAX];
+	char rebind_attr_name[] = "rebind";
+	char rebind_attr_path[SYSFS_PATH_MAX];
+
+	struct udev *udev;
+	struct udev_device *dev;
+	const char *driver;
+
+	/* Create libudev context. */
+	udev = udev_new();
+
+	/* Check whether the device with this bus ID exists. */
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		err("device with the specified bus ID does not exist");
+		goto err_close_udev;
+	}
+
+	/* Check whether the device is using usbip-host driver. */
+	driver = udev_device_get_driver(dev);
+	if (!driver || strcmp(driver, "usbip-host")) {
+		err("device is not bound to usbip-host driver");
+		goto err_close_udev;
+	}
+
+	/* Unbind device from driver. */
+	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+		 USBIP_HOST_DRV_NAME, unbind_attr_name);
+
+	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		err("error unbinding device %s from driver", busid);
+		goto err_close_udev;
+	}
+
+	/* Notify driver of unbind. */
+	rc = modify_match_busid(busid, 0);
+	if (rc < 0) {
+		err("unable to unbind device on %s", busid);
+		goto err_close_udev;
+	}
+
+	/* Trigger new probing. */
+	snprintf(rebind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+			SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+			USBIP_HOST_DRV_NAME, rebind_attr_name);
+
+	rc = write_sysfs_attribute(rebind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		err("error rebinding");
+		goto err_close_udev;
+	}
+
+	ret = 0;
+	info("unbind device on busid %s: complete", busid);
+
+err_close_udev:
+	udev_device_unref(dev);
+	udev_unref(udev);
+
+	return ret;
+}
+
+int usbip_unbind(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "busid", required_argument, NULL, 'b' },
+		{ NULL,    0,                 NULL,  0  }
+	};
+
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'b':
+			ret = unbind_device(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_unbind_usage();
+out:
+	return ret;
+}
diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
new file mode 100644
index 0000000..2cae4ce
--- /dev/null
+++ b/tools/usb/usbip/src/usbipd.c
@@ -0,0 +1,675 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <unistd.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#ifdef HAVE_LIBWRAP
+#include <tcpd.h>
+#endif
+
+#include <getopt.h>
+#include <signal.h>
+#include <poll.h>
+
+#include "usbip_host_driver.h"
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "list.h"
+
+#undef  PROGNAME
+#define PROGNAME "usbipd"
+#define MAXSOCKFD 20
+
+#define MAIN_LOOP_TIMEOUT 10
+
+#define DEFAULT_PID_FILE "/var/run/" PROGNAME ".pid"
+
+static const char usbip_version_string[] = PACKAGE_STRING;
+
+static const char usbipd_help_string[] =
+	"usage: usbipd [options]\n"
+	"\n"
+	"	-4, --ipv4\n"
+	"		Bind to IPv4. Default is both.\n"
+	"\n"
+	"	-6, --ipv6\n"
+	"		Bind to IPv6. Default is both.\n"
+	"\n"
+	"	-D, --daemon\n"
+	"		Run as a daemon process.\n"
+	"\n"
+	"	-d, --debug\n"
+	"		Print debugging information.\n"
+	"\n"
+	"	-PFILE, --pid FILE\n"
+	"		Write process id to FILE.\n"
+	"		If no FILE specified, use " DEFAULT_PID_FILE "\n"
+	"\n"
+	"	-tPORT, --tcp-port PORT\n"
+	"		Listen on TCP/IP port PORT.\n"
+	"\n"
+	"	-h, --help\n"
+	"		Print this help.\n"
+	"\n"
+	"	-v, --version\n"
+	"		Show version.\n";
+
+static void usbipd_help(void)
+{
+	printf("%s\n", usbipd_help_string);
+}
+
+static int recv_request_import(int sockfd)
+{
+	struct op_import_request req;
+	struct op_common reply;
+	struct usbip_exported_device *edev;
+	struct usbip_usb_device pdu_udev;
+	struct list_head *i;
+	int found = 0;
+	int error = 0;
+	int rc;
+
+	memset(&req, 0, sizeof(req));
+	memset(&reply, 0, sizeof(reply));
+
+	rc = usbip_net_recv(sockfd, &req, sizeof(req));
+	if (rc < 0) {
+		dbg("usbip_net_recv failed: import request");
+		return -1;
+	}
+	PACK_OP_IMPORT_REQUEST(0, &req);
+
+	list_for_each(i, &host_driver->edev_list) {
+		edev = list_entry(i, struct usbip_exported_device, node);
+		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
+			info("found requested device: %s", req.busid);
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		/* should set TCP_NODELAY for usbip */
+		usbip_net_set_nodelay(sockfd);
+
+		/* export device needs a TCP/IP socket descriptor */
+		rc = usbip_host_export_device(edev, sockfd);
+		if (rc < 0)
+			error = 1;
+	} else {
+		info("requested device not found: %s", req.busid);
+		error = 1;
+	}
+
+	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT,
+				      (!error ? ST_OK : ST_NA));
+	if (rc < 0) {
+		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_IMPORT);
+		return -1;
+	}
+
+	if (error) {
+		dbg("import request busid %s: failed", req.busid);
+		return -1;
+	}
+
+	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
+	usbip_net_pack_usb_device(1, &pdu_udev);
+
+	rc = usbip_net_send(sockfd, &pdu_udev, sizeof(pdu_udev));
+	if (rc < 0) {
+		dbg("usbip_net_send failed: devinfo");
+		return -1;
+	}
+
+	dbg("import request busid %s: complete", req.busid);
+
+	return 0;
+}
+
+static int send_reply_devlist(int connfd)
+{
+	struct usbip_exported_device *edev;
+	struct usbip_usb_device pdu_udev;
+	struct usbip_usb_interface pdu_uinf;
+	struct op_devlist_reply reply;
+	struct list_head *j;
+	int rc, i;
+
+	reply.ndev = 0;
+	/* number of exported devices */
+	list_for_each(j, &host_driver->edev_list) {
+		reply.ndev += 1;
+	}
+	info("exportable devices: %d", reply.ndev);
+
+	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
+	if (rc < 0) {
+		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_DEVLIST);
+		return -1;
+	}
+	PACK_OP_DEVLIST_REPLY(1, &reply);
+
+	rc = usbip_net_send(connfd, &reply, sizeof(reply));
+	if (rc < 0) {
+		dbg("usbip_net_send failed: %#0x", OP_REP_DEVLIST);
+		return -1;
+	}
+
+	list_for_each(j, &host_driver->edev_list) {
+		edev = list_entry(j, struct usbip_exported_device, node);
+		dump_usb_device(&edev->udev);
+		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
+		usbip_net_pack_usb_device(1, &pdu_udev);
+
+		rc = usbip_net_send(connfd, &pdu_udev, sizeof(pdu_udev));
+		if (rc < 0) {
+			dbg("usbip_net_send failed: pdu_udev");
+			return -1;
+		}
+
+		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
+			dump_usb_interface(&edev->uinf[i]);
+			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
+			usbip_net_pack_usb_interface(1, &pdu_uinf);
+
+			rc = usbip_net_send(connfd, &pdu_uinf,
+					sizeof(pdu_uinf));
+			if (rc < 0) {
+				err("usbip_net_send failed: pdu_uinf");
+				return -1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int recv_request_devlist(int connfd)
+{
+	struct op_devlist_request req;
+	int rc;
+
+	memset(&req, 0, sizeof(req));
+
+	rc = usbip_net_recv(connfd, &req, sizeof(req));
+	if (rc < 0) {
+		dbg("usbip_net_recv failed: devlist request");
+		return -1;
+	}
+
+	rc = send_reply_devlist(connfd);
+	if (rc < 0) {
+		dbg("send_reply_devlist failed");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int recv_pdu(int connfd)
+{
+	uint16_t code = OP_UNSPEC;
+	int ret;
+
+	ret = usbip_net_recv_op_common(connfd, &code);
+	if (ret < 0) {
+		dbg("could not receive opcode: %#0x", code);
+		return -1;
+	}
+
+	ret = usbip_host_refresh_device_list();
+	if (ret < 0) {
+		dbg("could not refresh device list: %d", ret);
+		return -1;
+	}
+
+	info("received request: %#0x(%d)", code, connfd);
+	switch (code) {
+	case OP_REQ_DEVLIST:
+		ret = recv_request_devlist(connfd);
+		break;
+	case OP_REQ_IMPORT:
+		ret = recv_request_import(connfd);
+		break;
+	case OP_REQ_DEVINFO:
+	case OP_REQ_CRYPKEY:
+	default:
+		err("received an unknown opcode: %#0x", code);
+		ret = -1;
+	}
+
+	if (ret == 0)
+		info("request %#0x(%d): complete", code, connfd);
+	else
+		info("request %#0x(%d): failed", code, connfd);
+
+	return ret;
+}
+
+#ifdef HAVE_LIBWRAP
+static int tcpd_auth(int connfd)
+{
+	struct request_info request;
+	int rc;
+
+	request_init(&request, RQ_DAEMON, PROGNAME, RQ_FILE, connfd, 0);
+	fromhost(&request);
+	rc = hosts_access(&request);
+	if (rc == 0)
+		return -1;
+
+	return 0;
+}
+#endif
+
+static int do_accept(int listenfd)
+{
+	int connfd;
+	struct sockaddr_storage ss;
+	socklen_t len = sizeof(ss);
+	char host[NI_MAXHOST], port[NI_MAXSERV];
+	int rc;
+
+	memset(&ss, 0, sizeof(ss));
+
+	connfd = accept(listenfd, (struct sockaddr *)&ss, &len);
+	if (connfd < 0) {
+		err("failed to accept connection");
+		return -1;
+	}
+
+	rc = getnameinfo((struct sockaddr *)&ss, len, host, sizeof(host),
+			 port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (rc)
+		err("getnameinfo: %s", gai_strerror(rc));
+
+#ifdef HAVE_LIBWRAP
+	rc = tcpd_auth(connfd);
+	if (rc < 0) {
+		info("denied access from %s", host);
+		close(connfd);
+		return -1;
+	}
+#endif
+	info("connection from %s:%s", host, port);
+
+	return connfd;
+}
+
+int process_request(int listenfd)
+{
+	pid_t childpid;
+	int connfd;
+
+	connfd = do_accept(listenfd);
+	if (connfd < 0)
+		return -1;
+	childpid = fork();
+	if (childpid == 0) {
+		close(listenfd);
+		recv_pdu(connfd);
+		exit(0);
+	}
+	close(connfd);
+	return 0;
+}
+
+static void addrinfo_to_text(struct addrinfo *ai, char buf[],
+			     const size_t buf_size)
+{
+	char hbuf[NI_MAXHOST];
+	char sbuf[NI_MAXSERV];
+	int rc;
+
+	buf[0] = '\0';
+
+	rc = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
+			 sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (rc)
+		err("getnameinfo: %s", gai_strerror(rc));
+
+	snprintf(buf, buf_size, "%s:%s", hbuf, sbuf);
+}
+
+static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[],
+			     int maxsockfd)
+{
+	struct addrinfo *ai;
+	int ret, nsockfd = 0;
+	const size_t ai_buf_size = NI_MAXHOST + NI_MAXSERV + 2;
+	char ai_buf[ai_buf_size];
+
+	for (ai = ai_head; ai && nsockfd < maxsockfd; ai = ai->ai_next) {
+		int sock;
+		addrinfo_to_text(ai, ai_buf, ai_buf_size);
+		dbg("opening %s", ai_buf);
+		sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
+		if (sock < 0) {
+			err("socket: %s: %d (%s)",
+			    ai_buf, errno, strerror(errno));
+			continue;
+		}
+
+		usbip_net_set_reuseaddr(sock);
+		usbip_net_set_nodelay(sock);
+		/* We use seperate sockets for IPv4 and IPv6
+		 * (see do_standalone_mode()) */
+		usbip_net_set_v6only(sock);
+
+		if (sock >= FD_SETSIZE) {
+			err("FD_SETSIZE: %s: sock=%d, max=%d",
+			    ai_buf, sock, FD_SETSIZE);
+			close(sock);
+			continue;
+		}
+
+		ret = bind(sock, ai->ai_addr, ai->ai_addrlen);
+		if (ret < 0) {
+			err("bind: %s: %d (%s)",
+			    ai_buf, errno, strerror(errno));
+			close(sock);
+			continue;
+		}
+
+		ret = listen(sock, SOMAXCONN);
+		if (ret < 0) {
+			err("listen: %s: %d (%s)",
+			    ai_buf, errno, strerror(errno));
+			close(sock);
+			continue;
+		}
+
+		info("listening on %s", ai_buf);
+		sockfdlist[nsockfd++] = sock;
+	}
+
+	return nsockfd;
+}
+
+static struct addrinfo *do_getaddrinfo(char *host, int ai_family)
+{
+	struct addrinfo hints, *ai_head;
+	int rc;
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family   = ai_family;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags    = AI_PASSIVE;
+
+	rc = getaddrinfo(host, usbip_port_string, &hints, &ai_head);
+	if (rc) {
+		err("failed to get a network address %s: %s", usbip_port_string,
+		    gai_strerror(rc));
+		return NULL;
+	}
+
+	return ai_head;
+}
+
+static void signal_handler(int i)
+{
+	dbg("received '%s' signal", strsignal(i));
+}
+
+static void set_signal(void)
+{
+	struct sigaction act;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler = signal_handler;
+	sigemptyset(&act.sa_mask);
+	sigaction(SIGTERM, &act, NULL);
+	sigaction(SIGINT, &act, NULL);
+	act.sa_handler = SIG_IGN;
+	sigaction(SIGCLD, &act, NULL);
+}
+
+static const char *pid_file;
+
+static void write_pid_file()
+{
+	if (pid_file) {
+		dbg("creating pid file %s", pid_file);
+		FILE *fp = fopen(pid_file, "w");
+		if (!fp) {
+			err("pid_file: %s: %d (%s)",
+			    pid_file, errno, strerror(errno));
+			return;
+		}
+		fprintf(fp, "%d\n", getpid());
+		fclose(fp);
+	}
+}
+
+static void remove_pid_file()
+{
+	if (pid_file) {
+		dbg("removing pid file %s", pid_file);
+		unlink(pid_file);
+	}
+}
+
+static int do_standalone_mode(int daemonize, int ipv4, int ipv6)
+{
+	struct addrinfo *ai_head;
+	int sockfdlist[MAXSOCKFD];
+	int nsockfd, family;
+	int i, terminate;
+	struct pollfd *fds;
+	struct timespec timeout;
+	sigset_t sigmask;
+
+	if (usbip_host_driver_open()) {
+		err("please load " USBIP_CORE_MOD_NAME ".ko and "
+		    USBIP_HOST_DRV_NAME ".ko!");
+		return -1;
+	}
+
+	if (daemonize) {
+		if (daemon(0, 0) < 0) {
+			err("daemonizing failed: %s", strerror(errno));
+			usbip_host_driver_close();
+			return -1;
+		}
+		umask(0);
+		usbip_use_syslog = 1;
+	}
+	set_signal();
+	write_pid_file();
+
+	info("starting " PROGNAME " (%s)", usbip_version_string);
+
+	/*
+	 * To suppress warnings on systems with bindv6only disabled
+	 * (default), we use seperate sockets for IPv6 and IPv4 and set
+	 * IPV6_V6ONLY on the IPv6 sockets.
+	 */
+	if (ipv4 && ipv6)
+		family = AF_UNSPEC;
+	else if (ipv4)
+		family = AF_INET;
+	else
+		family = AF_INET6;
+
+	ai_head = do_getaddrinfo(NULL, family);
+	if (!ai_head) {
+		usbip_host_driver_close();
+		return -1;
+	}
+	nsockfd = listen_all_addrinfo(ai_head, sockfdlist,
+		sizeof(sockfdlist) / sizeof(*sockfdlist));
+	freeaddrinfo(ai_head);
+	if (nsockfd <= 0) {
+		err("failed to open a listening socket");
+		usbip_host_driver_close();
+		return -1;
+	}
+
+	dbg("listening on %d address%s", nsockfd, (nsockfd == 1) ? "" : "es");
+
+	fds = calloc(nsockfd, sizeof(struct pollfd));
+	for (i = 0; i < nsockfd; i++) {
+		fds[i].fd = sockfdlist[i];
+		fds[i].events = POLLIN;
+	}
+	timeout.tv_sec = MAIN_LOOP_TIMEOUT;
+	timeout.tv_nsec = 0;
+
+	sigfillset(&sigmask);
+	sigdelset(&sigmask, SIGTERM);
+	sigdelset(&sigmask, SIGINT);
+
+	terminate = 0;
+	while (!terminate) {
+		int r;
+
+		r = ppoll(fds, nsockfd, &timeout, &sigmask);
+		if (r < 0) {
+			dbg("%s", strerror(errno));
+			terminate = 1;
+		} else if (r) {
+			for (i = 0; i < nsockfd; i++) {
+				if (fds[i].revents & POLLIN) {
+					dbg("read event on fd[%d]=%d",
+					    i, sockfdlist[i]);
+					process_request(sockfdlist[i]);
+				}
+			}
+		} else {
+			dbg("heartbeat timeout on ppoll()");
+		}
+	}
+
+	info("shutting down " PROGNAME);
+	free(fds);
+	usbip_host_driver_close();
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	static const struct option longopts[] = {
+		{ "ipv4",     no_argument,       NULL, '4' },
+		{ "ipv6",     no_argument,       NULL, '6' },
+		{ "daemon",   no_argument,       NULL, 'D' },
+		{ "daemon",   no_argument,       NULL, 'D' },
+		{ "debug",    no_argument,       NULL, 'd' },
+		{ "pid",      optional_argument, NULL, 'P' },
+		{ "tcp-port", required_argument, NULL, 't' },
+		{ "help",     no_argument,       NULL, 'h' },
+		{ "version",  no_argument,       NULL, 'v' },
+		{ NULL,	      0,                 NULL,  0  }
+	};
+
+	enum {
+		cmd_standalone_mode = 1,
+		cmd_help,
+		cmd_version
+	} cmd;
+
+	int daemonize = 0;
+	int ipv4 = 0, ipv6 = 0;
+	int opt, rc = -1;
+	pid_file = NULL;
+
+	usbip_use_stderr = 1;
+	usbip_use_syslog = 0;
+
+	if (geteuid() != 0)
+		err("not running as root?");
+
+	cmd = cmd_standalone_mode;
+	for (;;) {
+		opt = getopt_long(argc, argv, "46DdP::t:hv", longopts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case '4':
+			ipv4 = 1;
+			break;
+		case '6':
+			ipv6 = 1;
+			break;
+		case 'D':
+			daemonize = 1;
+			break;
+		case 'd':
+			usbip_use_debug = 1;
+			break;
+		case 'h':
+			cmd = cmd_help;
+			break;
+		case 'P':
+			pid_file = optarg ? optarg : DEFAULT_PID_FILE;
+			break;
+		case 't':
+			usbip_setup_port_number(optarg);
+			break;
+		case 'v':
+			cmd = cmd_version;
+			break;
+		case '?':
+			usbipd_help();
+		default:
+			goto err_out;
+		}
+	}
+
+	if (!ipv4 && !ipv6)
+		ipv4 = ipv6 = 1;
+
+	switch (cmd) {
+	case cmd_standalone_mode:
+		rc = do_standalone_mode(daemonize, ipv4, ipv6);
+		remove_pid_file();
+		break;
+	case cmd_version:
+		printf(PROGNAME " (%s)\n", usbip_version_string);
+		rc = 0;
+		break;
+	case cmd_help:
+		usbipd_help();
+		rc = 0;
+		break;
+	default:
+		usbipd_help();
+		goto err_out;
+	}
+
+err_out:
+	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
+}
diff --git a/tools/usb/usbip/src/utils.c b/tools/usb/usbip/src/utils.c
new file mode 100644
index 0000000..2b3d6d2
--- /dev/null
+++ b/tools/usb/usbip/src/utils.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+
+#include "usbip_common.h"
+#include "utils.h"
+#include "sysfs_utils.h"
+
+int modify_match_busid(char *busid, int add)
+{
+	char attr_name[] = "match_busid";
+	char command[SYSFS_BUS_ID_SIZE + 4];
+	char match_busid_attr_path[SYSFS_PATH_MAX];
+	int rc;
+
+	snprintf(match_busid_attr_path, sizeof(match_busid_attr_path),
+		 "%s/%s/%s/%s/%s/%s", SYSFS_MNT_PATH, SYSFS_BUS_NAME,
+		 SYSFS_BUS_TYPE, SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME,
+		 attr_name);
+
+	if (add)
+		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
+	else
+		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
+
+	rc = write_sysfs_attribute(match_busid_attr_path, command,
+				   sizeof(command));
+	if (rc < 0) {
+		dbg("failed to write match_busid: %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/usb/usbip/src/utils.h b/tools/usb/usbip/src/utils.h
new file mode 100644
index 0000000..5916fd3
--- /dev/null
+++ b/tools/usb/usbip/src/utils.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __UTILS_H
+#define __UTILS_H
+
+int modify_match_busid(char *busid, int add);
+
+#endif /* __UTILS_H */
+
-- 
1.8.1.2

