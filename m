Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3CAIkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:40:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53057 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3CAIkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:40:20 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5130694E.6020009@jp.fujitsu.com>
Date: Fri, 1 Mar 2013 17:39:42 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        Gui jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512DBD24.7090302@cn.fujitsu.com> <20130227132612.14664a3a.akpm@linux-foundation.org> <CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com> <51302481.9070005@cn.fujitsu.com> <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com> <513030AF.70208@zytor.com> <CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com> <5130484D.1020701@cn.fujitsu.com> <CAE9FiQVeqf9prg6LdXuEJcGeHSH=Rf-JTgv5xfo+oECNdu47nQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVeqf9prg6LdXuEJcGeHSH=Rf-JTgv5xfo+oECNdu47nQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/03/01 17:02, Yinghai Lu wrote:
> On Thu, Feb 28, 2013 at 10:18 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
>> On 03/01/2013 01:00 PM, Yinghai Lu wrote:
>>>
>>> On Thursday, February 28, 2013, H. Peter Anvin wrote:
>>>
>>>> On 02/28/2013 08:32 PM, Linus Torvalds wrote:
>>>>>
>>>>> Yingai, Andrew,
>>>>>    is this ok with you two?
>>>>>
>>>>>           Linus
>>>>
>>>>
>>>> FWIW, it makes sense to me iff it resolves the problems
>>>
>>>
>>>
>>> I prefer to reverting all 8 patches.
>>>
>>> Actually I have worked out one patch that could solve all problems, but it
>>> is too intrusive that I do      not want to split it to small pieces to
>>> post it.
>>>
>>> Leaving the movablemem_map related changes in  the upstream tree,
>>> will prevent me from continuing to make memblock to be used to allocate
>>> page table on local node ram for hot add.
>>
>>
>> Hi Yinghai,
>>
>> Would you please give me a url to your code ?
>>
>> I don't think movablemem_map will block your work a lot. According to your
>> description, you are modifying memblock to reserve some memory for local
>> node pagetables, right ?
>

> My idea:
> current for hotadd mem, page table will from other nodes from slub.
> that is not right. that will prevent others nodes to be hot removed.

If we use your idea, pglist_data and zone are also allocated from local
node. In my understanding, pglist_data and zone cannot be deleted safely
since there is no way to guarantee that nobody use them. So it means
that all nodes cannot be hot removed.
If you develop your idea, you should consider memory hot remove.

Thanks,
Yasuaki Ishimatsu

>
> To fix the problem
> a. make memblock still alive after booting.
> b. or have separated dynamical memblock.
>
> second way looks more clean.
> so alloc_low_pages will get initial page for page table from low range
> with slub.
> and later will get page table from its own just mapped range.
>
> Now need to make memblock more clean and remove hardcoded reference in
> those functions.
>
> Thanks
>
> Yinghai
>


