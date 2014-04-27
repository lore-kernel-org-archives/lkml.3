Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaD0MZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 08:25:28 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:39679 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaD0MZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 08:25:26 -0400
Date: Sun, 27 Apr 2014 14:25:23 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: On a 3.14.1 system dirty count goes negative
Message-ID: <20140427142523.402d6b0f@neptune.home>
In-Reply-To: <20140427130651.07839e7f@neptune.home>
References: <20140427130651.07839e7f@neptune.home>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous time I've seen it was on 3.13.6, 3 weeks ago,
I'm now on 3.14.1.

Setting /proc/sys/vm/dirty_bytes to very high number (around
18446744073709550284) but still smaller than (uint64)-1 gets
things running shortly/partially though.

System is single-CPU, CONFIG_SMP=n, which might be important detail.

On Sun, 27 April 2014 Bruno Prémont wrote:
> On a 3.14 system (KVM virtual machine 512MB RAM, x86_64) I'm seeing
> /proc/meminfo/Dirty getting extreemly large (u64 going "nevative").
> 
> Note, this is not the first time I'm seeing it.
> 
> The system is not doing too much but has a rather small amount of
> memory.
> 
> MemTotal:         508512 kB
> MemFree:           23076 kB
> MemAvailable:     282092 kB
> Buffers:               0 kB
> Cached:           194548 kB
> SwapCached:         1500 kB
> Active:           168060 kB
> Inactive:         203080 kB
> Active(anon):      82300 kB
> Inactive(anon):    95992 kB
> Active(file):      85760 kB
> Inactive(file):   107088 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:        524284 kB
> SwapFree:         515820 kB
> Dirty:          18446744073709550284 kB
> Writeback:             4 kB
> AnonPages:        175600 kB
> Mapped:            28784 kB
> Shmem:              1700 kB
> Slab:              92244 kB
> SReclaimable:      76812 kB
> SUnreclaim:        15432 kB
> KernelStack:        1128 kB
> PageTables:         5588 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:      778540 kB
> Committed_AS:    1036592 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:        4440 kB
> VmallocChunk:   34359711231 kB
> AnonHugePages:         0 kB
> DirectMap4k:       10228 kB
> DirectMap2M:      514048 kB
> 
> Some tasks end up being stuck in balance_dirty_pages_ratelimited()
> because of this.
> 
> I have no idea what triggers Dirty to go mad but it happens.
> It might be facilitated by some heavier IO (rsync of some data)
> while rrdcached (rrdtool) is touching RRDs or writing its data log.
> rrdcached is the one getting stuck in balance_dirty_pages_ratelimited().
> 
> Is there a way to get the system rolling again (making
> dirty pages temporarily unlimited) or a way to determine why/when
> Dirty goes negative and possibly get a hint on the trigger?
> 
> Thanks,
> Bruno
