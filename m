Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3CAGT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:19:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3CAGTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:19:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,759,1355068800"; 
   d="scan'208";a="6792307"
Message-ID: <5130484D.1020701@cn.fujitsu.com>
Date: Fri, 01 Mar 2013 14:18:53 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512DBD24.7090302@cn.fujitsu.com> <20130227132612.14664a3a.akpm@linux-foundation.org> <CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com> <51302481.9070005@cn.fujitsu.com> <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com> <513030AF.70208@zytor.com> <CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com>
In-Reply-To: <CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 14:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 14:18:29,
	Serialize complete at 2013/03/01 14:18:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 01:00 PM, Yinghai Lu wrote:
> On Thursday, February 28, 2013, H. Peter Anvin wrote:
>
>> On 02/28/2013 08:32 PM, Linus Torvalds wrote:
>>> Yingai, Andrew,
>>>   is this ok with you two?
>>>
>>>          Linus
>>
>> FWIW, it makes sense to me iff it resolves the problems
>
>
> I prefer to reverting all 8 patches.
>
> Actually I have worked out one patch that could solve all problems, but it
> is too intrusive that I do      not want to split it to small pieces to
> post it.
>
> Leaving the movablemem_map related changes in  the upstream tree,
> will prevent me from continuing to make memblock to be used to allocate
> page table on local node ram for hot add.

Hi Yinghai,

Would you please give me a url to your code ?

I don't think movablemem_map will block your work a lot. According to your
description, you are modifying memblock to reserve some memory for local
node pagetables, right ?

If so, I think it won't be too difficult to make the code OK with your work.

Thanks. :)

>
> Will send reverting patch and putting page table on local node patch around
> 10pm after I get home.
>
> Thanks
>
