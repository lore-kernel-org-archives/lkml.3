Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaCJRsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:48:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:36895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaCJRse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,625,1389772800"; 
   d="scan'208";a="469708004"
Message-ID: <531DFAF0.9070806@linux.intel.com>
Date: Mon, 10 Mar 2014 10:48:32 -0700
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
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net> <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com> <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com> <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com> <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com> <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com> <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com> <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com> <531DF549.2090403@linux.intel.com> <CALCETrV+3yCfOCJzRKN-woOyp2RF_=dW1V=9CwpYTUNGAiLoNQ@mail.gmail.com> <531DF896.8010305@linux.intel.com> <CALCETrVKfBpVHZcyccWRYM4rdOAETSQsxjiQuxn+0AeX78XiEw@mail.gmail.com>
In-Reply-To: <CALCETrVKfBpVHZcyccWRYM4rdOAETSQsxjiQuxn+0AeX78XiEw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:46 AM, Andy Lutomirski wrote:
>>
>> Yes, we'd have to switch the vdso to using syscall access.  Doing that
>> from inside a system call is... "interesting".
> 
> It's a little less interesting if it just involves changing a vma.
> It's still tricky, though -- would each struct mm have its own struct
> file for the vvar page?  Can this be done with some
> vm_operations_struct magic?  There are possible races, too, though --
> another thread could access the thing concurrently with a syscall.
> 

Hint: where is your RIP?  Where is the RIP of other processes?

	-hpa

