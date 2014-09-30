Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaI3QK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:10:28 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65212 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaI3QK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140930160510.GA15903@redhat.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
Date: Tue, 30 Sep 2014 09:10:26 -0700
X-Google-Sender-Auth: JgacRKZsnYwDnfhtjacdclSDadg
Message-ID: <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 9:05 AM, Dave Jones <davej@redhat.com> wrote:
>
> I left it spinning overnight in case someone wanted me to probe it
> further, so I haven't tried reproducing it yet.  It took ~12 hours
> yesterday before it got in that state.  I'll restart it, and tell it
> to only use pipe fd's, which might speed things up a little.

Actually, if you haven't restarted it yet, do a few more "Sysrq-T"'s
to see if the stack below the page fault ever changes. Is it *always*
that "second access by fault_in_pages_writeable()" or migth there be
some looping going on in copy_page_to_iter() after all? (Quite
frankly, I don't see how such looping could happen with a good
compiler, and 4.8.3 should be good, but just in case).

It's an unlikely scenario, so if you already rebooted, not a big deal.

> model name      : Intel(R) Core(TM) i5-4670T CPU @ 2.30GHz

Ok, that pretty much throws the "maybe AMD did something different"
theory out of the water. Something subtler. Still worth trying the
revert.

            Linus
