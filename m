Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaCKJ3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:29:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaCKJ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:29:35 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678025"
Message-ID: <531ED706.8030701@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 17:27:34 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16] kernel/sys: Replace opened code implementation
 with nice_to_rlimit().
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com> <23d8f4c6d70b34d29b5f69e30b19cfb920889ede.1394529373.git.yangds.fnst@cn.fujitsu.com> <20140311092608.GT9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140311092608.GT9987@twins.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:26:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:26:48,
	Serialize complete at 2014/03/11 17:26:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 05:26 PM, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 05:20:23PM +0800, Dongsheng Yang wrote:
>> From: Joe Perches <joe@perches.com>
>>
>> Convert 20 - task_nice(p) to nice_to_rlimit(task_nice(p)).
>>
>> Reduce the indent the switch case labels while there.
>>
>> git diff -w shows 3 lines changed and a /* fall-through */ comment added
>>
>>    $ git diff -w -U0 kernel/sys.c
>>    @@ -253 +253 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>>    -                               niceval = 20 - task_nice(p);
>>    +                       niceval = nice_to_rlimit(task_nice(p));
>>    @@ -264 +264 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>>    -                               niceval = 20 - task_nice(p);
>>    +                       niceval = nice_to_rlimit(task_nice(p));
>>    @@ -280 +280 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>>    -                                       niceval = 20 - task_nice(p);
>>    +                               niceval = nice_to_rlimit(task_nice(p));
>>    @@ -1558 +1558 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>>    -
>>    +               /* fall-through */
>>
> I would really like to see the whitespace changes separated. I can push
> a scheduler related change into other subsystems, but massive surgery
> like this should not come through the scheduler tree.

Okey, Peter, I will send a single patch about the whitespace changes and 
update
this patch in this thread soon.

Thanx
>
>

