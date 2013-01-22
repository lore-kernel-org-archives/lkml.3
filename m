Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3AVLoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:44:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3AVLn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:43:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628471"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
Date: Tue, 22 Jan 2013 19:42:59 +0800
Message-Id: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:42:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:43:00,
	Serialize complete at 2013/01/22 19:43:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some bug fix patches for physical memory hot-remove. All these
patches are based on the latest -mm tree.
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm

And patch1 and patch3 are very important.
patch1: free compound pages when freeing memmap, otherwise the kernel
        will panic the next time memory is hot-added.
patch3: the old way of freeing pagetable pages was wrong. We should never
        split larger pages into small ones.


Lai Jiangshan (1):
  Bug-fix: mempolicy: fix is_valid_nodemask()

Tang Chen (3):
  Bug fix: Do not split pages when freeing pagetable pages.
  Bug fix: Fix section mismatch problem of
    release_firmware_map_entry().
  Bug fix: Fix the doc format in drivers/firmware/memmap.c

Wen Congyang (1):
  Bug fix: consider compound pages when free memmap

 arch/x86/mm/init_64.c     |  148 ++++++++++++++-------------------------------
 drivers/firmware/memmap.c |   16 +++---
 mm/mempolicy.c            |   36 +++++++----
 mm/sparse.c               |    2 +-
 4 files changed, 77 insertions(+), 125 deletions(-)

