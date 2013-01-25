Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab3AYS3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:29:45 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33873 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3AYS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:29:41 -0500
Message-ID: <1359137977.14145.417.camel@misato.fc.hp.com>
Subject: Re: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org
Date: Fri, 25 Jan 2013 11:19:37 -0700
In-Reply-To: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 19:42 +0800, Tang Chen wrote:
> Here are some bug fix patches for physical memory hot-remove. All these
> patches are based on the latest -mm tree.
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> 
> And patch1 and patch3 are very important.
> patch1: free compound pages when freeing memmap, otherwise the kernel
>         will panic the next time memory is hot-added.
> patch3: the old way of freeing pagetable pages was wrong. We should never
>         split larger pages into small ones.
> 
> 
> Lai Jiangshan (1):
>   Bug-fix: mempolicy: fix is_valid_nodemask()
> 
> Tang Chen (3):
>   Bug fix: Do not split pages when freeing pagetable pages.
>   Bug fix: Fix section mismatch problem of
>     release_firmware_map_entry().
>   Bug fix: Fix the doc format in drivers/firmware/memmap.c
> 
> Wen Congyang (1):
>   Bug fix: consider compound pages when free memmap
> 
>  arch/x86/mm/init_64.c     |  148 ++++++++++++++-------------------------------
>  drivers/firmware/memmap.c |   16 +++---
>  mm/mempolicy.c            |   36 +++++++----
>  mm/sparse.c               |    2 +-
>  4 files changed, 77 insertions(+), 125 deletions(-)

This patchset fixed a blocker panic I was hitting in my memory hot-plug
testing.  Memory hotplug works fine with this patchset (for testing my
hotplug framework patchset :).  For the series:

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



