Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbbAVRsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:48:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbbAVRr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:47:59 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@fb.com>
Cc: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [block] 34b48db66e0: +3291.6% iostat.sde.wrqm/s
References: <1421889689.6126.45.camel@intel.com> <54C08CA6.8050101@fb.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 22 Jan 2015 12:47:44 -0500
In-Reply-To: <54C08CA6.8050101@fb.com> (Jens Axboe's message of "Wed, 21 Jan
	2015 22:37:42 -0700")
Message-ID: <x49zj9a9073.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@fb.com> writes:

> On 01/21/2015 06:21 PM, Huang Ying wrote:
>> FYI, we noticed the below changes on
>>
>> commit 34b48db66e08ca1c1bc07cf305d672ac940268dc ("block: remove artifical max_hw_sectors cap")
>>
>> testbox/testcase/testparams: lkp-ws02/fileio/600s-100%-1HDD-btrfs-64G-1024f-seqrewr-sync
>>
>> c2661b806092d8ea  34b48db66e08ca1c1bc07cf305
>> ----------------  --------------------------
>>           %stddev     %change         %stddev
>>               \          |                \
>>       47176 ±  2%     -67.3%      15406 ±  4%  softirqs.BLOCK
>>        1110 ± 44%     -51.0%        544 ± 35%  sched_debug.cpu#8.curr->pid
>>          22 ± 33%     -48.9%         11 ± 43%  sched_debug.cpu#1.cpu_load[0]
>>          91 ± 43%    +125.0%        204 ± 32%  sched_debug.cfs_rq[4]:/.blocked_load_avg
>>          17 ± 46%     -65.2%          6 ± 31%  sched_debug.cfs_rq[1]:/.runnable_load_avg
>>         105 ± 43%    +102.6%        213 ± 32%  sched_debug.cfs_rq[4]:/.tg_load_contrib
>>         163 ± 35%     +62.6%        265 ± 27%  sched_debug.cfs_rq[16]:/.blocked_load_avg
>>         183 ± 29%     +51.4%        277 ± 26%  sched_debug.cfs_rq[16]:/.tg_load_contrib
>>        1411 ± 31%     -42.5%        812 ± 32%  sched_debug.cpu#6.curr->pid
>>    57565068 ± 15%     +66.8%   96024066 ± 17%  cpuidle.C1E-NHM.time
>>       94625 ±  9%     -32.5%      63893 ±  4%  cpuidle.C3-NHM.usage
>>         200 ± 14%     -22.8%        155 ± 24%  sched_debug.cfs_rq[8]:/.tg_load_contrib
>>         244 ± 33%     -39.0%        149 ± 11%  sched_debug.cfs_rq[6]:/.blocked_load_avg
>>         265 ± 31%     -38.4%        163 ±  9%  sched_debug.cfs_rq[6]:/.tg_load_contrib
>>        4959 ±  9%     -18.2%       4058 ±  1%  slabinfo.kmalloc-128.active_objs
>>        4987 ±  9%     -18.6%       4058 ±  1%  slabinfo.kmalloc-128.num_objs
>>          19 ±  8%     -19.7%         15 ± 14%  sched_debug.cpu#0.cpu_load[1]
>>      662307 ±  7%     -12.6%     579108 ±  3%  cpuidle.C6-NHM.usage
>>        3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.num_objs
>>        3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.active_objs
>>        4.87 ±  0%   +3291.6%     165.07 ±  0%  iostat.sde.wrqm/s
>>        1006 ±  0%    +120.3%       2216 ±  0%  iostat.sde.avgrq-sz
>
> So these two above tells us that we are doing way more write merges
> per second, and that the average request size has roughly doubled from
> 1006 to 2216 - both are excellent news.
>
>>         466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.await
>>         466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.w_await
>
> Service time roughly doubled, must be mostly stream time.
>
>>         301 ±  0%     -52.7%        142 ±  0%  iostat.sde.w/s
>
> About half the number of writes completed, but from the stats above,
> those writes are more than double. 1006 * 301 < 2216 * 142, so again,
> this looks good.
>
>>        2230 ±  2%      -8.2%       2048 ±  2%  vmstat.system.in
>
> And a nice reduction in irq rate, also nice. Way less software irqs
> from the first few lines, also a win.

Agreed on all above, but are the actual benchmark numbers included
somewhere in all this mess?  I'd like to see if the benchmark numbers
improved first, before digging into the guts of which functions are
called more or which stats changed.

Cheers,
Jeff
