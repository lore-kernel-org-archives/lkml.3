Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3HETlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab3HETlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:41:23 -0400
Date: Mon, 5 Aug 2013 21:40:10 +0200
From: Marek Polacek <polacek@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130805194009.GZ17022@redhat.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
 <1375725328.22073.101.camel@gandalf.local.home>
 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
 <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com>
 <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:34:55AM -0700, Linus Torvalds wrote:
> On Mon, Aug 5, 2013 at 11:24 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ugh. I can see the attraction of your section thing for that case, I
> > just get the feeling that we should be able to do better somehow.
> 
> Hmm.. Quite frankly, Steven, for your use case I think you actually
> want the C goto *labels* associated with a section. Which sounds like
> it might be a cleaner syntax than making it about the basic block
> anyway.

FWIW, we also support hot/cold attributes for labels, thus e.g.

  if (bar ()) 
    goto A;
  /* ... */
A: __attribute__((cold))
  /* ... */

I don't know whether that might be useful for what you want or not though...

	Marek
