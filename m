Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967451Ab3DRPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:53:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:57972 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3DRPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:53:52 -0400
Message-ID: <51701722.1070407@windriver.com>
Date: Thu, 18 Apr 2013 11:54:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>  <20130415093330.GC17715@gmail.com> <1366283681.19383.5.camel@laptop>
In-Reply-To: <1366283681.19383.5.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-04-18 07:14 AM, Peter Zijlstra wrote:
> On Mon, 2013-04-15 at 11:33 +0200, Ingo Molnar wrote:
>> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>>
>>> Recent activity has had a focus on moving functionally related blocks of stuff 
>>> out of sched/core.c into stand-alone files.  The code relating to load average 
>>> calculations has grown significantly enough recently to warrant placing it in a 
>>> separate file.
>>>
>>> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
>>>
>>> A couple small static functions in the core sched.h header were also localized 
>>> to their singular user in sched/fair.c at the same time, with the goal to also 
>>> reduce the amount of "broadcast" content in that sched.h file.
>>
>> Nice!
>>
>> Peter, is this (and the naming of the new file) fine with you too?
> 
> Yes and no.. that is I do like the change, but I don't like the
> filename. We have _waaaay_ too many different things we call load_avg.
> 
> That said, I'm having a somewhat hard time coming up with a coherent
> alternative :/

Several of the relocated functions start their name with "calc_load..."
Does "calc_load.c" sound any better?

