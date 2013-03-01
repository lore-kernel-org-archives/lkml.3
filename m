Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3CAICb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:02:31 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:45303 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CAIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <5130484D.1020701@cn.fujitsu.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
	<512D7FAD.1040003@jp.fujitsu.com>
	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
	<512D8EDA.3010602@jp.fujitsu.com>
	<CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
	<512DBD24.7090302@cn.fujitsu.com>
	<20130227132612.14664a3a.akpm@linux-foundation.org>
	<CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com>
	<51302481.9070005@cn.fujitsu.com>
	<CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com>
	<513030AF.70208@zytor.com>
	<CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com>
	<5130484D.1020701@cn.fujitsu.com>
Date: Fri, 1 Mar 2013 00:02:29 -0800
X-Google-Sender-Auth: HKSOnSWSnoxrDNRb8c3OhjdmftI
Message-ID: <CAE9FiQVeqf9prg6LdXuEJcGeHSH=Rf-JTgv5xfo+oECNdu47nQ@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:18 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 03/01/2013 01:00 PM, Yinghai Lu wrote:
>>
>> On Thursday, February 28, 2013, H. Peter Anvin wrote:
>>
>>> On 02/28/2013 08:32 PM, Linus Torvalds wrote:
>>>>
>>>> Yingai, Andrew,
>>>>   is this ok with you two?
>>>>
>>>>          Linus
>>>
>>>
>>> FWIW, it makes sense to me iff it resolves the problems
>>
>>
>>
>> I prefer to reverting all 8 patches.
>>
>> Actually I have worked out one patch that could solve all problems, but it
>> is too intrusive that I do      not want to split it to small pieces to
>> post it.
>>
>> Leaving the movablemem_map related changes in  the upstream tree,
>> will prevent me from continuing to make memblock to be used to allocate
>> page table on local node ram for hot add.
>
>
> Hi Yinghai,
>
> Would you please give me a url to your code ?
>
> I don't think movablemem_map will block your work a lot. According to your
> description, you are modifying memblock to reserve some memory for local
> node pagetables, right ?

My idea:
current for hotadd mem, page table will from other nodes from slub.
that is not right. that will prevent others nodes to be hot removed.

To fix the problem
a. make memblock still alive after booting.
b. or have separated dynamical memblock.

second way looks more clean.
so alloc_low_pages will get initial page for page table from low range
with slub.
and later will get page table from its own just mapped range.

Now need to make memblock more clean and remove hardcoded reference in
those functions.

Thanks

Yinghai
