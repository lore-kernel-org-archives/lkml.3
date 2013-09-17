Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3IQUSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:18:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab3IQUSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:18:38 -0400
Date: Tue, 17 Sep 2013 16:18:23 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com
Subject: Re: staging: Add dm-writeboost
Message-ID: <20130917201822.GA12001@redhat.com>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384DEE.7050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52384DEE.7050003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17 2013 at  8:41am -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Mike,
> 
> First, thank you for your commenting.
> I was looking forward to your comments.
> 
> 
> I suppose you are sensing some "smell" in my design.
> You are worrying that dm-writeboost will not only confuse users
> but also fall into worst situation of giving up backward-compatibility
> after merging into tree.
> 
> That dm-writeboost's design is too eccentric as a DM target makes you so.
> 
> That you said
> >   determines whether a device needs formatting, etc.  Otherwise I cannot
> >   see how you can properly stack DM devices on writeboost devices
> >   (suspend+resume become tediously different)
> is a proof of smell.
> 
> Alasdair also said
> > I read a statement like that as an indication of an interface or
> > architectural problem.  The device-mapper approach is to 'design out'
> > problems, rather than relying on users not doing bad things.
> > Study the existing interfaces used by other targets to understand
> > some approaches that proved successful, then decide which ones
> > come closest to your needs.
> 
> and
> 
> Mikulas said
> > Another idea:
> > 
> > Make the interface of dm-lc (the arguments to constructor, messages and 
> > the status line) the same as dm-cache, so that they can be driven by the 
> > same userspace code.
> Though I guess this is going too far
> since dm-writeboost and dm-cache are the different things
> designing them similar definitely makes sense.
> 
> are also sensing of smell.
> 
> 
> I am afraid so I am and
> I am thinking of re-designing dm-writeboost
> at the fundamental architectural level.
> The interfaces will be similar to that of dm-cache as a result.
> 
> This will be a really a BIG change.
> 
> > Probably best for you to publish the dm-writeboost code a git repo on
> > github.com or the like.  I just don't see what benefit there is to
> > putting code like this in staging.  Users already need considerable
> > userspace tools and infrastructure will also be changing in the
> > near-term (e.g. the migration daemon).
> Yes, I agree with that regarding the current implementation.
> I withdraw from the proposal for staging.
> I am really sorry for Greg and others caring about dm-writeboost.
> But I will be back after re-designing.

OK, appreciate your willingness to rework this.  

> staging means lot to get 3rd party users is for sure.

We don't need to go through staging.  If the dm-writeboost target is
designed well and provides a tangible benefit it doesn't need
wide-spread users as justification for going in.  The users will come if
it is implemented well.

> Simplify the design and
> make it more possible to maintain the target
> for the future is what I fully agree with.
> Being adhere to cache-sharing by
> risking the future maintainability doesn't pay.
> Re-designing the dm-writeboost resemble to dm-cache
> is a leading candidate of course.

Simplifying the code is certainly desirable.  So dropping the sharing
sounds like a step in the right direction.  Plus you can share the cache
by layering multiple linear devices ontop of the dm-writeboost device.

Also managing dm-writeboost devices with lvm2 is a priority, so any
interface similarities dm-writeboost has with dm-cache will be
beneficial.

Mike
