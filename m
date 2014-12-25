Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLYJXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:23:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55321 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaLYJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:23:16 -0500
Date: Thu, 25 Dec 2014 10:23:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>, secure@intel.com
Cc: luto@amacapital.net, Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141225092314.GA20822@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224234144.GA19262@amd>
 <CAE2SPAa-tBFk0gnOhEZiriQA7bv6MmL9HGqAMSceUKKqujBDPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2SPAa-tBFk0gnOhEZiriQA7bv6MmL9HGqAMSceUKKqujBDPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-12-25 09:26:41, Bastien ROUCARIES wrote:
> Le 25 déc. 2014 00:42, "Pavel Machek" <pavel@ucw.cz> a écrit :
> >
> > Hi!
> > >
> > > Try this test program: https://github.com/mseaborn/rowhammer-test
> > >
> > > It has reproduced bit flips on various machines.
> > >
> > > Your program won't be an effective test because you're just hammering
> > > addresses x and x+64, which will typically be in the same row of DRAM.
> > >
> > > For the test to be effective, you have to pick addresses that are in
> > > different rows but in the same bank.  A good way of doing that is just
> to
> > > pick random pairs of addresses (as the test program above does).  If the
> > > machine has 16 banks of DRAM (as many of the machines I've tested on
> do),
> > > there will be a 1/16 chance that the two addresses are in the same
> > > bank.
> >
> > Ok. Row size is something like 8MB, right?
> >
> > So we have a program that corrupts basically random memory on many
> > machines. That is not good. That means that unpriviledged user can
> > crash processes of other users.
> >
> > I relies on hammering DRAM rows so fast that refresh is unable to keep
> > data consistent in adjacent rows. It relies on clflush: without that,
> > it would likely not be possible to force fast enough row switches.
> >
> > Unfortunately, clflush is not a priviledged instruction. Bad Intel.
> >
> 
> Ask a microcode update asking clflush to be penalized in userspace.

Indeed. Optionally making clflush priviledged intstruction, or
artifically make that instruction slower could do the trick.

Alternatively, lowering memory refresh intervals would reliably do the
same, but with bigger overhead. I guess documenting that controls for
common chipsets would do the trick, so kernel can adjust values before
starting userspace.

Thanks,
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
