Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaL2PZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:25:00 -0500
Received: from lists.s-osg.org ([54.187.51.154]:42095 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaL2PYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:24:54 -0500
Message-ID: <54A1723E.5040206@osg.samsung.com>
Date: Mon, 29 Dec 2014 08:24:46 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 00/20] kselftest install target feature
References: <cover.1419387513.git.shuahkh@osg.samsung.com> <1419828790.26911.3.camel@ellerman.id.au>
In-Reply-To: <1419828790.26911.3.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 09:53 PM, Michael Ellerman wrote:
> On Wed, 2014-12-24 at 09:27 -0700, Shuah Khan wrote:
>> This patch series adds a new kselftest_install make target
>> to enable selftest install. When make kselftest_install is
>> run, selftests are installed on the system. A new install
>> target is added to selftests Makefile which will install
>> targets for the tests that are specified in INSTALL_TARGETS.
>> During install, a script is generated to run tests that are
>> installed. This script will be installed in the selftest install
>> directory. Individual test Makefiles are changed to add to the
>> script. This will allow new tests to add install and run test
>> commands to the generated kselftest script. kselftest target
>> now depends on kselftest_install and runs the generated kselftest
>> script to reduce duplicate work and for common look and feel when
>> running tests.
>>
>> This approach leverages and extends the existing framework that
>> uses makefile targets to implement run_tests and adds install
>> target. This will scale well as new tests get added and makes
>> it easier for test writers to add install target at the same
>> time new test gets added.
>>
>> This v3 series reduces duplicate code to generate script
>> in indiviual test Makefiles and consolidates support in
>> selftests main Makefile. In the main Makefile, it does
>> minimal work to set and export install path. In this
>> series exec and powerpc tests are not included in the
>> install, this work will be done in future patches. exec
>> and powerpc are still run when make kselftest is invoked.
> 
> Any particular reason you excluded the powerpc tests? Going by a quick count,
> powerpc has 32 of the 54 self tests, ie. more than half.

No particular reason other than not having a good way to test the
changes I need to make. It does have sub-directory structure with
multiple makefiles underneath. I would like to work on this after
this patch series gets in or maybe you can help out on powerpc
changes if you like.

> 
> Sorry I didn't get a chance to review v1 or v2, but is this really the best
> solution we can come up with? It seems to involve a lot of boiler plate getting
> repeated in every Makefile.

This approach extends the existing approach to use makefile targets as
a means to support running tests. Also it gives full control to the
individual test developer in making changes to the targets as needed
without conflicts with work that is in progress on other tests.

There isn't a whole lot of boiler plating code repeated as such in
individual makefiles. They all add their specific targets to the
main script.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
