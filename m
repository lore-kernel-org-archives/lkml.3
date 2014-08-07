Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaHGAZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:25:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHGAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:25:33 -0400
Date: Wed, 6 Aug 2014 17:25:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140807002532.GB23406@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806213055.GA26046@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:30:55PM +0200, Pavel Machek wrote:
> On Wed 2014-08-06 13:56:33, Marcel Holtmann wrote:
> > Hi Greg,
> > 
> > >>>>>>> Creating this patch for the Eudyptula Challenge.
> > >>>>>>> Replaced msleep() for a delay < 20ms with a
> > >>>>>>> usleep_range() between 10000us and 15000us. Also
> > >>>>>>> inserted a blank line after adeclaration.
> > >>>>>> 
> > >>>>>> So you are changing timings without testing. Plus,
> > >>>>>> burning CPU power instead of sleeping.
> > >>>>>> 
> > >>>>>> Seems you'll need another patch for the challenge :-).
> > >>>>> 
> > >>>>> I actually wonder if anybody is seriously working on this
> > >>>>> driver. My concern with the staging drivers has always
> > >>>>> been that we are quick with merging them when the work on
> > >>>>> getting them into upstream shape is actually hard.
> > >>>>> However reality is once they are in staging nobody is
> > >>>>> doing the work to clean them up and fix the issues.
> > >>>> 
> > >>>> There is active work on merging n900 changes.
> > >>> 
> > >>> Really?  Where?
> > >>> 
> > >> 
> > >> You can look at elinux wiki where is table how process is going:
> > >> http://elinux.org/N900
> > >> 
> > >> Also look at planed future list and its progress:
> > >> http://elinux.org/N900/Changelog
> > >> 
> > >> You can see that drivers are including step by step.
> > > 
> > > I'm not going to dig through random web pages, sorry.  If patches aren't
> > > sent to me for a driver, I consider it dead, that's only fair for me
> > > given my workload, don't you think?
> > > 
> > >>>> And no, it does not progress as quickly as I'd like, but
> > >>>> we'll get there. It is also requirement for n900 FM radio
> > >>>> receiving...
> > >>>> 
> > >>>>> Greg, instead of wasting our time with this, can we just
> > >>>>> remove this driver from staging.
> > >>>> 
> > >>>> Please don't.
> > >>> 
> > >>> As there has not been any real work on it since it has been
> > >>> merged, I don't see why I shouldn't remove it.  If you do get
> > >>> some work done on it, you can always revert the removal and
> > >>> continue on.  But the existance of code in staging that is
> > >>> not progressing forward at all is something that I don't like
> > >>> at all, and will be doing a large sweep of soon to remove.
> > >>> 
> > >>> thanks,
> > >>> 
> > >>> greg k-h
> > >> 
> > >> Just look how much time took to include my patch for radio-
> > >> bcm2048 (fm radio part of this chip) which fixing wrong overflow 
> > >> check. I sent it at the end of December and... yes it is still 
> > >> not included in linus tree. Now it is somethere in media tree and 
> > >> probably will be pulled in next merge window.
> > >> 
> > >> This means that it takes about half of year to include patches 
> > >> for these drivers.
> > > 
> > > Just because the media drivers take a long time to get fixes merged,
> > > don't use that as an excuse to not fix up the staging drivers.
> > > 
> > > In fact, it sounds like you have lots of time while that patch is
> > > getting merged, why not work on fixing up the staging driver?  :)
> > 
> > and 2 month later, we still have nothing accomplished with this driver.
> > 
> > So this driver is 6 month in staging and not a single commit to address anything in the TODO file. I only see pointless coding style change.
> > 
> > There is a reason why I dislike staging drivers. And this is exactly it. It gets treated as dumping ground. So can we please remove this driver now. Maybe someone finally wakes up and does their promised job.
> >
> 
> Yeah, so I clearly make a mistake of cleaning the driver up _before_
> merging it into staging.

No, the mistake was that you didn't ever follow it up with any real
work, not that it was "cleaned up" at all.

> And yes, I'm currently trying to get 3.16 working in the qemu, which
> is prerequisite for any useful n900 work.

So I guess I'll queue up a patch to delete this for 3.17-rc2.  Pavel, if
you get the device working properly, we can easily revert the deletion
and you can send follow-on patches to fix things up properly.

thanks,

greg k-h
