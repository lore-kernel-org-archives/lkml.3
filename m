Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3LCWDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:03:31 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39724 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3LCWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131203134701.e3bc01aa8b20bddfb73f53c6@linux-foundation.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
	<1386106054-27636-3-git-send-email-keescook@chromium.org>
	<20131203134701.e3bc01aa8b20bddfb73f53c6@linux-foundation.org>
Date: Tue, 3 Dec 2013 14:03:22 -0800
X-Google-Sender-Auth: kHuUufFxrHlUMqaDpP2lYjifqrI
Message-ID: <CAGXu5j+E+UT5cBTSwh4PbPCojGk0jqCFhzMaa6BnjKYSE_CgTg@mail.gmail.com>
Subject: Re: [PATCH 2/2] test: check copy_to/from_user boundary validation
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 1:47 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  3 Dec 2013 13:27:34 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> To help avoid an architecture failing to correctly check kernel/user
>> boundaries when handling copy_to_user, copy_from_user, put_user, or
>> get_user, perform some simple tests and fail to load if any of them
>> behave unexpectedly.
>>
>> Specifically, this is to make sure there is a way to notice if things
>> like what was fixed in 8404663f81d212918ff85f493649a7991209fa04 ("ARM:
>> 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS")
>> ever regresses again, for any architecture.
>
> I guess the challenge will be to get anyone to remember to run this.

FWIW, I'll be running it. :) I'm sure Fengguang Wu could add it too.

> Really, this could be viewed as a candidate for
> tools/testing/selftests.  The tests in there are userspace tests, and
> your userspace test would consist of "modprobe test_user_copy".  The
> advantage of this is that your test will get included whenever someone
> runs the selftest suite.  This is better than having it stranded over
> in ./kernel/.

Sure, I'd be happy to add logic to that area too.

>> ---
>>  kernel/Makefile         |    1 +
>>  kernel/test_user_copy.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++
>>  lib/Kconfig.debug       |   13 ++++++
>
> We already have a whole pile of test modules - seven of them reside in
> lib/ and I think there's an RCU one somewhere.  Can we bring order to
> all of this?  Some form of integration under tools/testing would be one
> approach.

I expect to be adding more of these, and I'd like to see these
collected in a single place as well. There are things like test_nx.c
in the x86 tree (which actually doesn't work any more, but that's a
separate issue).

> If you're disinclined to undertake such a project at this time, I'd
> suggest these two go into lib/ so they are known about if/when someone
> goes for the big cleanup.

lib/ sounds good. I'll move them there.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
