Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaKDXyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:54:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKDXyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:54:54 -0500
Date: Wed, 5 Nov 2014 00:55:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Evan Teran <eteran@alum.rit.edu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace/x86: fix the TIF_FORCED_TF logic in
	handle_signal()
Message-ID: <20141104235505.GA31748@redhat.com>
References: <20141103201256.GA5213@redhat.com> <20141103201317.GA5221@redhat.com> <5457F647.7020208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457F647.7020208@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Pedro Alves wrote:
>
> Thanks a lot Oleg.

thanks for the detailed report ;)

> Question - shouldn't ptrace tests be put in
> tools/testing/selftests/ptrace/ in the kernel tree nowadays?

Oh, I do not know. Personally I am not sure that selftests/ptrace/
makes sense and I did not even know (or forgot) we already have it.
To me it would be better to move the single peeksiginfo.c to ptrace
testsuite and remove this dir.

That said, I certainly won't argue if you or Jan will maintain
selftests/ptrace and send the patches with the new test-cases ;)

The only problem is that every new test-case should be justified
somehow. For example, should we add the test-case from this changelog
into selftests/ptrace/ ? Honestly, I do not know. This bug is minor,
and probably we do not want a test-case for every bug we fix. So I'd
leave this to you, you know how ptrace is actually _used_ and what is
important for gdb.

The same for other tests in ptrace testsuite. Some of them are really
"random", in any case (I think) we should not blindly put them all into
selftests/ptrace. Not to mention the coding style which should be fixed.

And I know that gdb has a lot of internal tests, and gdb developers
run them (and ptrace tests) to check the new kernels... Who else do
you think will use selftests/ptrace?

But again, if you/Jan want to add something into selftests - please
send a patch. I will even try to review it but only in a sense that
I will try to convince myself that I understand _what_ this test does,
not _why_ we need this test-case. You certainly understand "why" much
better.

Add Denys, perhaps he also has some tests for strace.

Oleg.

