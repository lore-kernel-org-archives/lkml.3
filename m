Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3B0Fup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:50:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39652 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3B0Fuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:50:44 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512D9E69.6010102@jp.fujitsu.com>
Date: Wed, 27 Feb 2013 14:49:29 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <a.p.zijlstra@chello.nl>,
        <jarkko.sakkinen@intel.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
In-Reply-To: <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/27 14:11, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 8:43 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> 2013/02/27 13:04, Yinghai Lu wrote:
>>>
>>> On Tue, Feb 26, 2013 at 7:38 PM, Yasuaki Ishimatsu
>>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>>>
>>>> 2013/02/27 11:30, Yinghai Lu wrote:
>>>>>
>>>>> Do you mean you can not boot one socket system with 1G ram ?
>>>>> Assume socket 0 does not support hotplug, other 31 sockets support hot
>>>>> plug.
>>>>>
>>>>> So we could boot system only with socket0, and later one by one hot
>>>>> add other cpus.
>>>>
>>>>
>>>>
>>>> In this case, system can boot. But other cpus with bunch of ram hot
>>>> plug may fails, since system does not have enough memory for cover
>>>> hot added memory. When hot adding memory device, kernel object for the
>>>> memory is allocated from 1G ram since hot added memory has not been
>>>> enabled.
>>>>
>>>
>>> yes, it may fail, if the one node memory need page table and vmemmap
>>> is more than 1g ...
>>>
>>

>>> for hot add memory we need to
>>> 1. add another wrapper for init_memory_mapping, just like
>>> init_mem_mapping() for booting path.
>>> 2. we need make memblock more generic, so we can use it with hot add
>>> memory during runtime.
>>> 3. with that we can initialize page table for hot added node with ram.
>>> a. initial page table for 2M near node top is from node0 ( that does
>>> not support hot plug).
>>> b. then will use 2M for memory below node top...
>>> c. with that we will make sure page table stay on local node.
>>>    alloc_low_pages need to be updated to support that.
>>> 4. need to make sure vmemmap on local node too.
>>
>>
>> I think so too. By this, memory hot plug becomes more useful.

I agree with your idea. But I think above ideas is future work.
So at first we should use movable memory for memory hot plug.
After that, we will implement above ideas.

>>
>>>
>>> so hot-remove node will work too later.
>>>
>>> In the long run, we should make booting path and hot adding more
>>> similar and share at most code.
>>> That will make code get more test coverage.
>
> Tang,  Yasuaki, Andrew,
>
> Please check if you are ok with attached reverting patch.

We will fix this problem with no objection. So please wait a while.

And the problem occurs by "movablemem_map=srat" not "movablemem_map=nn[KMG]@ss[KMG]"
At least, if you want to revert it, you should revert only "movablemem_map=srat" part.

Thanks,
Yasuaki Ishimatsu  

>
> Tim, Don,
> Can you try if attached reverting patch fix all the problems for you ?
>
> Thanks
>
> Yinghai
>


