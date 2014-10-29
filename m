Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaJ2MqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:46:12 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ2MqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:10 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: UBI Fastmap stabilization
Date: Wed, 29 Oct 2014 13:45:23 +0100
Message-Id: <1414586758-9972-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series brings a massive stabilization update for UBI Fastmap.
During the last weeks many issues have been identified and fixed.
Both power-cut and excessive run-time tests uncovered bugs which
got addressed. No on-disk layout change was needed.

Besides of plain bug fixes this series introduces also much better Fastmap
self checks. These can be enabled by the UBI debugfs knob "chk_fastmap".
It will enable checks which ensure that every PEB is known to Fastmap
while writing a fastmap to flash and will run an expensive check while attaching.
To have Fastmap checking enabled by default a new UBI module parameter was
added, "fm_debug". This parameter is useful for the attach self check. Upon
attach time no debugfs is available and therefore the check cannot be enabled.
The attach self check will load the fastmap data structure and will issue a full
scan to verify it. Therefore, don't enable it in production, it will make
attachment by Fastmap slow.

Power-cut related issues have been found by my power-cut emulation patches for UBI.
These patches are currently under internal review/polishing and will be published
next week.

Patch 29 to 35 are a massive cleanup as requested by Artem. It moves all Fastmap
specific code out of wl.c. Some Fastmap functions are very closely related to the WL
sub-system, these function are now in fastmap-wl.c located. The amount of Fastmap
specific #ifdefs have been reduced to a minimum.

After this series went mainline I'll create a list of stable patches and make sure
that all Fastmap fixes go into -stable.

Enjoy!
//richard

git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git fastmap_upgrade1

[PATCH 01/35] UBI: Add initial support for fastmap self checks
[PATCH 02/35] UBI: Fix stale pointers in ubi->lookuptbl
[PATCH 03/35] UBI: Fastmap: Add self check to detect absent PEBs
[PATCH 04/35] UBI: Fastmap: Care about the protection queue
[PATCH 05/35] UBI: Fastmap: Ensure that only one fastmap work is
[PATCH 06/35] UBI: Fastmap: Ensure that all fastmap work is done upon
[PATCH 07/35] UBI: Fastmap: Fix races in ubi_wl_get_peb()
[PATCH 08/35] UBI: Split __wl_get_peb()
[PATCH 09/35] UBI: Fastmap: Make ubi_refill_pools() fair
[PATCH 10/35] UBI: Fastmap: Fix memory leaks while closing the WL
[PATCH 11/35] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
[PATCH 12/35] UBI: Fastmap: Notify user in case of an
[PATCH 13/35] UBI: Fastmap: Wrap fastmap specific function in a ifdef
[PATCH 14/35] UBI: Fastmap: Fix fastmap usage in ubi_volume_notify()
[PATCH 15/35] UBI: Fastmap: Enhance fastmap checking
[PATCH 16/35] UBI: Fastmap: Fix memory leak while attaching
[PATCH 17/35] UBI: Remove alloc_ai() slab name from parameter list
[PATCH 18/35] UBI: Fastmap: Fix race in ubi_eba_atomic_leb_change()
[PATCH 19/35] UBI: Fastmap: Remove bogus ubi_assert()
[PATCH 20/35] UBI: Fastmap: Remove eba_orphans logic
[PATCH 21/35] UBI: Fastmap: Switch to ro mode if invalidate_fastmap()
[PATCH 22/35] UBI: Fastmap: Make WL pool size 50% of user pool size
[PATCH 23/35] UBI: Fastmap: Add new module parameter fm_debug
[PATCH 24/35] UBI: Fastmap: Fix leb_count unbalance
[PATCH 25/35] UBI: Fastmap: Fix race after ubi_wl_get_peb()
[PATCH 26/35] UBI: Fastmap: Set used_ebs only for static volumes
[PATCH 27/35] UBI: Fastmap: Locking updates
[PATCH 28/35] UBI: Fastmap: Make self_check_eba() depend on fastmap
[PATCH 29/35] UBI: Move fastmap specific functions out of wl.c
[PATCH 30/35] UBI: Add accessor functions for WL data structures
[PATCH 31/35] UBI: Fastmap: Wire up WL accessor functions
[PATCH 32/35] UBI: Fastmap: Introduce ubi_fastmap_init()
[PATCH 33/35] UBI: Fastmap: Introduce may_reserve_for_fm()
[PATCH 34/35] UBI: Fastmap: Remove else after return.
[PATCH 35/35] UBI: Fastmap: Add blank line after declarations
