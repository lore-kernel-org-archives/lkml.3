Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaCJV3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:29:10 -0400
Received: from www84.your-server.de ([213.133.104.84]:49340 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCJV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:29:08 -0400
Date: Mon, 10 Mar 2014 22:29:00 +0100
Message-ID: <20140310222900.Horde.v9U-wjSperyf8zRvwBVchw8@webmail.your-server.de>
From: stefani@seibold.net
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <531E1B53.5090205@linux.intel.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.6)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von "H. Peter Anvin" <hpa@linux.intel.com>:

> On 03/10/2014 01:03 PM, Stefani Seibold wrote:
>>
>> What is now the next step? Kick out the compat VDSO? Or should i
>> implement the dual VDSO. And what is now the preferred way to map the
>> VDSO into the user space? Using install_special_mapping() or map it
>> beyond the user stack?
>>
>> The is easiest and fastest way to get a working result is to do the non
>> compat VDSO only mapping using install_special_mapping(). The dual VDSO
>> would take a little bit more time.
>>
>> It would be great to have first a consensus about the design before i
>> start to implement ;-)
>>
>
> The quick way to get something working is simply to reserve more than
> one page (two should presumably be enough) in the fixmap and adjust the
> link address of the VDSO accordingly.  This is not where we want to go
> in the long term, but it doesn't seem to make sense to try to do
> everything all at once -- we are already starting to push way too close
> to the 3.15 merge window.
>

Do you except a complete new patch set or an incremental patch based on the
current patch set?



