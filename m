Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706AbaGRRFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:05:03 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:32878 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030432AbaGRRFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140717220849.735bec65@gandalf.local.home>
References: <20140630144017.2abc48ba@gandalf.local.home>
	<b29c17f74d39d1b9240385e7479f63f44c988b8b.1404160039.git.tony.luck@intel.com>
	<CA+8MBbKgHqwzLbY17-6o_Y-EULatnXgTdgn2kUhhOabELYGV6w@mail.gmail.com>
	<20140717220849.735bec65@gandalf.local.home>
Date: Fri, 18 Jul 2014 10:05:00 -0700
Message-ID: <CA+8MBb++z4px4wBCh6EzfgO6rQeLdBWNY+j8Aub352v5ONQiAw@mail.gmail.com>
Subject: Re: [PATCH-v2] tracing: Fix wraparound problems in "uptime" tracer
From: Tony Luck <tony.luck@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "<m.chehab@samsung.com> Xie XiuQi" <xiexiuqi@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 7:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> Do we really need to convert to nanoseconds? Couldn't we just return
>> jiffies:
>
> Sure, and we can make it a "counter". That is, the counters don't hide
> 1000 counts on output.

Can you explain that a bit more ... how do we mark it as a "counter"?

>> u64 notrace trace_clock_jiffies(void)
>> {
>>        return jiffies_64 - INITIAL_JIFFIES;
>> }

Hmm it seems that we make it hard for applications to see what HZ
value the kernel is actually using. All user-facing interfaces should
convert to USER_HZ (100).  So we should say:

u64 notrace trace_clock_jiffies(void)
{
        return jiffies_64_to_clock_t(jiffies_64 - INITIAL_JIFFIES);
}

Do we need to change anything in Documentation/trace/ftrace.txt?

Currently it says:

          uptime: This uses the jiffies counter and the time stamp
                  is relative to the time since boot up.

-Tony
