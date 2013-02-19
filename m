Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3BSTvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:51:00 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39288 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab3BSTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130219184212.GA18831@phenom.dumpdata.com>
References: <20130219184212.GA18831@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Feb 2013 11:50:37 -0800
X-Google-Sender-Auth: 7W6i6uEtc4kShKIsX4nVdZQXhdI
Message-ID: <CA+55aFyJwu3RS=7UJFZ0wC4A8JBE6SQdUnYHksPHSnhQdD0Z=g@mail.gmail.com>
Subject: Re: Question about git branches, features, reverts, etc on subsystem
 maintainers tree?
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:42 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> To give you a 3.9 branch I am thinking to either:
>
>  a). revert the merges I've for this new feature altogether and
>      merge it later in v3.10 time-frame. They make about 50% off the
>      code in this branch, so its big chunk of code movement.
>      For 3.10 I could do a git revert of a revert and get everything
>      in at once :-)

Never revert a merge. It just results in total mess. It's "possible"
to do as a "patch that undoes the changes that the merge brought in",
but being possible doesn't make it sensible.

Reverting every commit that the merge brought in is also usually just
a f*cking mess. Unless the merge just merged a single commit (but even
then it's just not pretty).

>  b). create a new branch for you without the new features and
>      just live with the shame of having the timestamp of patches
>      being after the merge window.

For this situation, I don't think we have much choice, so (b) it is.

In general, please don't merge unfinished stuff into your main branch
at all to begin with, so that things like this don't happen. There's a
reason git people talk about "feature branches".

>  c). Rip out the Kconfig entry so there is not even an build option
>      to build it. And then if the Xen hypervisor parts are bakend,
>      add the Kconfig entry back and only deal with bug-fixes.
>      A bit like adding #ifdef 0 .

I don't like pulling stuff during the merge that is known broken. It
also makes bisection a total pain in the ass, because the bisection
will find the commit that enables the code, not the actual problematic
code. So "hide from the build" is a real problem, and should basically
never be the answer.

                   Linus
