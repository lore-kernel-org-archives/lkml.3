Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab3JPMbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:31:39 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42410 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3JPMbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] m68k bootinfo updates
Date: Wed, 16 Oct 2013 14:31:17 +0200
Message-Id: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up various definitions used in the Linux/m68k
bootinfo API, and exports the public definitions in
  - <asm/bootinfo.h>, for generic definitions,
  - <asm/bootinfo-<mach>>, for machine-specific definitions.
Hence those are the only header files needed by bootstraps (Amiga
bootstraps also need <linux/zorro.h> and <linux/zorro_id.h>).

This will add more compile-breakage to bootstraps that do not have a
private copy of the bootinfo definitions. But given those bootstrap sources
already rely on header files that are currently not exported, they need
fixes anyway.

  - [01/16] block/z2ram: Remove duplicate external declarations
  - [02/16] m68k: The bootinfo is located right after the kernel
  - [03/16] m68k: head.S - Correct date and spelling
  - [04/16] m68k: Drop remainings and API of BOOTINFO_COMPAT_1_0
  - [05/16] m68k/mac: Move struct mac_booter_data to <asm/macintosh.h>
  - [06/16] m68k/mac: Remove unused hardware profile tags
  - [07/16] m68k/vme: Remove unused mvme_bdid_ptr
  - [08/16] m68k/UAPI: Disintegrate arch/m68k/include/asm/bootinfo.h
  - [09/16] m68k/UAPI: Move generic definitions to <asm/bootinfo.h>
  - [10/16] m68k/UAPI: Move Amiga model/chipset definitions to
	    <asm/bootinfo-amiga.h>
  - [11/16] m68k/UAPI: Move Apollo model definitions to <asm/bootinfo-apollo.h>
  - [12/16] m68k/UAPI: Move HP300 model definitions to <asm/bootinfo-hp300.h>
  - [13/16] m68k/UAPI: Move Macintosh model definitions to <asm/bootinfo-mac.h>
  - [14/16] m68k/UAPI: Move VME Board ID definition to <asm/bootinfo-vme.h>
  - [15/16] m68k/UAPI: Use proper types (endianness/size) in <asm/bootinfo*.h>
  - [16/16] m68k: Remove superfluous inclusions of <asm/bootinfo.h>

All comments are welcome!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
