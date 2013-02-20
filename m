Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500Ab3BTU57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:57:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39434 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3BTU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:57:58 -0500
Date: Wed, 20 Feb 2013 21:57:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andy Ross <andy.ross@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
Message-ID: <20130220205737.GB6597@xo-6d-61-c0.localdomain>
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

Hi!

> > How could there be any other users at startup, you "own" the system
> > here, there should not be anyone to race with.
> 
> Tell that to the display hardware. :)
> 
> Seriously, every Linux box with a display (to first approximation,
> obviously I didn't test them all while writing this message) spits
> something to the screen between the moment where the bootloader hands
> off control and the display driver is initialized.  Most of them
> glitch a little at suspend time because of the console switch there.
> I just reproduced both of these effects with a Fedora 18 live image.
> 
> This fixes almost all of that (vga=current is still required because
> some early logging somewhere seems to write to the screen by banging
> registers directly and not using the console), and it does it in a way
> that works without having to modify existing userspace or (try to)
> remove the framebuffer console entirely.

I'm sure something creative can be done with fake init that shuts the console
up then execs previous init. No need to add more kernel knobs, I'd say.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
