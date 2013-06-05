Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3FEDcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 23:32:23 -0400
Received: from [205.204.113.251] ([205.204.113.251]:32878 "HELO
	us-alimail-mta2.hst.scl.en.alidc.net." rhost-flags-FAIL-FAIL-FAIL-FAIL)
	by vger.kernel.org with SMTP id S1750808Ab3FEDcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:32:20 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2013 23:32:19 EDT
Message-ID: <51AEAFF8.8030704@taobao.com>
Date: Wed, 05 Jun 2013 11:26:48 +0800
From: sanbai <sanbai@taobao.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>, kent.overstreet@gmail.com
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com> <20130605030337.GO14916@htj.dyndns.org>
In-Reply-To: <20130605030337.GO14916@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年06月05日 11:03, Tejun Heo wrote:
> (cc'ing Kent.  Original posting at
>   http://thread.gmane.org/gmane.linux.kernel/1502484 )
>
> Hello,
>
> On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
>> We want to use blkio.cgroup on high-speed device (like fusionio) for our mysql clusters.
>> After testing different io-scheduler, we found that  cfq is too slow and deadline can't run on cgroup.
>> So we developed a new io-scheduler: tpps (Tiny Parallel Proportion Scheduler).It dispatch requests
>> only by using their individual weight and total weight (proportion) therefore it's simply and efficient.
>>
>> Test case: fusionio card, 4 cgroups, iodepth-512
> So, while I understand the intention behind it, I'm not sure a
> separate io-sched for this is what we want.  Kent and Jens have been
> thinking about this lately so they'll probably chime in.  From my POV,
> I see a few largish issues.
>
> * It has to be scalable with relatively large scale SMP / NUMA
>    configurations.  It better integrate with blk-mq support currently
>    being brewed.
Ok, I will go on to look Jens's blk-mq branch.

>
> * It definitely has to support hierarchy.  Nothing which doesn't
>    support full hierarchy can be added to cgroup at this point.
Thanks for your note, hierarchy supporting will be added in my next 
version patch.
>
> * We already have separate implementations in blk-throtl and
>    cfq-iosched.  Maybe it's too late and too different for cfq-iosched
>    given that it's primarily targeted at disks, but I wonder whether we
>    can make blk-throtl generic and scalable enough to cover all other
>    use cases.
I have the same feeling. Let's wait other person's response.
>
> Thanks.
>


-- 

Robin Dong
董昊（花名：三百）
阿里巴巴 集团 核心系统部 内核组
分机：72370
手机：13520865473
email：sanbai@taobao.com

