Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaKQT7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:59:37 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:59693 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaKQT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:59:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141117170359.GA1382@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141117170359.GA1382@redhat.com>
Date: Mon, 17 Nov 2014 11:59:34 -0800
X-Google-Sender-Auth: 4qogXnN532Ph5Ra8enEWktFsMJ8
Message-ID: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 9:03 AM, Dave Jones <davej@redhat.com> wrote:
>
> It could a completely different cause for lockup, but seeing this now
> has me wondering if perhaps it's something unrelated to the kernel.
> I have recollection of running late .17rc's for days without incident,
> and I'm pretty sure .17 was ok too.  But a few weeks ago I did upgrade
> that test box to the Fedora 21 beta.  Which means I have a new gcc.
> I'm not sure I really trust 4.9.1 yet, so maybe I'll see if I can
> get 4.8 back on there and see if that's any better.

I'm not sure if I should be relieved or horrified.

Horrified, I think.

It really would be a wonderful thing to have some kind of "compiler
bisection" with mixed object files to see exactly which file it
miscompiles (and by "miscompiles" it might just be a kernel bug where
we are missing a barrier or something, and older gcc's just happened
to not show it - so it could still easily be a kernel problem).

                  Linus
