Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaCJPBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:01:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:52712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbaCJPBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,624,1389772800"; 
   d="scan'208";a="469610586"
Message-ID: <531DD35A.5060202@linux.intel.com>
Date: Mon, 10 Mar 2014 07:59:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net> <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com> <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com> <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com> <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com> <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
In-Reply-To: <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 09:46 PM, Andy Lutomirski wrote:
> On Sun, Mar 9, 2014 at 8:18 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> (Of course, I haven't the faintest idea what l_addr in glibc means.
>> If there was a way to arrange for l_addr to be zero, then maybe none
>> of this would matter.  Hmm, I wonder if just not relocating the vdso
>> at all would have the desired effect.  Anyone out there understand
>> glibc?)
> 
> No, that won't work.  The bug is that glibc expects PT_DYNAMIC's vaddr
> to be the virtual address of the dynamic table.  This can only be true
> if the vdso is mapped at the address that the kernel relocated it to.
> 
> I also learned that glibc's code is really hideous.  Wow.
> 

At the same time it does mean we have more flexibility than having a
hard-coded address... we can at least allocate more than one page in the
fixmap; for a really "full service" solution the kernel could adjust the
vdso for whatever address the "fixmap" is at.

I have mentioned in the past wanting to move the fixmap to the low part
of the kernel space, because the top isn't really fixed...

	-hpa


