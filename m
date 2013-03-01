Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3CAEcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:32:19 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47513 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3CAEcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <51302481.9070005@cn.fujitsu.com>
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
Date: Thu, 28 Feb 2013 20:32:15 -0800
X-Google-Sender-Auth: SugflxQFkFwI-ooY0qhVhPNs7SE
Message-ID: <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        Gui jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yingai, Andrew,
 is this ok with you two?

        Linus

On Thu, Feb 28, 2013 at 7:46 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Linus,
>
> Please refer to the attached patch.
>
> This patch everts only the following two patches.
>
>
>         commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
>                 acpi, memory-hotplug: support getting hotplug info from SRAT
>         commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
>
>                 acpi, memory-hotplug: parse SRAT before memblock is ready
>
> Without these two patches, users can use "movablemem_map=nn[KMG]@ss[KMG]"
> correctly, and cause no problem.
>
> And of course, the kernel will work as before if users don't use
>
> "movablemem_map=nn[KMG]@ss[KMG]".
>
> I do hope we can keep "movablemem_map=nn[KMG]@ss[KMG]" in 3.9.
>
>
> We are working on fixing the SRAT problems, and we aims to push SRAT related
> patches in 3.10. And we will also improve "movablemem_map=nn[KMG]@ss[KMG]"
> functionality consistently in the future.
>
> Thanks. :)
>
>
> On 03/01/2013 11:13 AM, Linus Torvalds wrote:
>>
>> On Wed, Feb 27, 2013 at 1:26 PM, Andrew Morton
>> <akpm@linux-foundation.org>  wrote:
>>>
>>>
>>> So I'm thinking that the best approach here is to revert everything and
>>> then try again for 3.10-rc1.  This gives people time to test the code
>>> while it's only in linux-next.  (Hint!)
>>
>>
>> I'd prefer to revert too by now - the bug seems to be known, and
>> apparently it's not a trivial fix. We're getting close to the end of
>> the merge window, and it's still being discussed, it clearly wasn't
>> really fully cooked.
>>
>> Can we agree on some minimal set of reverts? Can somebody send me a
>> patch with the revert and the commit explanation for the revert?
>> Yinghai? Or I can do the reverts too if just the exact set of commits
>> is clear, but I'd rather get it from somebody who sees and understand
>> the problem, and can test the state afterwards..
>>
>>                 Linus
>>
>
