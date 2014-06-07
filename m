Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaFGKlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 06:41:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaFGKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 06:41:04 -0400
Date: Sat, 7 Jun 2014 12:41:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Norbert Ciosek <norbertciosek@gmail.com>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
Message-ID: <20140607104102.GB23815@amd.pavel.ucw.cz>
References: <20140603054434.GB2921@kroah.com>
 <CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
 <20140603170244.GA22867@kroah.com>
 <CA+55aFwMEigYZGeF4sFTSpmnvb8YQ3hOndjNrd9ObL2EdOptgQ@mail.gmail.com>
 <20140603182555.GA28541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603182555.GA28541@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Hm, I got two different bug reports, and this same patch from two
> > > different people insisting that we broke their drivers with the above
> > > patches, and asked for this patch to be applied.
> > 
> > So I do think that we might be able to apply this patch, but I think
> > it needs a *lot* more thought than was obviously spent on it so far.
> > 
> > For example, right now it's actively insecure. Do we care? Maybe we
> > don't. The user-space uio side presumably is root-owned, and hopefully
> > trusted.
> 
> It better be trusted, as userspace has access to the "raw" hardware
> here, and is getting notified about every irq that happens to the
> device.

Well, it still depends on what the hardware can do.

Some crazy people (secureboot) want to secure kernel from root user.

If you have "raw" hardware of few keys connected on gpio with an
interrupt (anything without DMA capability, really), you can not
compromise rest of kernel normally.

So, yes, I have seen a lot of hardware where non-root uio would make
sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
