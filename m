Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3GPXPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:15:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3GPXPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:15:40 -0400
Date: Wed, 17 Jul 2013 01:15:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
In-Reply-To: <20130716163528.GA17231@kroah.com>
Message-ID: <alpine.LNX.2.00.1307170109330.27351@pobox.suse.cz>
References: <1373916476.2748.69.camel@dabdike> <20130715214422.GA2478@kroah.com> <1373951852.2148.9.camel@dabdike> <20130716062058.GB19052@kroah.com> <1373960616.2148.34.camel@dabdike> <alpine.LNX.2.00.1307161124430.29788@pobox.suse.cz>
 <20130716163528.GA17231@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Greg KH wrote:

> > > > But I need, from the distros, specific examples of what they object to.
> > > > So far all I've gotten is one security patch (that was needed), and one
> > > > patch for sysfs that I backported too far in the version numbers (my
> > > > fault.)
> > > > 
> > > > Given the huge number of stable patches over the past few years, only
> > > > having 2 patches be an issue sounds like things are working well for
> > > > people here.
> > > > 
> > > > If I don't get pushback, with specifics, from the distros, I will not
> > > > know what to change, so if people can provide me that, it will help out
> > > > a lot.
> > > 
> > > I agree ... I think Ji?? and his Red Hat equivalent need to pipe up and
> > > give us more examples of the problems they've been having.
> > 
> > I am still continuing with my pushback against the /dev/random revamp that 
> > happened in -stable; at least in the form it happened. I still strongly 
> > believe it's something that's not a stable material. But that's happening 
> > in parallel in a different thread already.
> > 
> > Okay, if you want another example:
> > 
> > 	commit a6aa749906b92eaec6ca0469f90f35de26044d90
> > 	Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > 	Date:   Thu Dec 20 15:05:14 2012 -0800
> > 
> > 	    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
> > 
> > While this is a correct fix for major kernel release, as it achieves 
> > correctness by checking SMBIOS version properly and behaving according to 
> > the spec, it actually causes an userspace ABI regression in some sense, as 
> > it just changes byte order of /sys/class/dmi/id/product_uuid on certain 
> > systems.
> > 
> > Which is something I absolutely *do not* expect from a minor release of 
> > branch which is called "stable".
> 
> As you pointed out, your definition of "stable" is one that the
> enterprise distros have created, and might be totally different from my
> view of what "stable" is :)

Absolutely, this is why I think discussing this would be very healthy.

- first to clarify what the consumers of your branch are expecting it to 
  be
- then making clear what your understanding of "stable" is
- then clarifying whether the stable branch is there for you or for its 
  consumers :)
- finally finding some intersection (some time in the future :) ) that'll 
  suit all parties

> And also, as Ben pointed out, this was probably wrong, and someone
> should have told me about this, so I could have reverted it.  Please do
> so the next time.

I thought that one of your golas was to improve scalability.

"Everyone is reviewing everything" is not my understanding of scalability; 
hence my proposals.

Thanks, Greg.

-- 
Jiri Kosina
SUSE Labs
