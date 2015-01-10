Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbbAJWh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:37:59 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44630 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbAJWh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:37:58 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
	<1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
	<CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
	<CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
Date: Sat, 10 Jan 2015 14:37:57 -0800
X-Google-Sender-Auth: 6OcCIF0FJ_3n4SS1gzJ9916mE8c
Message-ID: <CA+55aFwxYpZ2kJrdofYveoi65nhvyHKz+Qwn0O4QQKtvP-V3pQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
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
>
> So the only way to avoid a conflict is to not touch the same code, or
> to touch it *exactly* the same way in all respects.

.. with the caveat that the exact definition of "overlap" can end up
being somewhat fuzzy with the whole conflict simplification, so I
guess it can actually end up helping. But I think it could go either
way. Just from experience, the more important part is seeing that one
branch is obviously a superset of the other, which tends to happen
particularly with the case of "small parts of the new branch were
already merged as bug-fixes during the last development cycle".

                       Linus
