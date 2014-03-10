Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCJAQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:16:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:57619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaCJAQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,620,1389772800"; 
   d="scan'208";a="469305142"
Message-ID: <531D044C.2090303@linux.intel.com>
Date: Sun, 09 Mar 2014 17:16:12 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost>	 <1394176888.1018.3.camel@wall-e.seibold.net>	 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>	 <1394229220.20013.13.camel@wall-e.seibold.net>	 <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com> <1394354848.1002.37.camel@wall-e.seibold.net>
In-Reply-To: <1394354848.1002.37.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 12:47 AM, Stefani Seibold wrote:
> 
> But let me ask an other question: Is the compat mode still needed
> anymore?
> 
> Since Lguest, XEN, OPLC and the reservetop kernel parameter will change
> the __FIXADDR_TOP, there is no fix place for the VDSO page. Also in the
> 32 bit emulation layer the address is not fix.
> 
> So all applications can fail when try directly access the VDSO page with
> a hard coded address 0xffffe000.
> 
> IMHO this is broken. So an other solution is to remove the whole VDSO
> compat code.
> 

Lguest, Xen, OLPC and reservetop are corner cases.  My understanding is
that at least one widely used distro actually cared about this, and
Linus especially is adamant that "we don't break userspace."

The dual vdso approach might be the best bet, for the cases where
compatibility is even possible.

	-hpa


