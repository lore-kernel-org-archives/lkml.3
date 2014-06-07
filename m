Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaFGKmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 06:42:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47503 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaFGKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 06:42:34 -0400
Date: Sat, 7 Jun 2014 12:42:32 +0200
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
Message-ID: <20140607104232.GC23815@amd.pavel.ucw.cz>
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

On Tue 2014-06-03 11:25:55, Greg KH wrote:
> On Tue, Jun 03, 2014 at 10:14:41AM -0700, Linus Torvalds wrote:
> > On Tue, Jun 3, 2014 at 10:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
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

At the very least, we have (CAP_SYS_ADMIN?) should be required before
allowing root to compromise kernel, no?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
