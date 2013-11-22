Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3KVARR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:17:17 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51475 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3KVARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:17:13 -0500
MIME-Version: 1.0
In-Reply-To: <528E94E2.3080102@ahsoftware.de>
References: <52803E5D.3050109@mentor.com>
	<52851395.3010306@mentor.com>
	<67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
	<CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
	<528E2E8E.8080004@ahsoftware.de>
	<CA+55aFyNZun07BLoD2KQFT7cN1xsiQ2gE6hYwRvOGa3tCap4CQ@mail.gmail.com>
	<528E94E2.3080102@ahsoftware.de>
Date: Thu, 21 Nov 2013 16:17:12 -0800
X-Google-Sender-Auth: rA6Pwuaw8lgy-2C1FBXwFgiF_gY
Message-ID: <CA+55aFx2BTQLFLU0BdXrzYR55SZT_UZ4BjbYoMUZ8bt-p1XENg@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Lozano <llozano@chromium.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 3:18 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>
> Sorry, that I still disagree.

Why? You're wrong.

I mean, anybody who disagrees with me is pretty much wrong just on
pure principles, but I actually mean a deeper kind of wrong than that.
I mean a very objective "you're clearly wrong".

> I try to describe it more clearly why I still think that the problem might
> be because of that const declaration.

.. and then you use a totally bogus example to try to "prove" your point.

The example you use has nothing to do with what the function in case
actually does.

The function we actually talk about RETURNS THE SAME VALUE EVERY TIME
IT IS CALLED, regardless of arguments (which it doesn't happen to
have). Ergo, it is "const".

Your example is pure and utter shit, since you still get confused
about what is actually const and what isn't.

The fact is, "current_thread_info()" returns a constant value (within
that execution context). Always has, always will. It fundamentally HAS
to, since that is - by definition - what that "thread info" is all
about.

The dereference (your "->somewhere_local") happens *outside* that
const function scope. And no, that dereference is not const. But
that's not what we tell gcc, and never has been.

So don't try to confuse things by trying to make
"current_thread_info()" something it isn't.

Basically, your whole argument boils down to "if the function did
something else than what it does, then it wouldn't be const, so we
shouldn't mark it const". But that argument is BULLSHIT, because the
fact is, the function *doesn't* do what you try to claim it does.

               Linus
