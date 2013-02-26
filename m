Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab3BZHzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:55:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60947 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3BZHy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:54:58 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512C69FA.3010304@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 16:53:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Martin Bligh <mbligh@mbligh.org>,
        Ingo Molnar <mingo@elte.hu>, Don Morris <don.morris@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <a.p.zijlstra@chello.nl>,
        <jarkko.sakkinen@intel.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXs3MyUW+hJhupJgL-t9sYmT5GdeStWD2vMjsJG+6qCrQ@mail.gmail.com> <CAE9FiQXHNm+E+PchPsReOykVPNkRrC8ttjDpWWs=njANT+Wf1Q@mail.gmail.com> <CAJErZ53dadbU3oM4Prhi3n_R+Lsbp3TG=FP1=whTK5uPMpj90A@mail.gmail.com> <CAE9FiQWx=FdQSH_H_PoVxUksY6rFnN6yDfwmK3w8OTbCPLM1+w@mail.gmail.com> <CAJErZ53AWMP688OV+J0qiJii2y=qzEjLq=WshAQbMhEdyx33cQ@mail.gmail.com> <512C51B0.1000605@cn.fujitsu.com> <CAE9FiQVsmt4jhR=+Uyg+Cbh2AEF9-gAdoPiJrM8itaLCsAOKcA@mail.gmail.com>
In-Reply-To: <CAE9FiQVsmt4jhR=+Uyg+Cbh2AEF9-gAdoPiJrM8itaLCsAOKcA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

2013/02/26 15:57, Yinghai Lu wrote:
> On Mon, Feb 25, 2013 at 10:09 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
>> On 02/26/2013 12:51 PM, Martin Bligh wrote:
>>>>
>>>> Do you mean we can remove numaq x86 32bit code now?
>>>
>>>
>>> Wouldn't bother me at all. The machine is from 1995, end of life c. 2000?
>>> Was useful in the early days of getting NUMA up and running on Linux,
>>> but is now too old to be a museum piece, really.
>>>
>>> M.
>>>
>>
>> Hi Martin, Yinghai,
>>
>> It was me that I failed to make numa_init() fall back path working, and
>> forgot
>> to call early_parse_srat in ia64. Sorry for the breaking of other platform.
>> :)
>>
>> So now, is Yinghai's patch enough for this problem ?
>> Or we can encapsulate the following clear up work into one function ?
>>
>>
>> +               for (i = 0; i < MAX_LOCAL_APIC; i++)
>> +                       set_apicid_to_node(i, NUMA_NO_NODE);
>> +               nodes_clear(numa_nodes_parsed);
>> +               memset(&numa_meminfo, 0, sizeof(numa_meminfo));
>>
>>
>
> That is temporary workaround and your patch and this workaround make
> x86 acpi numa init too messy.
>
> I don't see the point to hack SRAT to make memory hotplug working.
>
> Do you guys check and use PMTT in ACPI spec instead?

I read PMTT specification in ACPI spec revision 5.0. But this table
does not have hotpluggable information. So we cannot know which memory
device can hotplug from this table.

Thanks,
Yasuaki Ishimatsu

>
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


