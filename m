Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3JORsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:48:40 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:59506 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JORsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:48:38 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] kexec support for Linux/m68k (kernel part)
Date: Tue, 15 Oct 2013 19:48:24 +0200
Message-Id: <1381859307-11932-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of patches to add kexec support for m68k to the Linux kernel.

  - Kexec only, no kdump support yet (do you have enough RAM to keep a
    crashdump kernel in memory at all times? ;-)

  - Tested on ARAnyM, with emulated 68040.
    I tested the behavior for machines where memory doesn't start at zero
    (e.g. Amiga) by modifying the bootinfo to make ST-RAM memory start at
    0x20000000, which also works (this does require a small patch to make
    atari_stram_init() succeed).

  - Tested on Amiga 4000/040, where it hangs :-(
    Probably this is due to lack of memory. It also crashes on ARAnyM with only
    12 MiB of RAM. It seems something is corrupted when copying, although I
    couldn't detect any overlapping copies using the debug code in patch 1.

  - Test results on real machines with more than 16 MiB of RAM and different
    CPUs would be welcome!

    You can download a kexec binary from
    http://users.telenet.be/geertu/Download/kexec-m68k-2013-10-15.tar.bz2

  - To have automatic "kexec -e" on reboot, copy /etc/rc6.d/S85kexec from
    another system, and fix it up for kexec living in /usr/local/sbin instead
    of /sbin.

  - Sample invocation:

        kexec -d -l vmlinux --reuse-cmdline
        reboot

Patches:
  - [PATCH 1/3] kexec: Add debug printing of kimage table entries
      - v2: new patch
  - [PATCH 2/3] m68k: Add kexec support
      - v2:
	  - KEXEC depends on M68KCLASSIC, 
	  - Fix handling of virtual and physical addresses, for machines where
	    memory doesn't start at zero,
	  - Support for other CPUs than 68040.
  - [PATCH 3/3] m68k: Add support to export bootinfo in procfs
       - v2: no changes
  - "m68k: Add System RAM to /proc/iomem" was dropped in v2.

Have fun!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

