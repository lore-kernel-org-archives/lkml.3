Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaHOLo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaHOLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:44:28 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com
Subject: [PATCH V2 0/2] Prevent possible PTE corruption with /dev/mem mmap
Date: Fri, 15 Aug 2014 13:44:01 +0200
Message-Id: <1408103043-31015-1-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>
References: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Dave Hansen for pointing out problems related to the pfn check in the
first version. I tried to fix it by adding a new arch_pfn_possible helper to
arch/x86/mm/physaddr.h. Please note that I'm not quite sure about the name and
the location(physaddr.h). Maybe we can keep the check directly in the
valid_mmap_phys_addr_range. I will leave this to a discussion and fix it if
required.

Question: Do we need the CONFIG_PHYS_ADDR_T_64BIT ifdef? The
boot_cpu_data.x86_phys_bits is set for all x86. So at this point it seems to me
more like an "optimization" for x86_32 or something kept from historic
reasons. I'm just curious and I of course may be missing something.

Many thanks

Frantisek Hrbata (2):
  x86: add arch_pfn_possible helper
  x86: add phys addr validity check for /dev/mem mmap

 arch/x86/include/asm/io.h |  4 ++++
 arch/x86/mm/mmap.c        | 12 ++++++++++++
 arch/x86/mm/physaddr.h    |  9 +++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

-- 
1.9.3

