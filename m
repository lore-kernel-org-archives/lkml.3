Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbbAVFiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:38:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12449 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbbAVFhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:37:55 -0500
Message-ID: <54C08CA6.8050101@fb.com>
Date: Wed, 21 Jan 2015 22:37:42 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>
CC: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [block] 34b48db66e0: +3291.6% iostat.sde.wrqm/s
References: <1421889689.6126.45.camel@intel.com>
In-Reply-To: <1421889689.6126.45.camel@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_02:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.33066907387547e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.925924926977281
 urlsuspect_oldscore=0.925924926977281 suspectscore=9
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501220064
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 06:21 PM, Huang Ying wrote:
> FYI, we noticed the below changes on
>
> commit 34b48db66e08ca1c1bc07cf305d672ac940268dc ("block: remove artifical max_hw_sectors cap")
>
> testbox/testcase/testparams: lkp-ws02/fileio/600s-100%-1HDD-btrfs-64G-1024f-seqrewr-sync
>
> c2661b806092d8ea  34b48db66e08ca1c1bc07cf305
> ----------------  --------------------------
>           %stddev     %change         %stddev
>               \          |                \
>       47176 ±  2%     -67.3%      15406 ±  4%  softirqs.BLOCK
>        1110 ± 44%     -51.0%        544 ± 35%  sched_debug.cpu#8.curr->pid
>          22 ± 33%     -48.9%         11 ± 43%  sched_debug.cpu#1.cpu_load[0]
>          91 ± 43%    +125.0%        204 ± 32%  sched_debug.cfs_rq[4]:/.blocked_load_avg
>          17 ± 46%     -65.2%          6 ± 31%  sched_debug.cfs_rq[1]:/.runnable_load_avg
>         105 ± 43%    +102.6%        213 ± 32%  sched_debug.cfs_rq[4]:/.tg_load_contrib
>         163 ± 35%     +62.6%        265 ± 27%  sched_debug.cfs_rq[16]:/.blocked_load_avg
>         183 ± 29%     +51.4%        277 ± 26%  sched_debug.cfs_rq[16]:/.tg_load_contrib
>        1411 ± 31%     -42.5%        812 ± 32%  sched_debug.cpu#6.curr->pid
>    57565068 ± 15%     +66.8%   96024066 ± 17%  cpuidle.C1E-NHM.time
>       94625 ±  9%     -32.5%      63893 ±  4%  cpuidle.C3-NHM.usage
>         200 ± 14%     -22.8%        155 ± 24%  sched_debug.cfs_rq[8]:/.tg_load_contrib
>         244 ± 33%     -39.0%        149 ± 11%  sched_debug.cfs_rq[6]:/.blocked_load_avg
>         265 ± 31%     -38.4%        163 ±  9%  sched_debug.cfs_rq[6]:/.tg_load_contrib
>        4959 ±  9%     -18.2%       4058 ±  1%  slabinfo.kmalloc-128.active_objs
>        4987 ±  9%     -18.6%       4058 ±  1%  slabinfo.kmalloc-128.num_objs
>          19 ±  8%     -19.7%         15 ± 14%  sched_debug.cpu#0.cpu_load[1]
>      662307 ±  7%     -12.6%     579108 ±  3%  cpuidle.C6-NHM.usage
>        3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.num_objs
>        3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.active_objs
>        4.87 ±  0%   +3291.6%     165.07 ±  0%  iostat.sde.wrqm/s
>        1006 ±  0%    +120.3%       2216 ±  0%  iostat.sde.avgrq-sz

So these two above tells us that we are doing way more write merges per 
second, and that the average request size has roughly doubled from 1006 
to 2216 - both are excellent news.

>         466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.await
>         466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.w_await

Service time roughly doubled, must be mostly stream time.

>         301 ±  0%     -52.7%        142 ±  0%  iostat.sde.w/s

About half the number of writes completed, but from the stats above, 
those writes are more than double. 1006 * 301 < 2216 * 142, so again, 
this looks good.

>        2230 ±  2%      -8.2%       2048 ±  2%  vmstat.system.in

And a nice reduction in irq rate, also nice. Way less software irqs from 
the first few lines, also a win.

-- 
Jens Axboe

