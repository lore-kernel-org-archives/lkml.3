Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3GPJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:46:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab3GPJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:46:07 -0400
Date: Tue, 16 Jul 2013 11:46:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
In-Reply-To: <1373960616.2148.34.camel@dabdike>
Message-ID: <alpine.LNX.2.00.1307161124430.29788@pobox.suse.cz>
References: <1373916476.2748.69.camel@dabdike> <20130715214422.GA2478@kroah.com> <1373951852.2148.9.camel@dabdike> <20130716062058.GB19052@kroah.com> <1373960616.2148.34.camel@dabdike>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, James Bottomley wrote:

> > But I need, from the distros, specific examples of what they object to.
> > So far all I've gotten is one security patch (that was needed), and one
> > patch for sysfs that I backported too far in the version numbers (my
> > fault.)
> > 
> > Given the huge number of stable patches over the past few years, only
> > having 2 patches be an issue sounds like things are working well for
> > people here.
> > 
> > If I don't get pushback, with specifics, from the distros, I will not
> > know what to change, so if people can provide me that, it will help out
> > a lot.
> 
> I agree ... I think Jiøí and his Red Hat equivalent need to pipe up and
> give us more examples of the problems they've been having.

I am still continuing with my pushback against the /dev/random revamp that 
happened in -stable; at least in the form it happened. I still strongly 
believe it's something that's not a stable material. But that's happening 
in parallel in a different thread already.

Okay, if you want another example:

	commit a6aa749906b92eaec6ca0469f90f35de26044d90
	Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
	Date:   Thu Dec 20 15:05:14 2012 -0800

	    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists

While this is a correct fix for major kernel release, as it achieves 
correctness by checking SMBIOS version properly and behaving according to 
the spec, it actually causes an userspace ABI regression in some sense, as 
it just changes byte order of /sys/class/dmi/id/product_uuid on certain 
systems.

Which is something I absolutely *do not* expect from a minor release of 
branch which is called "stable".

As has been pointed out in other thread already, this all might be a 
matter of taste; I am just trying to point out where the stable process is 
failing for us.

> > > > I don't like this at all, just for the simple reason that it will push
> > > > the majority of the work of stable kernel development on to the
> > > > subsystem maintainers, who have enough work to do as it is.
> > > 
> > > Well, I think of this as a feature not a bug because it enables scaling,
> > > but we can certainly debate the topic; it's probably one of the more
> > > important things that should be discussed.
> > 
> > How does this scale?  It makes the maintainers do more work, which does
> > not scale at all.
> 
> We obviously have different ideas of what "scaling" means.  Being a
> mathematician I think of a process were you review everything as o(1)
> and where the maintainers review everything as o(n).  Since the number
> of patches (np) tends to grow as the number of maintainers, np/o(n) is
> an approximate constant meaning the amount of work per maintainer
> scales.  np/o(1) grows.

Having a degree from mathematical insitute as well, I agree with James :)


On Mon, 15 Jul 2013, Greg KH wrote:

> I give maintainers 2 different chances to NAK a patch, and if they miss
> those, I can also easily revert a patch that got applied and do a new
> release, which I have done in the past.

This is exactly what I wanted to change with my proposal yesterday -- 
asking for NAKing of something that is already upstream is just "boring" 
and going to be ignored by many people. That's reality, unfortunately. 
It's basically a passive approval scenario.

If you completely push the burden out to maintainers, to have them prepare 
the branch and send it to you for pulling, that requires an *active* 
action from them, which means much more thinking about what code is going 
into the branch.

It could mean that less code will be going to stable, yes. But it will be 
documented *why* it's going there (in the pull request), there will be 
clearly someone responsible for it (the person who conducted the pull 
request) and the changes will have much higher chances to be reviewed in 
terms of applicability to -stable.

Oh, and I need to add: I am not pushing against you personally or the 
stable branch in general, at all. We are heavy users of -stable releases 
of course, and it saves us a lot of work. I am just trying to figure out 
ways how to avoid another lot of extra work on our side when change that 
shouldn't be pulled into stable lands in our tree through it. Once that 
happens, it causes us quite some headache, as we are implicitly relying on 
stable to actually be "stable", in our understanting of the word :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
