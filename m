Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbaE3Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:32:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaE3Qc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:32:26 -0400
Date: Fri, 30 May 2014 09:36:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530163604.GA11943@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201405301815.10811@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 06:15:09PM +0200, Pali Rohár wrote:
> Hi Greg,
> 
> On Friday 30 May 2014 17:59:59 Greg KH wrote:
> > On Fri, May 30, 2014 at 02:30:23PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > >> Creating this patch for the Eudyptula Challenge.
> > > > >> Replaced msleep() for a delay < 20ms with a
> > > > >> usleep_range() between 10000us and 15000us. Also
> > > > >> inserted a blank line after adeclaration.
> > > > > 
> > > > > So you are changing timings without testing. Plus,
> > > > > burning CPU power instead of sleeping.
> > > > > 
> > > > > Seems you'll need another patch for the challenge :-).
> > > > 
> > > > I actually wonder if anybody is seriously working on this
> > > > driver. My concern with the staging drivers has always
> > > > been that we are quick with merging them when the work on
> > > > getting them into upstream shape is actually hard.
> > > > However reality is once they are in staging nobody is
> > > > doing the work to clean them up and fix the issues.
> > > 
> > > There is active work on merging n900 changes.
> > 
> > Really?  Where?
> > 
> 
> You can look at elinux wiki where is table how process is going:
> http://elinux.org/N900
> 
> Also look at planed future list and its progress:
> http://elinux.org/N900/Changelog
> 
> You can see that drivers are including step by step.

I'm not going to dig through random web pages, sorry.  If patches aren't
sent to me for a driver, I consider it dead, that's only fair for me
given my workload, don't you think?

> > > And no, it does not progress as quickly as I'd like, but
> > > we'll get there. It is also requirement for n900 FM radio
> > > receiving...
> > > 
> > > > Greg, instead of wasting our time with this, can we just
> > > > remove this driver from staging.
> > > 
> > > Please don't.
> > 
> > As there has not been any real work on it since it has been
> > merged, I don't see why I shouldn't remove it.  If you do get
> > some work done on it, you can always revert the removal and
> > continue on.  But the existance of code in staging that is
> > not progressing forward at all is something that I don't like
> > at all, and will be doing a large sweep of soon to remove.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Just look how much time took to include my patch for radio-
> bcm2048 (fm radio part of this chip) which fixing wrong overflow 
> check. I sent it at the end of December and... yes it is still 
> not included in linus tree. Now it is somethere in media tree and 
> probably will be pulled in next merge window.
> 
> This means that it takes about half of year to include patches 
> for these drivers.

Just because the media drivers take a long time to get fixes merged,
don't use that as an excuse to not fix up the staging drivers.

In fact, it sounds like you have lots of time while that patch is
getting merged, why not work on fixing up the staging driver?  :)

> So why now you want to very quickly remove this driver from 
> staging but you did not wanted to take my above patch?

I'm not the maintainer of drivers/staging/media/ and have no insight
into what goes on there at all, nor do I care.  I'm not the one
responsible for taking your patch, so I did not "want" to take your
patch at all.

thanks,

greg k-h
