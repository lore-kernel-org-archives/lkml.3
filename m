Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbbASQjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:39:14 -0500
Received: from lists.s-osg.org ([54.187.51.154]:53317 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbbASQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:39:11 -0500
Message-ID: <54BD332D.6010907@osg.samsung.com>
Date: Mon, 19 Jan 2015 09:39:09 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, mmarek@suse.cz, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] selftests: Introduce minimal shared logic for running
 tests
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au> <54B95006.3080502@osg.samsung.com> <1421627742.3787.6.camel@ellerman.id.au>
In-Reply-To: <1421627742.3787.6.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 05:35 PM, Michael Ellerman wrote:
> On Fri, 2015-01-16 at 10:53 -0700, Shuah Khan wrote:
>> On 01/09/2015 02:06 AM, Michael Ellerman wrote:
>>> This adds a Make include file which most selftests can then include to
>>> get the run_tests logic.
>>>
>>> On its own this has the advantage of some reduction in repetition, and
>>> also means the pass/fail message is defined in fewer places.
>>>
>>> However the key advantage is it will allow us to implement install very
>>> simply in a subsequent patch.
>>>
>>> The default implementation just executes each program in $(TEST_PROGS).
>>>
>>> We use a variable to hold the default implementation of $(RUN_TESTS)
>>> because that gives us a clean way to override it if necessary, ie. using
>>> override. The mount, memory-hotplug and mqueue tests use that to provide
>>> a different implementation.
>>>
>>> Tests are not run via /bin/bash, so if they are scripts they must be
>>> executable, we add u+x to several.
>>>
>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>
>> I like the shared logic approach in general provided it leaves the
>> flexibility to not use the shared logic if a test have the need to
>> do so.
> 
> Yes of course it does, it's entirely optional to include lib.mk.
> 
>> This series requires some patch planning. shared logic patch
>> followed by individual test patches as opposed a single patch.
> 
> It could be a single patch too, but there's no reason to do it that way. The
> series works fine as I sent it.
> 
>> I would like to see the shared logic work done on top of my patch v4
>> series.
> 
> That's a waste of time. This series replaces your v4. Doing this "on top" of
> your v4 would just mean reverting your v4 series and then applying this.
> 

No necessarily if the work is done as evolutionary step. In any case,
I want the first step install target support going into the upcoming
release and then make improvements to it. Please send separate patch
for the shared logic and individual test patches that use the shared
logic if you would like to make the improvements.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
