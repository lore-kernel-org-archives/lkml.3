Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaGLIj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 04:39:28 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:38561 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaGLIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 04:39:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
References: <cover.1405095200.git.luto@amacapital.net> <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
 <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 12 Jul 2014 01:39:01 -0700
Message-ID: <CALCETrUqeUJT7xGy0TERVjJUAZUCXJGdgaDWv-f5+vkkArP8ig@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11, 2014 7:21 PM, "Linus Torvalds" <torvalds@linux-foundation.org> wrote:
>
> On Fri, Jul 11, 2014 at 9:29 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > As far as I can tell, these fields have been set to zero on save and
> > ignored on restore since Linux was imported into git.  Rename them
> > '__pad1' and '__pad2' to avoid confusion and to allow them to be
> > recycled some day.
>
> Shouldn't we actually try to save/restore gs/fs properly? Admittedly,
> changing them in the signal handler would be insane, but still.. See
> our context switching code  with the whole segment selector vs base
> save/restore code. Hmm?

This seems like it's asking for trouble.  I think wxe'd have to
separately save the selectors and the base registers to avoid breaking
something, especially once wrgsbase, etc are enabled.

Why would this be needed anyway?

Does anyone implement makecontext, etc using raise/sigreturn?  If so,
they might be in for a surprise when their gs starts getting saved,
too.

Linus, for context, the other patch in this series saves and restores
SS.  Without that, 64-bit sigreturn to a nondefault stack segment is
basically impossible.  But I don't see why any other segments (besides
CS) are needed for 64-bit sigreturn.

--Andy

>
>             Linus
