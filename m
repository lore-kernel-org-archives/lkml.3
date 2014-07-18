Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbaGRJEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:04:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20992 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754394AbaGRJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:04:23 -0400
X-IronPort-AV: E=Sophos;i="5.00,914,1396972800"; 
   d="scan'208";a="33450965"
Message-ID: <53C8E350.6040705@cn.fujitsu.com>
Date: Fri, 18 Jul 2014 17:05:20 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Jan Kiszka <jan.kiszka@web.de>, <mtosatti@redhat.com>,
        <nadav.amit@gmail.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com> <53C51608.4080109@web.de> <20140715120921.GT18167@minantech.com> <53C51E66.7030208@cn.fujitsu.com> <20140715124048.GU18167@minantech.com> <53C7D0DC.1020001@cn.fujitsu.com> <20140717135707.GP4399@minantech.com>
In-Reply-To: <20140717135707.GP4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 07/17/2014 09:57 PM, Gleb Natapov wrote:
> On Thu, Jul 17, 2014 at 09:34:20PM +0800, Tang Chen wrote:
>> Hi Gleb,
>>
>> On 07/15/2014 08:40 PM, Gleb Natapov wrote:
>> ......
>>>>
>>>> And yes, we have the problem you said here. We can migrate the page while L2
>>>> vm is running.
>>>> So I think we should enforce L2 vm to exit to L1. Right ?
>>>>
>>> We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
>>> if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
>>>
>>
>> Sorry, I think I don't quite understand the procedure you are talking about
>> here.
>>
>> Referring to the code, I think we have three machines: L0(host), L1 and L2.
>> And we have two types of vmexit: L2->L1 and L2->L0.  Right ?
>>
>> We are now talking about this case: L2 and L1 shares the apic page.
>>
>> Using patch 5/5, when apic page is migrated on L0, mmu_notifier will notify
>> L1,
>> and update L1's VMCS. At this time, we are in L0, not L2. Why cannot we
> Using patch 5/5, when apic page is migrated on L0, mmu_notifier will notify
> L1 or L2 VMCS depending on which one happens to be running right now.
> If it is L1 then L2's VMCS will be updated during vmentry emulation,

OK, this is easy to understand.

>if it is
> L2 we need to request reload during vmexit emulation to make sure L1's VMCS is
> updated.
>

I'm a little confused here. In patch 5/5, I called 
make_all_cpus_request() to
force all vcpus exit to host. If we are in L2, where will the vcpus exit 
to ?
L1 or L0 ?

Thanks.

