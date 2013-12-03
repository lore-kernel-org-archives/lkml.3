Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3LCVrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:47:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3LCVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:47:03 -0500
Date: Tue, 3 Dec 2013 13:47:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] test: check copy_to/from_user boundary validation
Message-Id: <20131203134701.e3bc01aa8b20bddfb73f53c6@linux-foundation.org>
In-Reply-To: <1386106054-27636-3-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
	<1386106054-27636-3-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Dec 2013 13:27:34 -0800 Kees Cook <keescook@chromium.org> wrote:

> To help avoid an architecture failing to correctly check kernel/user
> boundaries when handling copy_to_user, copy_from_user, put_user, or
> get_user, perform some simple tests and fail to load if any of them
> behave unexpectedly.
> 
> Specifically, this is to make sure there is a way to notice if things
> like what was fixed in 8404663f81d212918ff85f493649a7991209fa04 ("ARM:
> 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS")
> ever regresses again, for any architecture.

I guess the challenge will be to get anyone to remember to run this.

Really, this could be viewed as a candidate for
tools/testing/selftests.  The tests in there are userspace tests, and
your userspace test would consist of "modprobe test_user_copy".  The
advantage of this is that your test will get included whenever someone
runs the selftest suite.  This is better than having it stranded over
in ./kernel/.

> ---
>  kernel/Makefile         |    1 +
>  kernel/test_user_copy.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug       |   13 ++++++

We already have a whole pile of test modules - seven of them reside in
lib/ and I think there's an RCU one somewhere.  Can we bring order to
all of this?  Some form of integration under tools/testing would be one
approach.

If you're disinclined to undertake such a project at this time, I'd
suggest these two go into lib/ so they are known about if/when someone
goes for the big cleanup.

