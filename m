Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3HFF2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:28:50 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46899 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3HFF2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:28:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 0/8] partitions/efi: detect hybrid mbrs
Date: Mon,  5 Aug 2013 22:21:08 -0700
Message-Id: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset teaches the kernel about hybrid master boot records (MBRs), one of
the most common issues with GUID partition tables, as a workaround to layout
disk partitions to be compatible with both EFI and legacy MBR based systems.
Except for adding more pmbr checks, to better comply with the UEFI/GPT specs, the
functionality is left unchanged - we only inform (through debug) the user about
the used MBR scheme. While it is true that these restrictions can be bypassed when
forcing gpt, this is not the correct or default way of doing things, complicating
users furthermore. More details are in the individual patches.

Patches 1-5 enables the kernel to inform the user about the mbr scheme being used.
They also include more protective mbr checks to be more UEFI compliant - we currently
have a very open and generic gpt implementation that can cause non-GPT disks to be
recognized/probed as GPT.

Patch 6 adds a missing check when verifying the header integrity.

Patches 7 & 8 are trivial cleanups.

All changes were tested on a macbook pro containing a hybrid mbr and a large EFI based 
HP server with a standard protective mbr.

Thanks!

Davidlohr Bueso (8):
  partitions/efi: use lba-aware partition records
  partitions/efi: check pmbr record's starting lba
  partitions/efi: do not require gpt partition to begin at sector 1
  partitions/efi: detect hybrid MBRs
  partitions/efi: account for pmbr size in lba
  partitions/efi: compare first and last usable LBAs
  partitions/efi: delete annoying emacs style comments
  partitions/efi: some style cleanups

 block/partitions/efi.c | 128 ++++++++++++++++++++++++++++++++++---------------
 block/partitions/efi.h |  38 +++++++--------
 2 files changed, 108 insertions(+), 58 deletions(-)

-- 
1.7.11.7

