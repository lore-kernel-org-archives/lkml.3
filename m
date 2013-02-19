Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3BSL5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:57:10 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:60601 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932202Ab3BSL45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:56:57 -0500
Date: Tue, 19 Feb 2013 13:56:53 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: linux-mm@vger.kernel.org
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vgker.kernel.org
Subject: THP bug and crash on sparc64 3.8
Message-ID: <alpine.SOC.1.00.1302191350280.10147@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am receiving this with 3.8.0 on Sun E420R (4G RAM, 4 CPUs). System 
hangs after logging this to syslog. It was busy  running ap at the 
moment of crash.

CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set

BUG: sleeping function called from invalid context at mm/slub.c:925
in_atomic(): 1, irqs_disabled(): 0, pid: 327, name: khugepaged
2 locks held by khugepaged/327:
 #0:  (&mm->mmap_sem){++++++}, at: [<0000000000516964>] 
khugepaged+0x624/0xf80
 #1:  (&(&mm->page_table_lock)->rlock){+.+.+.}, at: [<0000000000517078>] 
khugepaged+0xd38/0xf

Call Trace:
 [0000000000488d9c] __might_sleep+0x13c/0x240
 [000000000051204c] kmem_cache_alloc+0xcc/0x120
 [000000000044bfc0] tsb_grow+0x80/0x480
 [000000000044e814] hugetlb_setup+0x14/0xc0
 [000000000044bcb0] set_pmd_at+0x110/0x120
 [00000000005170b8] khugepaged+0xd78/0xf80
 [000000000047e508] kthread+0x88/0xa0
 [00000000004060a4] ret_from_syscall+0x1c/0x2c
 [0000000000000000]           (null)

-- 
Meelis Roos (mroos@linux.ee)
