Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3IYFuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:50:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:37223 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3IYFt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:49:59 -0400
Message-ID: <52427970.8010905@windriver.com>
Date: Wed, 25 Sep 2013 13:49:36 +0800
From: Ming Liu <ming.liu@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <akpm@linux-foundation.org>, <mhocko@suse.cz>, <rusty@rustcorp.com.au>,
        <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom: avoid killing init if it assume the oom killed thread's
 mm
References: <1379929528-19179-1-git-send-email-ming.liu@windriver.com> <alpine.DEB.2.02.1309241933590.26187@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309241933590.26187@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:34 AM, David Rientjes wrote:
> On Mon, 23 Sep 2013, Ming Liu wrote:
>
>> After selecting a task to kill, the oom killer iterates all processes and
>> kills all other user threads that share the same mm_struct in different
>> thread groups.
>>
>> But in some extreme cases, the selected task happens to be a vfork child
>> of init process sharing the same mm_struct with it, which causes kernel
>> panic on init getting killed. This panic is observed in a busybox shell
>> that busybox itself is init, with a kthread keeps consuming memories.
>>
> We shouldn't be selecting a process where mm == init_mm in the first
> place, so this wouldn't fix the issue entirely.

But if we add a control point for "mm == init_mm" in the first place(ie. 
in oom_unkillable_task), that would forbid the processes sharing mm with 
init to be selected, is that reasonable? Actually my fix is just to 
protect init process to be killed for its vfork child being selected and 
I think it's the only place where there is the risk. If my understanding 
is wrong, pls correct me.

Thanks,
Ming Liu
>
>

