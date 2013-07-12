Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab3GLW6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:58:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60755 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab3GLW62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:58:28 -0400
Date: Fri, 12 Jul 2013 15:58:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: naveen yadav <yad.naveen@gmail.com>
cc: kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org
Subject: Re: shmem info issue
In-Reply-To: <CAJ8eaTw9o+ZBAzR+1qe-5XEpfZzv-6DJ_EHK_BF_32-va-KL+g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1307121529190.3315@eggly.anvils>
References: <CAJ8eaTw9o+ZBAzR+1qe-5XEpfZzv-6DJ_EHK_BF_32-va-KL+g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, naveen yadav wrote:
>  Hi All
> 
> I am working on tmpfs. During code analysis I found shmem driver
> register itself as tmpfs .
> 
> cat /proc/meminfo Shmem field read NR_SHMEM enum filed and shows used
> memory in tmpfs
> 
> 
> [root@localhost linux-3.8.2]# cat /proc/meminfo | grep -r Shmem
> Shmem:               704 kB
> [root@localhost linux-3.8.2]#
> 
> include/linux/mmzone.h
> enum zone_stat_item {
> -----cut here-------
>  NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages
>  -----cut here
> }
> 
> I have the following query
> 1-> cat /proc/meminfo | grep -r Shmem show only the used tmpfs memory
> or it show used  tmpfs memory + mata data also (because I found Shmem
> is bit larger then tempfs used memory )

"Shmem" includes only data, not metadata, nor memory currently swapped
out.  But it includes tmpfs memory, SysV shared memory (from ipc/shm.c),
POSIX shared memory (under /dev/shm), and shared anonymous mappings
(from mmap of /dev/zero with MAP_SHARED: see call to shmem_zero_setup()
from drivers/char/mem.c): whatever allocates pages through mm/shmem.c.

> 2-> as per the developer comments NR_SHMEM included tmpfs and GEM
> pages whct is Gem pages

Ah yes, and the Graphics Execution Manager uses shmem for objects shared
with the GPU: see use of shmem_read_mapping_page*() in drivers/gpu/drm/.

> 3-> is my above code analysis is correct?

I think so.

Hugh
