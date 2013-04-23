Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3DWBZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:25:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52177 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3DWBZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:25:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5175E2D4.5030004@jp.fujitsu.com>
Date: Tue, 23 Apr 2013 10:24:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <kosaki.motohiro@gmail.com>, <mingo@kernel.org>, <hpa@zytor.com>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v2] numa, cpu hotplug: Change links of CPU and
 node when changing node number by onlining CPU
References: <5170D4CB.20900@jp.fujitsu.com> <20130422153541.04ba682f13910cfede0d2ff7@linux-foundation.org> <5175D01E.5000302@jp.fujitsu.com> <20130422173459.487fa3e6.akpm@linux-foundation.org>
In-Reply-To: <20130422173459.487fa3e6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/23 9:34, Andrew Morton wrote:
> On Tue, 23 Apr 2013 09:04:46 +0900 Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
>
>> 2013/04/23 7:35, Andrew Morton wrote:
>>> On Fri, 19 Apr 2013 14:23:23 +0900 Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>>
>>>> When booting x86 system contains memoryless node, node numbers of CPUs
>>>> on memoryless node were changed to nearest online node number by
>>>> init_cpu_to_node() because the node is not online.
>>>>
>>>> ...
>>>>
>>>> If we hot add memory to memoryless node and offine/online all CPUs on
>>>> the node, node numbers of these CPUs are changed to correct node numbers
>>>> by srat_detect_node() because the node become online.
>>>
>>> OK, here's a dumb question.
>>>
>>> At boot time the CPUs are assigned to the "nearest online node" rather
>>> than to their real memoryless node.  The patch arranges for those CPUs
>>> to still be assigned to the "nearest online node" _after_ some memory
>>> is hot-added to their real node.  Correct?
>>
>> Yes. For changing node number of CPUs safely, we should offline CPUs.
>>
>>>
>>> Would it not be better to fix this by assigning those CPUs to their real,
>>> memoryless node right at the initial boot?  Or is there something in
>>> the kernel which makes cpus-on-a-memoryless-node not work correctly?
>>>
>>
>> I think assigning CPUs to real node is better. But current Linux's node
>> strongly depend on memory. Thus if we just create cpus-on-a-memoryless-node,
>> the kernel cannot work correctly.
>
> hm, why.  I'd have thought that if we tell the kernel something like
> "this node has one zone, the size of which is zero bytes" then a
> surprising amount of the existing code will Just Work.
>
> What goes wrong?

Sorry I forgot detailed issue.
When I saw following issue, I tried to fix it and found that current
Linux's node strongly depend on memory.
https://lkml.org/lkml/2012/9/12/20

I'll try to fix it again.

Thanks,
Yasuaki Ishimatsu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


