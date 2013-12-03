Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3LCXHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:07:43 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54932 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab3LCXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:07:10 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: [PATCH v2 0/2] test modules
Date: Tue,  3 Dec 2013 15:06:25 -0800
Message-Id: <1386111987-13073-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pair of test modules I'd like to see in the tree. Instead
of putting these in lkdtm, where I've been adding various tests that
trigger crashes, these don't make sense there since they need to be
either distinctly separate, or their pass/fail state don't need to crash
the machine.

These live in lib/ for now, along with a few other in-kernel test modules,
and use the slightly more common "test_" naming convention, instead of
"test-". We should likely standardize on the former:

$ find . -name 'test_*.c' | grep -v /tools/ | wc -l
4
$ find . -name 'test-*.c' | grep -v /tools/ | wc -l
2

The first is entirely a no-op module, designed to allow simple testing
of the module loading and verification interface. It's useful to have
a module that has no other uses or dependencies so it can be reliably
used for just testing module loading and verification.

The second is a module that exercises the user memory access functions,
in an effort to make sure that we can quickly catch any regressions in
boundary checking (e.g. like what was recently fixed on ARM).

Thanks,

-Kees

