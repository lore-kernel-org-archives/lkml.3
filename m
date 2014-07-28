Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaG1S2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:28:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36346 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaG1S2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140728180902.GA22904@x4>
References: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
	<CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
	<20140726201914.GB21842@x4>
	<CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
	<y0m7g2xk6ss.fsf@fche.csb>
	<CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
	<20140728172737.GA17598@pg-vmw-gw1>
	<20140728180902.GA22904@x4>
Date: Mon, 28 Jul 2014 11:28:37 -0700
X-Google-Sender-Auth: accN6jmr_NPBoGuLhrZfkPk5qDY
Message-ID: <CA+55aFw3eJDJmRJb9pZiLk4wTN1GCRN+BsxOXV+SwqcV1SfQmQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Alexei Starovoitov <ast@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:09 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> It shouldn't be too hard to implement a simple check for the bug in the
> next release. Just compile the gcc/testsuite/gcc.target/i386/pr61801.c
> testcase with -fcompare-debug. If gcc returns 0 then
> -fvar-tracking-assignments could safely be enabled again.

We don't really have any good infrastructure for things like this,
though. We probably *should* have a way to generate config options by
compiler version, but right now we don't. We do random ugly things
from within Makefile shell escapes (see all the helpers for this we do
in scripts/Kbuild.include, for example), and we could add yet another
one. But this is a whole new level of "ugly hack". It would be better
if we could do things like this at config time, not at build-time with
Makefile hacks.

Also, the test-case seems to be very sensitive to compiler options: it
passes with "-O", but fails with "-O2" or "-Os" for me. So I wonder
how reliable it is in the face of compiler version differences (ie is
it really robust wrt the bug actually being *fixed*, or is it a bit of
a happenstance)

          Linus
