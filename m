Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaL2FAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 00:00:49 -0500
Received: from ozlabs.org ([103.22.144.67]:52153 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaL2FAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 00:00:47 -0500
Message-ID: <1419828790.26911.3.camel@ellerman.id.au>
Subject: Re: [PATCH v3 00/20] kselftest install target feature
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <cover.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Dec 2014 15:53:10 +1100
Mime-Version: 1.0
X-Mailer: Evolution 3.12.7-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 09:27 -0700, Shuah Khan wrote:
> This patch series adds a new kselftest_install make target
> to enable selftest install. When make kselftest_install is
> run, selftests are installed on the system. A new install
> target is added to selftests Makefile which will install
> targets for the tests that are specified in INSTALL_TARGETS.
> During install, a script is generated to run tests that are
> installed. This script will be installed in the selftest install
> directory. Individual test Makefiles are changed to add to the
> script. This will allow new tests to add install and run test
> commands to the generated kselftest script. kselftest target
> now depends on kselftest_install and runs the generated kselftest
> script to reduce duplicate work and for common look and feel when
> running tests.
> 
> This approach leverages and extends the existing framework that
> uses makefile targets to implement run_tests and adds install
> target. This will scale well as new tests get added and makes
> it easier for test writers to add install target at the same
> time new test gets added.
> 
> This v3 series reduces duplicate code to generate script
> in indiviual test Makefiles and consolidates support in
> selftests main Makefile. In the main Makefile, it does
> minimal work to set and export install path. In this
> series exec and powerpc tests are not included in the
> install, this work will be done in future patches. exec
> and powerpc are still run when make kselftest is invoked.

Any particular reason you excluded the powerpc tests? Going by a quick count,
powerpc has 32 of the 54 self tests, ie. more than half.

Sorry I didn't get a chance to review v1 or v2, but is this really the best
solution we can come up with? It seems to involve a lot of boiler plate getting
repeated in every Makefile.

I'm off this week so I can't immediately come up with something better, I'll
try in the new year.

cheers


