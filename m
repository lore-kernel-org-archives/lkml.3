Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3B0JZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:25:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab3B0JZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:25:38 -0500
Message-ID: <1361957135.3358.0.camel@localhost>
Subject: Re: resume fails to light display on Macbook Pro Retina on 3.8-rc1
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Feb 2013 19:25:35 +1000
In-Reply-To: <20130227040251.GA1081@kroah.com>
References: <CAPM=9txjG5rohsNbme=myrX+-Z5eucpEXYQMWqPQqN=5dNze8g@mail.gmail.com>
	 <CAPM=9tw_vfESbbH4dD9z8mAYVYcwmVs=n4BrRz4XBj1Rw1qrkw@mail.gmail.com>
	 <20130225223243.GA18744@kroah.com> <20130226034545.GA1089@kroah.com>
	 <20130226173514.GA24136@kroah.com> <20130227040251.GA1081@kroah.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 20:02 -0800, Greg KH wrote:
> On Tue, Feb 26, 2013 at 09:35:14AM -0800, Greg KH wrote:
> > On Mon, Feb 25, 2013 at 07:45:45PM -0800, Greg KH wrote:
> > > On Mon, Feb 25, 2013 at 02:32:43PM -0800, Greg KH wrote:
> > > > On Mon, Feb 25, 2013 at 04:06:02PM +1000, Dave Airlie wrote:
> > > > > On Mon, Feb 25, 2013 at 3:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > > Hi Ben,
> > > > > >
> > > > > > My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
> > > > > > down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
> > > > > > move link training helpers into core as display methods)
> > > > > >
> > > > > > Anything I can try to help solve this?
> > > > > >
> > > > > > Note, I'm using the Intel driver as the main controller for this laptop,
> > > > > > well, I think I am, my xorg log is attached.
> > > > > 
> > > > > No you are using the nvidia, the efi always boots nvidia enabled now.
> > > > 
> > > > Really?  When did that change?  I thought I wanted to be using the Intel
> > > > chip to save battery life.
> > > > 
> > > > > btw I just tested my drm-next tree on mine and it resumed the display
> > > > > fine, something oopsed a few seconds later that I haven't tracked down
> > > > > 
> > > > > git://git.freedesktop.org/~airlied/linux drm-next
> > > > > 
> > > > > I'll be sending it to Linus this evening or tomorrow morning, once I
> > > > > fix my tree.
> > > > 
> > > > Ok, I'll test again when it hits Linus's tree, and if that works, it
> > > > would be good to try to work out what patch fixes it to get them into
> > > > the 3.8-stable series so that others don't run into the same problem.
> > > 
> > > I've tested Linus's tree now (I'm guessing it has all of your changes in
> > > it), and it works!
> > > 
> > > I see a bunch of patches marked for the stable branch, so I'll try those
> > > out and see if they fix the problem.  If not, I'll let you and Ben know.
> > 
> > I've applied the radeon patches tagged for -stable and tested that on
> > 3.8.0, but that doesn't solve the resume problem.  Any ideas of anything
> > else I can do to test this?  Doing a "backwards" git-bisect is a pain,
> > but I guess I can do that to try to track down what patch fixed this, if
> > that's the only idea people have...
> 
> Ok, after getting my brain warped by doing a reverse 'git bisect', I
> tracked it down to commit ac8cc241a81941932da44993242e68c62e115ec7
> (drm/nv50/devinit: reverse the logic for running encoder init scripts)
> as the patch that solves the problem.
> 
> So, I tried applying that patch on 3.8.1-rc1, but ran into the efifb bug
> that Dave fixed already, which took me a while, so I've queued that up
> for 3.8.1.  Then I determined that it really also needs commit
> f3ed1048715f2edc10c4dda6148b60e93f6282ed (drm/nouveau/bios: parse
> external transmitter type if off-chip) and commit
> 8e992c8d9eebc2bd3246252ee5c0422dbbbce7ae (drm/nouveau/bios: store a
> type/mask hash in parsed dcb data) in order to build properly.
> 
> With those three patches, plus the efifb fix, I can now properly boot,
> and suspend and resume my macbook on 3.8.1-rc1.  Just like I can on
> Linus's tree.
> 
> So, Ben, Dave, any objection to me including these 3 nouveau patches in
> the 3.8.1-final release?
Thanks for taking the time to track down exactly what's needed here.  I
believe those three should be safe to apply.

Ben.
> 
> thanks,
> 
> greg k-h


