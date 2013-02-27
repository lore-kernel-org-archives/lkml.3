Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab3B0Eod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 23:44:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46172 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3B0Eob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 23:44:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512D8EDA.3010602@jp.fujitsu.com>
Date: Wed, 27 Feb 2013 13:43:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <a.p.zijlstra@chello.nl>,
        <jarkko.sakkinen@intel.com>, <tangchen@cn.fujitsu.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
In-Reply-To: <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/27 13:04, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 7:38 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> 2013/02/27 11:30, Yinghai Lu wrote:
>>> Do you mean you can not boot one socket system with 1G ram ?
>>> Assume socket 0 does not support hotplug, other 31 sockets support hot
>>> plug.
>>>
>>> So we could boot system only with socket0, and later one by one hot
>>> add other cpus.
>>
>>
>> In this case, system can boot. But other cpus with bunch of ram hot
>> plug may fails, since system does not have enough memory for cover
>> hot added memory. When hot adding memory device, kernel object for the
>> memory is allocated from 1G ram since hot added memory has not been
>> enabled.
>>
>
> yes, it may fail, if the one node memory need page table and vmemmap
> is more than 1g ...
>

> for hot add memory we need to
> 1. add another wrapper for init_memory_mapping, just like
> init_mem_mapping() for booting path.
> 2. we need make memblock more generic, so we can use it with hot add
> memory during runtime.
> 3. with that we can initialize page table for hot added node with ram.
> a. initial page table for 2M near node top is from node0 ( that does
> not support hot plug).
> b. then will use 2M for memory below node top...
> c. with that we will make sure page table stay on local node.
>   alloc_low_pages need to be updated to support that.
> 4. need to make sure vmemmap on local node too.

I think so too. By this, memory hot plug becomes more useful.

Thanks,
Yasuaki Ishimatsu

>
> so hot-remove node will work too later.
>
> In the long run, we should make booting path and hot adding more
> similar and share at most code.
> That will make code get more test coverage.
>
> Thanks
>
> Yinghai
>


