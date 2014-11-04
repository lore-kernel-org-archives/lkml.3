Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaKDJUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:20:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49148 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaKDJUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:20:48 -0500
Message-ID: <54589A78.1060406@arm.com>
Date: Tue, 04 Nov 2014 09:20:56 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com> <20141103104111.GA23531@worktop.programming.kicks-ass.net> <20141103235747.GA26702@kernel> <20141104083225.GG10501@worktop.programming.kicks-ass.net> <20141104082345.GA22062@kernel>
In-Reply-To: <20141104082345.GA22062@kernel>
X-OriginalArrivalTime: 04 Nov 2014 09:20:44.0181 (UTC) FILETIME=[9C429C50:01CFF810]
X-MC-Unique: 114110409204600701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/14 08:23, Wanpeng Li wrote:
> Hi Peter,
> On Tue, Nov 04, 2014 at 09:32:25AM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 04, 2014 at 07:57:48AM +0800, Wanpeng Li wrote:
>>> On Mon, Nov 03, 2014 at 11:41:11AM +0100, Peter Zijlstra wrote:
>>
>>>> On Fri, Oct 31, 2014 at 03:28:17PM +0800, Wanpeng Li wrote:
>>>> So what is wrong with making dl_task_timer() deal with it? The timer
>>>> will still fire on the correct time, canceling it and or otherwise
>>>> messing with the CBS is wrong. Once it fires, all we need to do is
>>>> migrate it to another cpu (preferably one that is still online of course
>>>> :-).
>>
>>> Do you mean what I need to do is push the task to another cpu in dl_task_timer() 
>>> if rq is offline?
>>
>> That does indeed appear to be the sensible fix to me.
>>
>>> In addition, what will happen if dl task can't preempt on 
>>> another cpu?
>>
>> So if we find that the rq the task was on is no longer available, we
>> need to select a new rq, the 'right' rq would be the one running the
>> latest deadline.
>>
>> If it cannot preempt the latest (running) deadline, it was not eligible
>> for running in the first place so no worries, right?
> 
> I think this will lead to this deadline task cannot running on any rqs any more.
> If my understanding is not right, when it will be picked?
> 

I think you can just pick one random rq and move the task there. The
push/pull mechanism should then move it around properly.

Thanks,

- Juri

