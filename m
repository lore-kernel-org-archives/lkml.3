Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaCJUDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:03:37 -0400
Received: from www84.your-server.de ([213.133.104.84]:43615 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaCJUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:03:35 -0400
Message-ID: <1394481804.980.9.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Date: Mon, 10 Mar 2014 21:03:24 +0100
In-Reply-To: <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
References: <20140307013833.GD8427@localhost>
	 <1394176888.1018.3.camel@wall-e.seibold.net>
	 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
	 <1394229220.20013.13.camel@wall-e.seibold.net>
	 <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
	 <1394354848.1002.37.camel@wall-e.seibold.net>
	 <531D044C.2090303@linux.intel.com>
	 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
	 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
	 <531DD35A.5060202@linux.intel.com>
	 <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
	 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 10.03.2014, 10:12 -0700 schrieb Andy Lutomirski:
> On Mon, Mar 10, 2014 at 8:11 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Mar 10, 2014 8:01 AM, "H. Peter Anvin" <hpa@linux.intel.com> wrote:
> >>
> >> I have mentioned in the past wanting to move the fixmap to the low part
> >> of the kernel space, because the top isn't really fixed...
> >
> > How about the high part of the user address space, just above the stack?
> > Leave a unmapped page in between, or something. The stack is already
> > randomized, isn't it?
> 
> For the !compat_vdso case, I don't like it -- this will put the vdso
> (which is executable) at a constant offset from the stack, which will
> make it much easier to use the vdso to defeat ASLR.
> 
> For the compat_vdso case, this only works if the address is *not*
> random, unless we're going to start giving each process its very own
> relocated vdso.
> 
> >
> > That would actually be preferable in a few ways, notably not having to mark
> > page directories user accessible in the kennel space area.
> 
> Is that where the rabid pte dogs live?
> 
> We can already avoid making fixmap pages user-accessible in the
> !compat_vdso case for 32-bit tasks -- the vdso lives in a couple of
> more-or-less ordinary vmas.
> 

What is now the next step? Kick out the compat VDSO? Or should i
implement the dual VDSO. And what is now the preferred way to map the
VDSO into the user space? Using install_special_mapping() or map it
beyond the user stack?

The is easiest and fastest way to get a working result is to do the non
compat VDSO only mapping using install_special_mapping(). The dual VDSO
would take a little bit more time.

It would be great to have first a consensus about the design before i
start to implement ;-)

- Stefani

