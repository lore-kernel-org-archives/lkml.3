Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab3APIPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:15:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab3APIP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:15:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,478,1355068800"; 
   d="scan'208";a="6598686"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mhocko@suse.cz, linux-mm@kvack.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, jbeulich@suse.com,
        dhowells@redhat.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, paul.gortmaker@windriver.com,
        laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan@kernel.org, aquini@redhat.com, jiang.liu@huawei.com,
        tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        davem@davemloft.net, michael@ellerman.id.au,
        gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux390@de.ibm.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linfeng@cn.fujitsu.com, tangchen@cn.fujitsu.com
Subject: [PATCH v3 0/2] memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE and revert register_page_bootmem_info_node() when platform not support
Date: Wed, 16 Jan 2013 16:14:17 +0800
Message-Id: <1358324059-9608-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 16:14:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 16:14:41,
	Serialize complete at 2013/01/16 16:14:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory-hotplug codes for x86_64 have been implemented by patchset:
https://lkml.org/lkml/2013/1/9/124
While other platforms haven't been completely implemented yet.

If we enable both CONFIG_MEMORY_HOTPLUG_SPARSE and CONFIG_SPARSEMEM_VMEMMAP,
register_page_bootmem_info_node() may be buggy, which is a hotplug generic
function but falling back to call platform related function
register_page_bootmem_memmap().

Other platforms such as powerpc it's not implemented, so on such platforms,
revert them to empty as they were before.

It's implemented by adding a new Kconfig option named
CONFIG_HAVE_BOOTMEM_INFO_NODE, which will be automatically selected by
memory-hotplug supported archs(currently only on x86_64).

changeLog v2->v3:
1) patch 1/2:
- Rename the patch title to conform it's content.
- Update memory_hotplug.h and remove the misleading TODO pointed out by Michal.
2) patch 2/2:
- New added, remove unimplemented functions suggested by Michal.

ChangeLog v1->v2:
1) patch 1/2:
- Add a Kconfig option named HAVE_BOOTMEM_INFO_NODE suggested by Michal, which
  will be automatically selected by supported archs(currently only on x86_64).

Lin Feng (1):
  memory-hotplug: revert register_page_bootmem_info_node() to empty
    when platform related code is not implemented

Michal Hocko (1):
  memory-hotplug: cleanup: removing the arch specific functions without
    any implementation

 arch/ia64/mm/discontig.c       |    5 -----
 arch/powerpc/mm/init_64.c      |    5 -----
 arch/s390/mm/vmem.c            |    6 ------
 arch/sparc/mm/init_64.c        |    5 -----
 arch/x86/mm/init_64.c          |    2 +-
 include/linux/memory_hotplug.h |    6 ++++++
 mm/Kconfig                     |    8 ++++++++
 mm/memory_hotplug.c            |    2 ++
 8 files changed, 17 insertions(+), 22 deletions(-)

