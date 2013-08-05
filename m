Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3HET4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:56:19 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:51671 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3HET4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130805194009.GZ17022@redhat.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	<CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com>
	<CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
	<20130805194009.GZ17022@redhat.com>
Date: Mon, 5 Aug 2013 12:56:17 -0700
X-Google-Sender-Auth: evSCEeHgh-dB0-_Xvp2CkgWRTFM
Message-ID: <CA+55aFwhwh01EYe+LruShXU=hFcMr165KwvnjpjD4Dce2fjz=g@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marek Polacek <polacek@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:40 PM, Marek Polacek <polacek@redhat.com> wrote:
>
> FWIW, we also support hot/cold attributes for labels, thus e.g.
>
>   if (bar ())
>     goto A;
>   /* ... */
> A: __attribute__((cold))
>   /* ... */
>
> I don't know whether that might be useful for what you want or not though...

Steve? That does sound like it might at least re-order the basic
blocks better for your cases. Worth checking out, no?

That said, I don't know what gcc actually does for that case. It may
be that it just ends up trying to transfer that "cold" information to
the conditional itself, which wouldn't work for our asm goto use. I
hope/assume it doesn't do that, though, since the "cold" attribute
would presumably also be useful for things like computed gotos etc -
so it really isn't about the _source_ of the branch, but about that
specific target, and the basic block re-ordering.

Anyway, the exact implementation details may make it more or less
useful for our special static key things. But it does sound like the
right thing to do for static keys.

                Linus
