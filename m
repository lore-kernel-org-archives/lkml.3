Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaKEJ5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaKEJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:57:14 -0500
Message-ID: <5459F46E.4070802@redhat.com>
Date: Wed, 05 Nov 2014 09:57:02 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Evan Teran <eteran@alum.rit.edu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace/x86: fix the TIF_FORCED_TF logic in handle_signal()
References: <20141103201256.GA5213@redhat.com> <20141103201317.GA5221@redhat.com> <5457F647.7020208@redhat.com> <20141104235505.GA31748@redhat.com>
In-Reply-To: <20141104235505.GA31748@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 11:55 PM, Oleg Nesterov wrote:
> On 11/03, Pedro Alves wrote:
>>
>> Thanks a lot Oleg.
> 
> thanks for the detailed report ;)
> 
>> Question - shouldn't ptrace tests be put in
>> tools/testing/selftests/ptrace/ in the kernel tree nowadays?
> 
> Oh, I do not know. Personally I am not sure that selftests/ptrace/
> makes sense and I did not even know (or forgot) we already have it.

I didn't know about it either until recently.

> To me it would be better to move the single peeksiginfo.c to ptrace
> testsuite and remove this dir.
> 
> That said, I certainly won't argue if you or Jan will maintain
> selftests/ptrace and send the patches with the new test-cases ;)

IMO, having the tests in the kernel tree might make it simpler
to require fixes to come along with tests, so we're better covered
against regressions, but whatever works best to whoever is
maintaining ptrace is good for me.  ;-)

> 
> The only problem is that every new test-case should be justified
> somehow. For example, should we add the test-case from this changelog
> into selftests/ptrace/ ? 

IMO, we should have a ptrace test for this somewhere.  I just don't
know about the intention of selftests/ptrace/, but it looked like
it was meant as a replacement for the out of tree testsuite.
Having the ptrace testsuite in the tree makes sense to me,
for making it easier to require ptrace fixes and extensions to
come along with tests, and to make it easier to catch regressions
closer to the source, and to serve as self-documentation on
expected behavior, but I don't have time to actively pursue
that myself, unfortunately.

> Honestly, I do not know. This bug is minor,
> and probably we do not want a test-case for every bug we fix. 

My view is that there was a bug, and a test case would help
prevent re-introducing it.

> So I'd
> leave this to you, you know how ptrace is actually _used_ and what is
> important for gdb.

Right.  FYI, I've added a testcase to gdb as well, to cover the use
case from a higher level functionality view:

 https://sourceware.org/ml/gdb-patches/2014-10/msg00780.html

(Between a bug/regression being introduced in the kernel and running
the gdb testsuite against that, a lot of time may pass.  Myself,
I usually only test and develop against whatever kernel the
distro ships, which is a released kernel.  And gdb doesn't use
every ptrace feature.)

> 
> The same for other tests in ptrace testsuite. Some of them are really
> "random", in any case (I think) we should not blindly put them all into
> selftests/ptrace. Not to mention the coding style which should be fixed.

Agreed.

> 
> And I know that gdb has a lot of internal tests, and gdb developers
> run them (and ptrace tests) to check the new kernels... Who else do
> you think will use selftests/ptrace?

IMO, whoever touches ptrace code in the kernel should be
required to run the ptrace tests, but not the testsuites of
random other tools that use ptrace (like gdb, strace and others).
Having the ptrace tests in the tree sounded like might make
such a requirement simpler, and I naively thought that the existence
of the directory might mean that that's the direction kernel folks
had agreed on, that's all.

> 
> But again, if you/Jan want to add something into selftests - please
> send a patch. I will even try to review it but only in a sense that
> I will try to convince myself that I understand _what_ this test does,
> not _why_ we need this test-case. You certainly understand "why" much
> better.
> 
> Add Denys, perhaps he also has some tests for strace.

Thanks,
Pedro Alves

