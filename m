Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3BZSWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:22:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35188 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3BZSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:22:35 -0500
Date: Tue, 26 Feb 2013 10:22:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>, Martin Peres <martin.peres@labri.fr>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
Message-ID: <20130226182232.GA21497@kroah.com>
References: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
 <CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
 <20130225223243.GA18744@kroah.com>
 <20130226034545.GA1089@kroah.com>
 <20130226173514.GA24136@kroah.com>
 <CAAMvbhFTNmUS-usRZKBEqp_YrpxDhckj9tdTtC+m_5EnO+UECw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMvbhFTNmUS-usRZKBEqp_YrpxDhckj9tdTtC+m_5EnO+UECw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 06:11:31PM +0000, James Courtier-Dutton wrote:
> On 26 February 2013 17:35, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Feb 25, 2013 at 07:45:45PM -0800, Greg KH wrote:
> >> On Mon, Feb 25, 2013 at 02:32:43PM -0800, Greg KH wrote:
> >> > On Mon, Feb 25, 2013 at 04:06:02PM +1000, Dave Airlie wrote:
> >> > > On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > > > Hi Ben,
> >> > > >
> >> > > > My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
> >> > > > down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
> >> > > > move link training helpers into core as display methods)
> >> > > >
> >> > > > Anything I can try to help solve this?
> >> > > >
> >> > > > Note, I'm using the Intel driver as the main controller for this laptop,
> >> > > > well, I think I am, my xorg log is attached.
> >> > >
> >> > > No you are using the nvidia, the efi always boots nvidia enabled now.
> >> >
> >> > Really?  When did that change?  I thought I wanted to be using the Intel
> >> > chip to save battery life.
> >> >
> >> > > btw I just tested my drm-next tree on mine and it resumed the display
> >> > > fine, something oopsed a few seconds later that I haven't tracked down
> >> > >
> >> > > git://git.freedesktop.org/~airlied/linux drm-next
> >> > >
> >> > > I'll be sending it to Linus this evening or tomorrow morning, once I
> >> > > fix my tree.
> >> >
> >> > Ok, I'll test again when it hits Linus's tree, and if that works, it
> >> > would be good to try to work out what patch fixes it to get them into
> >> > the 3.8-stable series so that others don't run into the same problem.
> >>
> >> I've tested Linus's tree now (I'm guessing it has all of your changes in
> >> it), and it works!
> >>
> >> I see a bunch of patches marked for the stable branch, so I'll try those
> >> out and see if they fix the problem.  If not, I'll let you and Ben know.
> >
> > I've applied the radeon patches tagged for -stable and tested that on
> > 3.8.0, but that doesn't solve the resume problem.  Any ideas of anything
> > else I can do to test this?  Doing a "backwards" git-bisect is a pain,
> > but I guess I can do that to try to track down what patch fixed this, if
> > that's the only idea people have...
> >
> 
> If it helps, I have a similar resume problem here.
> 3.7.8 good
> 3.8.0 bad
> 
> Laptop with no nvidia, no amd graphics, just Intel Graphics 4000, 3rd
> Gen I5 CPU.

But, I'm guessing that if you revert commit
6c5a04249d7afeea3e0ed971e7813f84e29a1706, it doesn't solve your problem,
right?

Can you use 'git bisect' to try to track down the offending commit?

thanks,

greg k-h
