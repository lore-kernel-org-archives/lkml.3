Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaAWIpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:45:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaAWIpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:45:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,705,1384272000"; 
   d="scan'208";a="9447276"
Message-ID: <52E18CF5.5090202@cn.fujitsu.com>
Date: Thu, 23 Jan 2014 16:43:17 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH] tracing: Use task_nice() in function __update_max_tr()
 to get the nice value of task.
References: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140122225632.73c2fbdf@gandalf.local.home> <20140122230029.638e9a53@gandalf.local.home> <52E14D28.2090208@cn.fujitsu.com> <20140123082630.GO30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140123082630.GO30183@twins.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 16:44:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 16:44:10,
	Serialize complete at 2014/01/23 16:44:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 03:26 AM, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 12:11:04PM -0500, Dongsheng Yang wrote:
>> On 01/22/2014 11:00 PM, Steven Rostedt wrote:
>>> Bah, I just noticed that TASK_NICE is in kernel/sched/sched.h not
>>> include/linux/sched.h
>>>
>>> Peter, is there a reason that task_nice() is not a static inline in
>>> sched.h and have these macros there too? They only reference fields in
>>> task_struct that are already defined there. I don't see why they need
>>> to be private to kernel/sched.
>> Agree. These macros are useful to other modules out of kernel/sched.
>> But they are private to kernel/sched currently.
> And the floodgates open.. _why_ would a module care about nice values?
> That's sounds just so full of wrong.

Sorry for my misnomer with 'modules'. Actually I mean other subsystems in
kernel, such as trace, sched, rcu. :)

I did not mean the module for modprobe.

Sorry for my terrible expression :(.
>

