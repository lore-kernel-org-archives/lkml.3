Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab3AQCmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:42:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:43169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab3AQCmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:42:19 -0500
Date: Wed, 16 Jan 2013 18:42:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: sedat.dilek@gmail.com, Jiri Kosina <jkosina@suse.cz>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.8-rc2 lockdep complains about console_lock vs.
 fb_notifier_list.rwsem
Message-ID: <20130117024246.GF20928@kroah.com>
References: <CA+icZUUxgRsGkYAmZ=JxTwPvdhTzpGLcxm6+VSq9jnfYPVXj4Q@mail.gmail.com>
 <s5hpq16zfox.wl%tiwai@suse.de>
 <CA+icZUWFKzccbHrU0pxK-T2TdwyDsTTNxP_22zmGTPbcAmhMaQ@mail.gmail.com>
 <s5hpq1531yn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hpq1531yn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:35:12AM +0100, Takashi Iwai wrote:
> At Wed, 16 Jan 2013 10:21:46 +0100,
> Sedat Dilek wrote:
> > 
> > On Tue, Jan 15, 2013 at 3:25 PM, Takashi Iwai <tiwai@suse.de> wrote:
> > > At Sat, 5 Jan 2013 13:13:27 +0100,
> > > Sedat Dilek wrote:
> > >>
> > >> Hi Jiri,
> > >>
> > >> ...known issue (see thread in [1]), please feel free to test patches
> > >> from Alan and Andrew (see [1], [2] and [3]) and report.
> > >>
> > >> Regards,
> > >> - Sedat -
> > >>
> > >> [1] http://marc.info/?t=135309396400003&r=1&w=2
> > >> [2] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
> > >> [3] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
> > >> [4] http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
> > >
> > > I've hit this bug and tried the patch [2] ([3] and [4] are gone).
> > > Unfortunately the deadlock is still reported, as seen below.
> > >
> > > A similar fix for fbcon_unbind(), splitting an unlocked version of
> > > unbind_con_driver() and call it?
> > >
> > > (BTW, the patch [2] contains strange characters in the comments, and
> > >  has a few coding issues easily detected by checkpatch.pl.)
> > >
> > 
> > [ CCing Rafael as he asked in another thread if I had sent a patch ]
> > 
> > I noticed also some these "strange" chars in the patch from Andrew and
> > a patch of mine was sent as
> > "fb-Rework-locking-to-fix-lock-ordering-on-takeover-fix-comments.patch"
> > to the lists.
> > 
> > It is strange to me that Andrew or other maintainers himself did not
> > check with "checkpatch.pl".
> > This should be a common testcase!
> > Hey, noone is perfect :-).
> > ( /me has also not checked with that script - I just saw it. )
> > 
> > Just as a note to the issue in general:
> > Andrew took over the patch from Alan which is very honest - he is not
> > the active TTY maintainer!
> > Didn't Greg takeover maintenance from Alan (after a dispute and blaming Alan)?
> > If this is true, why the hell is Greg not CCed?
> 
> Let's do it :)
> 
> Greg, Jiri, this bug hits already quite a few people.
> 
> I can reproduce the bug easily on a machine with a radeon graphics.
> It appears always at boot when lockdep is enabled.
> 
> 
> > Thanks for the real patch in the followup of this thread!
> > Who will take care of it :-)?
> 
> Either tty maintainer, or fb maintainer, or Andrew?
> 
> FWIW, Andrew took my patch in mm:
>   http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
>   http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-for-fixing-lockdep-mess.patch


Ok, so, which one should I take for 3.8?  And ideally the fb maintainer
should do this, not I, right?

thanks,

greg k-h
