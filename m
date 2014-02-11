Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBKSen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:34:43 -0500
Received: from oproxy12-pub.mail.unifiedlayer.com ([50.87.16.10]:56573 "HELO
	oproxy12-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752279AbaBKSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:34:42 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 13:34:42 EST
Date: Tue, 11 Feb 2014 10:28:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: Baytrail/T (ASUS T100 etc) regression from 3.13 onwards
Message-ID: <20140211102800.4eae832d@jbarnes-desktop>
In-Reply-To: <20140211181815.GA19306@kroah.com>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
	<20140114120103.436d190b@alan.etchedpixels.co.uk>
	<20140211142203.77561e0f@alan.etchedpixels.co.uk>
	<20140211163541.GB12567@kroah.com>
	<20140211101137.23b2274b@jbarnes-desktop>
	<20140211181815.GA19306@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 10:18:15 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Feb 11, 2014 at 10:11:37AM -0800, Jesse Barnes wrote:
> > On Tue, 11 Feb 2014 08:35:41 -0800
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Tue, Feb 11, 2014 at 02:22:03PM +0000, One Thousand Gnomes wrote:
> > > > On Tue, 14 Jan 2014 12:01:03 +0000
> > > > One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> > > > 
> > > > > On Sun, 12 Jan 2014 20:33:03 +0700
> > > > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > > > 
> > > > > > Another week, another RC. And things look fine.
> > > > > 
> > > > > It seems to hate Baytrail/T
> > > > > 
> > > > > My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> > > > > right but otherwise running nicely and playing 3D games to 3.13-rc8
> > > > 
> > > > This has now been pinned down to (confirmed by multiple people)
> > > > 
> > > > commit 6c4a8962a4a078cacfc8eb5d4bd79f6343b8cd7a
> > > > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > > Date:   Tue Sep 10 14:54:42 2013 -0700
> > > > 
> > > >     drm/i915/vlv: re-enable hotplug detect based probing on VLV/BYT
> > > > 
> > > > 
> > > > which given this is affecting some of the top 10 Amazon selling new
> > > > laptops and has not been fixed for 3.14-rc should IMHO be reverted until
> > > > such time as any needed debugging for the MIPI panels is done for this
> > > > driver and the hotplug probing doesn't break the workarounds.
> > > > 
> > > > Likewise it wants pulling from any -stable backports.
> > > 
> > > I only see it in the 3.13 tree, so when this gets reverted in Linus's
> > > tree, can someone mark it for stable so I know to pick it up for
> > > 3.13-stable as well?
> > 
> > Ugg, so reverting a real fix to make the T100TA work by accident...
> > this is ugly.
> > 
> > According to the reg dumps, this is actually a MIPI panel we're failing
> > to bring up properly.  We're working on that issue, but in the
> > meantime, maybe something like the below would work for you?
> 
> A module paramater to fix a bug?  Ugh, that's almost worse than just
> reverting the original patch, right?
> 
> Please don't do this, the distros will hate you even more than they
> currently do :)

Well reverting the real bug fix to get back to the "this happens to
work but totally by accident" is also pretty bad...

Another option would be to quirk this machine, but that's gross too.
Would be best to just fix the bug for real.

FWIW the kernel bug is here:
https://bugzilla.kernel.org/show_bug.cgi?id=68451

-- 
Jesse Barnes, Intel Open Source Technology Center
