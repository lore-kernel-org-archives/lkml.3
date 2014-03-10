Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaCJEqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:46:43 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44798 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaCJEqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 9 Mar 2014 21:46:21 -0700
Message-ID: <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 8:18 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> (Of course, I haven't the faintest idea what l_addr in glibc means.
> If there was a way to arrange for l_addr to be zero, then maybe none
> of this would matter.  Hmm, I wonder if just not relocating the vdso
> at all would have the desired effect.  Anyone out there understand
> glibc?)

No, that won't work.  The bug is that glibc expects PT_DYNAMIC's vaddr
to be the virtual address of the dynamic table.  This can only be true
if the vdso is mapped at the address that the kernel relocated it to.

I also learned that glibc's code is really hideous.  Wow.

--Andy
