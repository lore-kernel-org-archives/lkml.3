Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaCJXE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:04:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:27698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbaCJXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:04:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,627,1389772800"; 
   d="scan'208";a="489408106"
Message-ID: <531E4488.2000400@linux.intel.com>
Date: Mon, 10 Mar 2014 16:02:32 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost>	<1394176888.1018.3.camel@wall-e.seibold.net>	<CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>	<1394229220.20013.13.camel@wall-e.seibold.net>	<CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>	<1394354848.1002.37.camel@wall-e.seibold.net>	<531D044C.2090303@linux.intel.com>	<CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>	<CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>	<531DD35A.5060202@linux.intel.com>	<CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>	<CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>	<1394481804.980.9.camel@wall-e.seibold.net>	<531E1B53.5090205@linux.intel.com>	<CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>	<20140310222528.Horde.tMG70UcHgBuz9DV3W9_aaA1@webmail.your-server.de> <CA+55aFygdFWCVzsSNT6v-8Mnsq8rrFwz0d1ydOLRthv4JsBaBQ@mail.gmail.com>
In-Reply-To: <CA+55aFygdFWCVzsSNT6v-8Mnsq8rrFwz0d1ydOLRthv4JsBaBQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 02:39 PM, Linus Torvalds wrote:
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

It is only for tip:x86/vdso, so current kernels don't matter.

There is going to be 32-bit use in the embedded sector for a long time
to come, I suspect/fear, so I'm not opposed to giving it a bit of a
performance boost as long as it isn't too invasive.

I think Andy's commentary applies, though :)

> IMO this is dumb.  I can think of two sensible solutions:
> 
> 1. Get rid of compat vdso and replace it with no vdso at all.  This is
> compatible with everything and requires almost no code 
> 
> 2. Fix compat vdso.  Give it as much space as needed, make the address
> dynamic, and relocate it to the right place.


	-hpa

