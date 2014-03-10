Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaCJVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaCJVvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:51:42 -0400
Date: Mon, 10 Mar 2014 17:51:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at
 d34bd000
Message-ID: <20140310215111.GA27749@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Stefani Seibold <stefani@seibold.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
	Martin Runge <Martin.Runge@rohde-schwarz.com>
References: <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com>
 <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <1394481804.980.9.camel@wall-e.seibold.net>
 <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
 <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 02:20:34PM -0700, Linus Torvalds wrote:

 > I also suspect we should get rid of CONFIG_X86_OOSTORE, or at least
 > limit it to !SMP - I don't think anybody ever made SMP systems with
 > those IDT/Centaur Winchip chips in them.

Given the number of people who ever used that code when it was new could
probably be counted on a couple hands, I'd be amazed if a) anyone was still
using it, and b) that it hasn't regressed in some way in the last 15 years.

Even when it worked, it was only a small performance increase anyway,
and anyone who notices a circa 1998 CPU is now slightly slower on benchmarks
in 2014 probably needs psychiatric help.

I'd say rip it out completely.

	Dave

