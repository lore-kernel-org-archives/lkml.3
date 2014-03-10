Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaCJVxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:53:51 -0400
Received: from www84.your-server.de ([213.133.104.84]:50771 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCJVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:53:49 -0400
Date: Mon, 10 Mar 2014 22:53:42 +0100
Message-ID: <20140310225342.Horde.61HLMn9MRz49_0n_vS9HYQ1@webmail.your-server.de>
From: stefani@seibold.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at
 d34bd000
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
 <1394481804.980.9.camel@wall-e.seibold.net>
 <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
 <20140310222528.Horde.tMG70UcHgBuz9DV3W9_aaA1@webmail.your-server.de>
 <CA+55aFygdFWCVzsSNT6v-8Mnsq8rrFwz0d1ydOLRthv4JsBaBQ@mail.gmail.com>
In-Reply-To: <CA+55aFygdFWCVzsSNT6v-8Mnsq8rrFwz0d1ydOLRthv4JsBaBQ@mail.gmail.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.6)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Linus Torvalds <torvalds@linux-foundation.org>:

> On Mon, Mar 10, 2014 at 2:25 PM,  <stefani@seibold.net> wrote:
>>
>> This was discovered by me.
>
> Sorry for the misattribution.
>
>> But this is not a real solution, at least when vcpu function support
>> will be added, then the code size will exceed the page size. Reserving
>> two pages for the VDSO is a good option.
>
> Quite frankly, there is no way in hell I will take a patch like that
> for 3.14 any more, and I would argue against it for stable.
>
> Now, if this problem never happens with current kernels (because it's
> purely due to the patch in -tip), then I don't much care.
>
> That said, I don't understand why we are even adding new features like
> this to 32-bit mode in the first place, so if that patch is the sole
> source of all this headache, then why not just throw the patch away?
>

The patch is working. And for this current issue there is a solution i already
announced.

A dual VDSO: a one page sized VDSO for the compat mode which has only  
the syscall
code and on multi page sized VDSO which is mapped into user space for  
the non compat
mode.

This will work and has no side effects.

- Stefani


