Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaG3WHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:07:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44382 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaG3WHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:07:11 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/3] x86: PER_CPU segment improvements
Date: Wed, 30 Jul 2014 15:07:02 -0700
Message-Id: <cover.1406757779.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 sets up a per-cpu GDT entry so that vgetcpu can use LSL on it
to determine the CPU number and node.

This series, in little baby steps, cleans up that code and sets
the accessed and 32-bit flags on the segment.

The accessed bit prevents user code from setting the accessed bit
on its own, and making the segment 32-bit prevents concerns about
shenanigans involving CPU oddities with 16-bit data segments.

The latter isn't a real problem -- if it were a 16-bit read/write
segment, it could be used to bypass espfix64, but fortunately
RO segments can't be loaded into SS.

Changes from v1:
 - Fix patch 2's changelog.
 - Learn to spell "Not a system segment".

Andy Lutomirski (3):
  x86,vdso: Change the PER_CPU segment to use struct desc_struct
  x86,vdso: Make the PER_CPU segment start out accessed
  x86,vdso: Make the PER_CPU segment 32 bits

 arch/x86/kernel/vsyscall_64.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
1.9.3

