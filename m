Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbaCQKA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:00:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41367 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbaCQKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:00:56 -0400
Message-ID: <5326C690.4090107@oracle.com>
Date: Mon, 17 Mar 2014 10:55:28 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Vegard Nossum <vegard.nossum@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: kmemcheck: OS boot failed because NMI handlers access the memory
 tracked by kmemcheck
References: <5326BE25.9090201@huawei.com> <20140317095141.GA4777@dhcp22.suse.cz>
In-Reply-To: <20140317095141.GA4777@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 10:51 AM, Michal Hocko wrote:
> On Mon 17-03-14 17:19:33, Xishi Qiu wrote:
>> OS boot failed when set cmdline kmemcheck=1. The reason is that
>> NMI handlers will access the memory from kmalloc(), this will cause
>> page fault, because memory from kmalloc() is tracked by kmemcheck.
>>
>> watchdog_nmi_enable()
>> 	perf_event_create_kernel_counter()
>> 		perf_event_alloc()
>> 			event = kzalloc(sizeof(*event), GFP_KERNEL);
>
> Where is this path called from an NMI context?
>
> Your trace bellow points at something else and it doesn't seem to
> allocate any memory either. It looks more like x86_perf_event_update
> sees an invalid perf_event or something like that...
>

It's not important that the kzalloc() is called from NMI context, it's 
important that the memory that was allocated is touched (read/written) 
from NMI context.

I'm currently looking into the possibility of handling recursive faults 
in kmemcheck (using the approach outlined by peterz; see 
https://lkml.org/lkml/2014/2/26/141).


Vegard
