Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3HYOXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 10:23:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42845 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3HYOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 10:23:14 -0400
Date: Sun, 25 Aug 2013 15:23:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130825142307.GA27005@ZenIV.linux.org.uk>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu>
 <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
 <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
 <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
 <20130823010726.GP27005@ZenIV.linux.org.uk>
 <20130825033741.GX27005@ZenIV.linux.org.uk>
 <CALCETrViJ8i3ty8xAECC0nqRuepVeKsW9r2W51tTCDUuB3V25g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrViJ8i3ty8xAECC0nqRuepVeKsW9r2W51tTCDUuB3V25g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 12:26:34AM -0700, Andy Lutomirski wrote:

> I think this is more screwed up than just flink and open.  For example:
> 
> $ echo 'WTF' >test
> $ truncate -s 1 /proc/self/fd/3 3<test
> $ cat test
> W$
> 
> IMO that should have failed.

Why?  truncate() always follows links, so what's the problem with that
one?  That you get checks of truncate() and not ftruncate()?

> In an ideal world (I think) ffrob(N), frobat(N, "", AT_EMPTY_PATH),
> and frobat(AT_FDCWD, "/proc/self/fd/N) should generally do the same
> thing.

What about the cases where frob() and ffrob() check for different things?
