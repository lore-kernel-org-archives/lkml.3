Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3CACAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:00:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab3CACAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:00:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,758,1355068800"; 
   d="scan'208";a="6790373"
Message-ID: <513006ED.7080506@cn.fujitsu.com>
Date: Fri, 01 Mar 2013 09:39:57 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512D9E69.6010102@jp.fujitsu.com> <CAE9FiQV9JRk1SYLkBXsQmrSEDHrYZDpBV6UZb+U5rB7=4gFhVA@mail.gmail.com> <512DB199.5050203@cn.fujitsu.com> <CAE9FiQXvdXoW8xFO2Q_dJo4jRkse5Lg9TmLHuFhqZ9H92ipsuw@mail.gmail.com> <512DB96E.5030408@cn.fujitsu.com> <CAE9FiQWx9TUwF6mXyhKDX=OZNsubvDebViyyTrA9EQpBZ6FsKw@mail.gmail.com>
In-Reply-To: <CAE9FiQWx9TUwF6mXyhKDX=OZNsubvDebViyyTrA9EQpBZ6FsKw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 09:39:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 09:39:43,
	Serialize complete at 2013/03/01 09:39:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 12:07 AM, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 11:44 PM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>>
>> Sorry, if you want to revert, you just need to revert:
>>
>>   commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
>>        acpi, memory-hotplug: parse SRAT before memblock is ready
>>   commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
>>        acpi, memory-hotplug: support getting hotplug info from SRAT
>>
>> The other two have nothing to do with SRAT. And they are necessary.
>>
>> Seeing from the code, I think it is clean. But we'd better test it.
>
> We should revert them all.
>
> as
>
> commit fb06bc8e5f42f38c011de0e59481f464a82380f6
> Author: Tang Chen<tangchen@cn.fujitsu.com>
> Date:   Fri Feb 22 16:33:42 2013 -0800
>
>      page_alloc: bootmem limit with movablecore_map
>
> It is totally misleading in the TITLE. Come on, what is movablecore_map?
>
> It actually use movablemem_map to exclude some range during
> memblock_find_in_range.
>
> That make memblock less generic.
>
> That patch is the base of the whole patchset.
>
> Also you and Yasuaki keep saying: movablemem_map=srat.
> But where is doc and code for it?
> Looks like there is only movablemem_map=acpi.

Hi Yinghai,

I think I forgot to change the title when merging the related bugfix patches
into one. And yes, movablecore_map has been changed to movablemem_map.

How about this:

For now, let's revert the SRAT related patch, and keep 
movablecore_map=nn[KMG]@ss[KMG].

About the SRAT thing, we have the following solution:

1) keep the original init series, parse acpi tables and modify global 
variables as before
2) introduce a new function to obtain SRAT info earlier, store the info 
somewhere,
    and touch no numa related thing
3) use the info to do movablemem_map thing, and free them when it is done

In this way, we keep our code isolated from numa code. And the numa will 
be initialized as before.
This can be done in one week or faster. And I'll cc x86 guys, and they 
can choose whenever
to merge the new code.


And about movablecore_map=nn[KMG]@ss[KMG] code, there is no harm to the 
kernel. And we
have documented it that using this option will cause numa performance 
down. And users who
don't want to lose the numa performance can boot the kernel without this 
option, and the
kernel will work as before.

I do hope we can keep the code in 3.9, and do more improvement in the 
future.
So please just revert the two SRAT related patches.


Thanks. :)

>
> I'm upset by this patchset.
>
> Next time, please get Ack from TJ or Ben when you touch memblock code.
> And at least make the TITLE is right.
>
> Thanks
>
> Yinghai
>
