Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaCJRi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:65232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaCJRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:38:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,625,1389772800"; 
   d="scan'208";a="469702762"
Message-ID: <531DF896.8010305@linux.intel.com>
Date: Mon, 10 Mar 2014 10:38:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net> <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com> <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com> <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com> <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com> <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com> <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com> <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com> <531DF549.2090403@linux.intel.com> <CALCETrV+3yCfOCJzRKN-woOyp2RF_=dW1V=9CwpYTUNGAiLoNQ@mail.gmail.com>
In-Reply-To: <CALCETrV+3yCfOCJzRKN-woOyp2RF_=dW1V=9CwpYTUNGAiLoNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:31 AM, Andy Lutomirski wrote:
>>
>>> For 64-bit, this is an entirely different story.  The vsyscall page is
>>> stuck in the fixmap forever, although I want to add a way for
>>> userspace to opt out.  The vvar page, hpet, etc could move into vmas,
>>> though.  I kind of want to do that anyway to allow processes to turn
>>> off the ability to read the clock.
>>
>> Wait... you want to do what?!
> 
> This isn't even my idea:
> 
> commit 8fb402bccf203ecca8f9e0202b8fd3c937dece6f
> Author: Erik Bosman <ebn310@few.vu.nl>
> Date:   Fri Apr 11 18:54:17 2008 +0200
> 
>     generic, x86: add prctl commands PR_GET_TSC and PR_SET_TSC
> 
>     This patch adds prctl commands that make it possible
>     to deny the execution of timestamp counters in userspace.
>     If this is not implemented on a specific architecture,
>     prctl will return -EINVAL.
> 
> Currently anything that tries to use the vdso will just crash if you
> do that, and it fails to turn off direct HPET access.  Fixing this
> might be nice, but the current vvar implementation makes it
> impossible.  If you want to stick something in a seccomp sandbox and
> make it very difficult for it to exploit timing side channels, then
> this is important :)
> 

Yes, we'd have to switch the vdso to using syscall access.  Doing that
from inside a system call is... "interesting".

	-hpa


