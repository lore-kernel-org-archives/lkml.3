Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaCJUG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:06:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:13399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaCJUGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,625,1389772800"; 
   d="scan'208";a="469768442"
Message-ID: <531E1B53.5090205@linux.intel.com>
Date: Mon, 10 Mar 2014 13:06:43 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost>	 <1394176888.1018.3.camel@wall-e.seibold.net>	 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>	 <1394229220.20013.13.camel@wall-e.seibold.net>	 <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>	 <1394354848.1002.37.camel@wall-e.seibold.net>	 <531D044C.2090303@linux.intel.com>	 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>	 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>	 <531DD35A.5060202@linux.intel.com>	 <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>	 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com> <1394481804.980.9.camel@wall-e.seibold.net>
In-Reply-To: <1394481804.980.9.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 01:03 PM, Stefani Seibold wrote:
> 
> What is now the next step? Kick out the compat VDSO? Or should i
> implement the dual VDSO. And what is now the preferred way to map the
> VDSO into the user space? Using install_special_mapping() or map it
> beyond the user stack?
> 
> The is easiest and fastest way to get a working result is to do the non
> compat VDSO only mapping using install_special_mapping(). The dual VDSO
> would take a little bit more time.
> 
> It would be great to have first a consensus about the design before i
> start to implement ;-)
> 

The quick way to get something working is simply to reserve more than
one page (two should presumably be enough) in the fixmap and adjust the
link address of the VDSO accordingly.  This is not where we want to go
in the long term, but it doesn't seem to make sense to try to do
everything all at once -- we are already starting to push way too close
to the 3.15 merge window.

And special thanks to Andy for doing the archaeology...

	-hpa


