Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3KREjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:39:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3KREja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:39:30 -0500
Date: Sun, 17 Nov 2013 20:39:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/40] staging/lustre/llite: Access to released file
 trigs a restore
Message-ID: <20131118043942.GB3971@kroah.com>
References: <20131115040944.GA28070@kroah.com>
 <CEAC7771.817BF%andreas.dilger@intel.com>
 <20131116195947.GB9308@kroah.com>
 <CA+a=Yy7LrEREU+9BbDy6cOpEFSdcNoYjsWnhBF1tv-OcHfKMpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy7LrEREU+9BbDy6cOpEFSdcNoYjsWnhBF1tv-OcHfKMpQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:07:12AM +0800, Peng Tao wrote:
> On Sun, Nov 17, 2013 at 3:59 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, Nov 16, 2013 at 10:36:18AM +0000, Dilger, Andreas wrote:
> >> >So, sorry, I have to stop here at this series.  I've applied the first 3
> >> >to the opw-next branch of staging.git so they can live somewhere until
> >> >3.13-rc1 is out.
> >> >
> >> >I know you spent a lot of time making these 120 patches to send me, but
> >> >that too is crazy.  You shouldn't wait that long to get feedback and
> >> >send patches to me at all.  Please send them in smaller series, with
> >> >less time between patch submissions.
> >>
> >> The reason that there are so many patches in a burst is that we are also
> >> developing new features and fixing bugs in parallel with the kernel, but
> >> they also need to be tested a lot before they are released.  It's not any
> >> different from kernel patches testing on -next or -mm for a few months
> >> before they are pushed to the mainline kernel in a batch.
> >
> > It's very different in that you are expecting me to suddenly accept this
> > huge burst of patches all at once, and I can't review them properly.  As
> > this patch series shows, there was a problem in the 4rd patch in a 100+
> > series, which means that I couldn't take them all.  So you wasted a
> > bunch of work preparing those other 96 patches.
> >
> > Send them to me in short chunks, that way you don't waste time, and you
> > don't take so long between patch acceptance.
> >
> working on it. sorry for the noise.
> 
> >> The out-of-tree development can't really stop for a year while the kernel
> >> client code is cleaned up.  If the feature patches don't land into the
> >> kernel client for a year (or however long it takes to do all the cleanup),
> >> then it will become outdated and the whole reason for adding the client
> >> into the kernel is lost.
> >
> > But you understand my hesitation at taking any new features when there
> > really has not been any attempt by your team to do much cleanup and
> > fixes of the code at all, right?  It feels like I have done more cleanup
> > personally than anyone on your teams, is this not true?
> >
> > So, why would I believe that you all are really going to start doing the
> > major cleanup work on this code that is so obviously needed?  Why would
> > I take new features that you are spending your time on instead?
> >
> My apologize. I was distracted by other projects for some time and I
> am trying to make it up. I thought you agreed that I can first close
> the patch gap between in-kernel client and external tree, and then add
> cleanup patches, no?

What exactly is "the gap"?  Are we talking 200 patches?  10?  100?  I
have no idea what you are referring to, but realize I can't review 100
patches at a single time easily.

And what happens when I accep these "gap" patches?  Will development in
this external tree suddenly stop?  It sure doesn't seem like this is
happening as I thought it would have already since the code has been in
the kernel for over 6 months now.

> >> >> There are many users of the external tree so we cannot just abandon
> >> >> it, especially that the upstream client is not shipped in any
> >> >> distribution yet. Thanks for your understanding.
> >> >
> >> >What is keeping people using that tree?  Support for older/distro
> >> >kernels?
> >> >
> >>
> >> Support for distro kernels is a big part of it.  Most HPC sites use vendor
> >> kernels of various vintages, and we need to keep the code working for those
> >> sites.  We also need to continue developing features needed by ever-larger
> >> clusters, fixing bugs, etc.  Eventually, when Lustre is in the kernel
> >> proper,
> >> it will also be available in future distro kernels and we can eventually
> >> stop supporting the out-of-tree code.  I expect that to be 3+ years away.
> >
> > So, originally you said it would take about a year to get this out of
> > staging.  It's been 6 months already with no real progress made with the
> > exception of having interns do cleanup and me doing some basic wrapper
> > function removals.  What's the plan for the next 6 months?  Based on
> > these 100+ patches, I don't see any major changes that are happening to
> > get this cleaned up properly (or did I miss those patches in this huge
> > patchbomb?)
> >
> sorry for sending you these patch bombs. I wanted to first sync with
> external tree because otherwise the gap will be increasingly large and
> eventually we end up with two different code base.

You already have 2 different code bases :(

> >> >Is it the fact that the server code isn't in the kernel?
> >>
> >> Not really.  Lustre servers are on separate servers with vendor kernels
> >> (ancient by your standards), and there isn't really any demand for
> >> using newer kernels on those nodes.  Most importantly, the out-of-tree
> >> branch is where all of the new feature development is being done.  That
> >> also means if feature patches don't land into the kernel it just makes
> >> the kernel version less attractive for users.
> >>
> >> >  Should that be added now too so that we can get a proper view of what
> >> > can and can not be changed?  Some of your patches are showing that things
> >> > are shared by the two chunks of code, so does that mean if I delete
> >> >things in the client code that don't look to be used by anything, you
> >> > will have problems because the server now breaks?
> >>
> >> Adding the server code to staging would mean another 150kLOC in staging.
> >> We also haven't cleaned that code up even nearly as much as the client
> >> code, so it isn't really even ready to go into staging either.  I don't
> >> think you or anyone else would be happy to see that code yet, so I don't
> >> think there is a real advantage to do so.
> >>
> >> Deleting unused code in the kernel client isn't fatal, since we'll
> >> still have the out-of-tree version, but we're trying to keep the code in
> >> sync as much as possible so that it is easier to port patches in both
> >> directions.  If code is deleted it means more that needs to be added
> >> back later when the server eventually does get merged, and more effort
> >> to resolve patch conflicts.
> >
> > But look at the function that caused this original question to be asked.
> > You want an api change that I would never accept as it doesn't do
> > anything to the client code at all.  How do I "know" this is acceptable
> > and needed if I can't see the server side?  How would I "know" not to
> > take a cleanup patch that reverted this change if I can't see the server
> > side at the same time?
> >
> How about CCing Andreas and me for patches changing
> drivers/staging/lustre?

I have been trying to do that, but not all developers follow that.
Also, not all developers in the overall kernel do that either, for good
reasons (i.e. api changes.)

> If such reverting patch appears, we can send NACKs, right?

Not always, no.  Being a maintainer doesn't mean that you have to have
final approval on every change to your codebase, this is a long-time
thing you all should know quite well.

> Andreas reviews most of patches landed in both in kernel client and in
> the external tree. He for sure knows if a cleanup patch drops
> something that server needs. Also I'll try to add comments on things
> that are used only by server but client also needs. Does it sound
> working?

Does the current way of working seem to work for you?

> > 150k of code is not a big deal to me, I can easily take it.  If it means
> > that we have a real chance at getting this all fixed up properly, I say
> > to do it, otherwise I really don't think this project will ever succeed,
> > sorry.
> >
> The issue with server code is that it is not even updated to support
> latest kernel.

Then how are you even testing this stuff?

greg k-h
