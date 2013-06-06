Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3FFLsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:48:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168Ab3FFLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:47:59 -0400
Date: Thu, 6 Jun 2013 13:47:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to
 do_take_over_console
Message-ID: <20130606114746.GA3659@amd.pavel.ucw.cz>
References: <20130521051511.GA11435@udknight>
 <20130604201317.GA16303@amd.pavel.ucw.cz>
 <20130606012312.GA2001@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606012312.GA2001@udknight>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-06-06 09:23:13, Wang YanQing wrote:
> On Tue, Jun 04, 2013 at 10:13:18PM +0200, Pavel Machek wrote:
> > On Tue 2013-05-21 13:15:12, Wang YanQing wrote:
> > > Impact:
> > > 1:convert all remain take_over_console to do_take_over_console
> > 
> > This is step backwards.
> 
> What is step backwards? do_take_over_console appear MUCH MUCH later in kernel
> than take_over_console, do_take_over_console is the new API, I can't understand
> what is step backwards.

"do_*" is internal api, "*" is external api. You sprinkle internal api
all over the place.

> > > --- a/arch/alpha/kernel/console.c
> > > +++ b/arch/alpha/kernel/console.c
> > > @@ -61,7 +61,9 @@ locate_and_init_vga(void *(*sel_func)(void *, void *))
> > >  
> > >  	/* Set the VGA hose and init the new console. */
> > >  	pci_vga_hose = hose;
> > > -	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
> > > +	console_lock();
> > > +	do_take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
> > > +	console_unlock();
> > >  }
> > 
> > Original was better.
> 
> Except reduce some console_lock/unlock scatter scattered in kernel, I 
> can't see the "BETTER", and it is not a BIG problem for the benefit to
> unify the API.

You replaced "calling exported function" with "calling
internal-sounding function and adding locking too".


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
