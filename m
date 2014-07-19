Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaGSGUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 02:20:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45057 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbaGSGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 02:20:14 -0400
X-Sasl-enc: Y4rF8pvewkyYXTOzur2lLcnTo+6WFgfVmO3dSkDYCBba 1405750813
Message-ID: <1405750811.5052.2.camel@localhost>
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, price@mit.edu
Date: Sat, 19 Jul 2014 08:20:11 +0200
In-Reply-To: <20140719054258.GH18775@thunk.org>
References: <20140718215054.GD18775@thunk.org>
	 <1405721239-2630-1-git-send-email-tytso@mit.edu>
	 <1405726548.10838.34.camel@localhost> <20140719054258.GH18775@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2014-07-19 at 01:42 -0400, Theodore Ts'o wrote:
> On Sat, Jul 19, 2014 at 01:35:48AM +0200, Hannes Frederic Sowa wrote:
> > > +	nfrac = ibytes << (ENTROPY_SHIFT + 3);
> > > +	if (entropy_count < 0) {
> > 
> > Minor nit: maybe also add an unlikely() here?
> 
> Yep, done.
> 
> > > +	if ((unsigned) entropy_count > nfrac)
> > 
> > (unsigned) -> (size_t)
> >
> > size_t could also be (unsigned long) so the plain (unsigned) is
> > misleading.
> 
> Good point, done.
> 
> > (Maybe I wouldn't have done the cast at all, as we compile the kernel
> > with -Wno-sign-compare and we have the < 0 check right above, but I
> > don't have a strong opinion on that.)
> 
> I also wanted to shut up other static code checkers like Coverity.  :-)
> 
> > > +	nbytes = min_t(size_t, nbytes, INT_MAX >> ENTROPY_SHIFT);
> > 
> > Hmm, not sure, nfracs unit is 1/8 bits, so don't we have to limit nbytes
> > to INT_MAX >> (ENTROPY_SHIFT + 3) here?
> 
> Good catch, done.
> 
> > And if we want to be even more correct here, we could switch from
> > INT_MAX to SIZE_MAX, as we do all nfrac calculations in the size_t
> > domain.
> 
> The main reason why I used INT_MAX was as a further safety check to
> protect the:
> 
> 	entropy_count -= nfrac;
> 
> calculation, since nfrac is size_t and entropy_count is int.
> 
> In fact I think this online change ("nbytes = min_t(size_t, nbytes,
> INT_MAX >> (ENTROPY_SHIFT + 3));") would have been enough to fix the
> problem all by itself, but the other changes results in code which is
> cleaner and easier to understand, and I'm a firm believer in multiple
> layers of protection.  :-)

I see and can agree here. :)

I think the patch is good to go.

Thanks you,
Hannes


