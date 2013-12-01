Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LALaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:30:55 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:53234 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3LALau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:30:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] kexec support for Linux/m68k (kernel part)
Date: Sun,  1 Dec 2013 12:30:33 +0100
Message-Id: <1385897435-18618-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of patches to add kexec support for m68k to the Linux kernel.

  - Kexec only, no kdump support yet (do you have enough RAM to keep a
    crashdump kernel in memory at all times? ;-)

  - Tested on ARAnyM, with emulated 68040 (Atari has identical virt/phys RAM
    mapping),
  - Tested on Amiga 4000/040, with real 68040 (Amiga has non-identical
    virt/phys RAM mapping).

  - Test results on machines with different CPUs would be welcome!

    You can download a kexec binary from
    http://users.telenet.be/geertu/Download/kexec-m68k-2013-10-15.tar.bz2

  - To have automatic "kexec -e" on reboot, copy /etc/rc6.d/S85kexec from
    another system, and fix it up for kexec living in /usr/local/sbin instead
    of /sbin.

  - Sample invocation:

        kexec -d -l vmlinux --reuse-cmdline
        reboot

Patches:
  - [PATCH 1/2] m68k: Add kexec support
      - v2:
          - KEXEC depends on M68KCLASSIC,
          - Fix handling of virtual and physical addresses, for machines where
            memory doesn't start at zero,
          - Support for other CPUs than 68040.
      - v3:
	  - Clear '040/'060 transparent translation registers on MMU disable

  - [PATCH 2/2] m68k: Add support to export bootinfo in procfs
       - v2:
          - No changes
       - v3:
	  - Rebased on top of current m68k tree

  - "m68k: Add System RAM to /proc/iomem" was dropped in v2.
  - "kexec: Add debug printing of kimage table entries" was dropped in v3.

Have fun!

