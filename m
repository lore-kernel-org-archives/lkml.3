Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598Ab3BTSMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:12:35 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50171 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934530Ab3BTSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:12:31 -0500
Date: Wed, 20 Feb 2013 10:12:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Ross <andy.ross@windriver.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
Message-ID: <20130220181258.GC6679@kroah.com>
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130220014512.GC31018@kroah.com>
 <51244B35.8090006@windriver.com>
 <20130220044506.GA2728@kroah.com>
 <5124FFD7.8070708@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5124FFD7.8070708@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 08:54:47AM -0800, Andy Ross wrote:
> On 02/19/2013 08:45 PM, Greg Kroah-Hartman wrote:
> > On Tue, Feb 19, 2013 at 08:04:05PM -0800, Andy Ross wrote:
> > > There's a (sort of) similar commonly-used option, vga=current, which
> > > prevents a mode switch for the special case of VGA/vesa.  But that
> > > doesn't work with the framebuffer console.
> >
> > Why not?  Can't you fix that?
> 
> I'd argue that's what this is.  If you were going to design a "shut up
> the console" feature from scratch, would you choose to do it in one
> particular display driver or would you do it in the device-independent
> console code by forcing the already-existing "visible" flag to false?

I don't know.  All I do know is that by adding yet-another-userspace
option, we will have to support it for 20+ years.  And I'm _really_
hesitant to do so, especially for a subsystem that, if all goes well, we
will be able to just entirely disable soon.

> > > But the specific application here (Android's surfaceflinger) isn't set
> > > up for that, and it's a non-trivial API (and even doing it "right"
> > > involves racing against other users at startup).
> >
> > How could there be any other users at startup, you "own" the system
> > here, there should not be anyone to race with.
> 
> Tell that to the display hardware. :)

On Android you own that as well, so there this isn't an excuse :)

> Seriously, every Linux box with a display (to first approximation,
> obviously I didn't test them all while writing this message) spits
> something to the screen between the moment where the bootloader hands
> off control and the display driver is initialized.  Most of them
> glitch a little at suspend time because of the console switch there.
> I just reproduced both of these effects with a Fedora 18 live image.

That's Fedora's issue, not Android's.

And it's really a DRM issue, and as mentioned above, one that people are
already working on resolving by just getting rid of this whole layer
entirely.  So adding new options to it are something that I really don't
want to do, especially as we already have working prototypes that don't
have this problem.

> This fixes almost all of that (vga=current is still required because
> some early logging somewhere seems to write to the screen by banging
> registers directly and not using the console), and it does it in a way
> that works without having to modify existing userspace or (try to)
> remove the framebuffer console entirely.

Then fix that early logging code, don't paper over it by doing something
like this please.  Or just remove the framebuffer entirely, it's not
needed, no one will miss it...

thanks,

greg k-h
