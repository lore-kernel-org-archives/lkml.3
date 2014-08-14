Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaHNOTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:19:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbaHNOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:19:20 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com
Subject: [PATCH 0/1] Prevent possible PTE corruption with /dev/mem mmap
Date: Thu, 14 Aug 2014 16:18:46 +0200
Message-Id: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after some time this issue popped up again. Please note that the patch was send
to lkml two times.

https://lkml.org/lkml/2013/4/2/297
  lkml: <1364905733-23937-1-git-send-email-fhrbata@redhat.com>
https://lkml.org/lkml/2013/10/2/359
  lkml: <20131002160514.GA25471@localhost.localdomain>

It did not get much attention, except H. Peter Anvin's complain that having two
checks for mmap and read/write for /dev/mem access is ridiculous. I for sure do
not object to this, but AFAICT it's not that simple to unify them and it's not
"directly" related to the PTE corruption. Please note that there are other
archs(ia64, arm) using these check. But I for sure can be missing something.

What the patch does is using the existing interface to implement x86 specific
check in the least invasive way.

Peter: I by no means want to be pushy. Just that after I looked into this a
little bit more, I don't see a better and more straightforward way how to fix
this. I will be grateful for any suggestions and help. If we want/need to fix
this in a different way, I can for sure try, but I will need at least some
guidance.

So I'm posting this once more with a hope it will get more attention or at least
to start the discussion how/if this should be fixed.

The patch is the same except I added a check for phys addr overflow before
calling phys_addr_valid. Maybe this check should be in do_mmap_pgoff.

Many thanks

Frantisek Hrbata (1):
  x86: add phys addr validity check for /dev/mem mmap

 arch/x86/include/asm/io.h |  4 ++++
 arch/x86/mm/mmap.c        | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

-- 
1.9.3

