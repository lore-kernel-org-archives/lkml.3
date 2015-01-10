Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbAJX1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 18:27:48 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:56958 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbAJX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 18:27:46 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-3-git-send-email-dvlasenk@redhat.com> <CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
 <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 10 Jan 2015 15:27:24 -0800
Message-ID: <CALCETrX80GF_01EW0azzerFq5gE-6PW6aXauCk3_LagwSy3PSA@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 2:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jan 10, 2015 at 2:13 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I'll make the same change to my pending entry work, and hopefully we
>> can avoid conflicts.
>
> That's not how conflicts work.
>
> Either there is no overlap between the changes at all, in which case
> it doesn't matter if you then also have Denys' changes in your tree.
>
> Or you have other changes that change code around Denys' code, in
> which case you'll get conflicts whether you have Denys' changes or not
> (because two branches will be changing the same area differently, and
> so there's a conflict that needs to resolve which side was right).
>
> So the only way to avoid a conflict is to not touch the same code, or
> to touch it *exactly* the same way in all respects.
>
> Now, while the *conflict* is not something you can't avoid, some
> conflicts are easier to resolve than others, and from a conflict
> resolution standpoint it can make sense for your branch to include
> Denys' changes.

Hmm.  What I meant here about avoiding conflicts was more like "with
any luck, the timing will work out such that the code conflicts don't
end up happening."

>
> Why? Because if whoever resolves the conflict sees that one branch is
> a proper superset of the other branch, than the resolution is a much
> more obvious "let's just take everything from one side" edit, rather
> than having to pick-and-choose.
>
> I I do actually agree with you taking the fixes (and maybe you should
> *entirely* take ownership of all the entry_64.S changes, so that there
> is no "other side" to conflict with at all!). I just wanted to point
> out the actual effects from a conflict standpoint.
>

Egads.  As if the vdso isn't bad enough.

Mumble mumble maybe I'll agree to maintain this masterpiece of
well-engineered asm.

--Andy

>                           Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
