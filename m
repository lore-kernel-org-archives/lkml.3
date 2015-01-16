Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbbAPRxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:53:15 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44958 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbbAPRxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:53:13 -0500
Message-ID: <54B95006.3080502@osg.samsung.com>
Date: Fri, 16 Jan 2015 10:53:10 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
CC: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] selftests: Introduce minimal shared logic for running
 tests
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 02:06 AM, Michael Ellerman wrote:
> This adds a Make include file which most selftests can then include to
> get the run_tests logic.
> 
> On its own this has the advantage of some reduction in repetition, and
> also means the pass/fail message is defined in fewer places.
> 
> However the key advantage is it will allow us to implement install very
> simply in a subsequent patch.
> 
> The default implementation just executes each program in $(TEST_PROGS).
> 
> We use a variable to hold the default implementation of $(RUN_TESTS)
> because that gives us a clean way to override it if necessary, ie. using
> override. The mount, memory-hotplug and mqueue tests use that to provide
> a different implementation.
> 
> Tests are not run via /bin/bash, so if they are scripts they must be
> executable, we add u+x to several.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

I like the shared logic approach in general provided it leaves the
flexibility to not use the shared logic if a test have the need to
do so. This series requires some patch planning. shared logic patch
followed by individual test patches as opposed a single patch.

I would like to see the shared logic work done on top of my patch v4
series.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
