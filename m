Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaJKSZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:25:50 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57261 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaJKSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:25:49 -0400
Date: Sat, 11 Oct 2014 23:55:10 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Raymond Yau <superquad.vortex2@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 2/2] ALSA: au88x0: pr_* replaced with
 dev_*
Message-ID: <20141011182510.GA1917@fool>
References: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1412930199-24797-2-git-send-email-sudipm.mukherjee@gmail.com>
 <CAN8ccibSw_85wdnxbNSKfjXQ-7Lg3C6_5fhKQJJi5xMi8pMabA@mail.gmail.com>
 <20141011090903.GC8231@sudip-PC>
 <1413024491.16385.10.camel@joe-AO725>
 <20141011113349.GA9962@sudip-PC>
 <1413041569.16385.20.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413041569.16385.20.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 08:32:49AM -0700, Joe Perches wrote:
> On Sat, 2014-10-11 at 17:03 +0530, Sudip Mukherjee wrote:
> > On Sat, Oct 11, 2014 at 03:48:11AM -0700, Joe Perches wrote:
> > > On Sat, 2014-10-11 at 14:39 +0530, Sudip Mukherjee wrote:
> > > > On Sat, Oct 11, 2014 at 03:20:56PM +0800, Raymond Yau wrote:
> > > > > >
> > <snip>
> > > > > > ---
> > > > > >
> > > > > 
> > > > > >  static int vortex_core_init(vortex_t *vortex)
> > > > > >  {
> > > > > >
> > > > > > -       pr_info( "Vortex: init.... ");
> > > > > > +       dev_info(vortex->card->dev, "init.... ");
> > > > > 
> > > > > Is it possible to add linefeed  since "done/n" won't appear in the same
> > > > > line with init nor shutdown?
> > > > > 
> > > > should we add linefeed ?
> > > > as of now it will print init.... then it will print done as the init is complete.
> > > > so dmesg will show us:
> > > > 
> > > > init....done.
> > > > 
> > > > same for shutdown.
> > > > but if we give linefeed , then it will become : 
> > > > 
> > > > init....
> > > > done.
> > > > 
> > > > the meaning will be lost. and many user might just wonder what is done ? 
> > > []
> > > > > > @@ -2738,7 +2744,7 @@ static int vortex_core_init(vortex_t *vortex)
> > > > > >  static int vortex_core_shutdown(vortex_t * vortex)
> > > > > >  {
> > > > > >
> > > > > > -       pr_info( "Vortex: shutdown...");
> > > > > > +       dev_info(vortex->card->dev, "shutdown...");
> > > > > >  #ifndef CHIP_AU8820
> > > > > >         vortex_eq_free(vortex);
> > > > > >         vortex_Vort3D_disable(vortex);
> > > > > > @@ -2760,7 +2766,7 @@ static int vortex_core_shutdown(vortex_t * vortex)
> > > > > >         msleep(5);
> > > > > >         hwwrite(vortex->mmio, VORTEX_IRQ_SOURCE, 0xffff);
> > > > > >
> > > > > > -       pr_info( "done.\n");
> > > > > > +       dev_info(vortex->card->dev, "done.\n");
> > > > > >         return 0;
> > > > > >  }
> > > 
> > > It's actually on 2 lines before your patch.
> > > 
> > > 	pr_info("a");
> > > 	pr_info("b\n");
> > > 
> > > already emits 2 separate lines.
> > > 
> > > 	pr_info("a");
> > > 	pr_cont("b\n");
> > > 
> > > emits a single line "ab"
> > > (unless some other thread emits something in-between)
> > > 
> > > pr_cont or a bare printk can be used after a dev_info
> > > without a newline to avoid unwanted newlines.
> > 
> > i think i was not thinking while writing the previous mail.
> 
> It seems you were thinking then and now,
> but unfortunately, you are assuming a bit
> more than you have actual experience or
> knowledge of printk inner workings.
>  
> > pr_info("a");
> > pr_info("b\n");
> > should print as "ab" ,
>  
> This is not true.
> 
> All pr_<level> uses but pr_cont always
> start on a new line by emitting a newline
> if the last line did not have one.
> 

oops... i have never tried with pr_* without a \n. I was thinking it will
work like printf. sorry for the noise i created.
and thanks for the information about those 2 commits.
so, now in this case what will you suggest - shutdown and done both
terminated by \n or some thing like : "shutdown process started" and then
"shutdown done"....

thanks
sudip


> The difference between using:
> 
> pr_info("a")
> pr_info("b\n")
> 
> and
> 
> pr_info("a\n")
> pr_info("b\n")
> 
> is not emitted line count.
> 
> The first may unintentionally be continued
> by another thread using a printk that does
> not start with a KERN_<LEVEL>.
> 
> printk has had this behavior for ~5 years
> since these 2 commits:
> 
> commit e28d713704117bca0820c732210df6075b09f13b
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jun 16 11:02:28 2009 -0700
> 
>     printk: Add KERN_DEFAULT printk log-level
>     
>     This adds a KERN_DEFAULT loglevel marker, for when you cannot decide
>     which loglevel you want, and just want to keep an existing printk
>     with the default loglevel.
>     
>     The difference between having KERN_DEFAULT and having no log-level
>     marker at all is two-fold:
>     
>      - having the log-level marker will now force a new-line if the
>        previous printout had not added one (perhaps because it forgot,
>        but perhaps because it expected a continuation)
>     
>      - having a log-level marker is required if you are printing out a
>        message that otherwise itself could perhaps otherwise be mistaken
>        for a log-level.
>     
> and
> 
> commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jun 16 10:57:02 2009 -0700
> 
>     printk: clean up handling of log-levels and newlines
>     
>     It used to be that we would only look at the log-level in a printk()
>     after explicit newlines, which can cause annoying problems when the
>     previous printk() did not end with a '\n'. In that case, the log-level
>     marker would be just printed out in the middle of the line, and be
>     seen as just noise rather than change the logging level.
>     
>     This changes things to always look at the log-level in the first
>     bytes of the printout. If a log level marker is found, it is always
>     used as the log-level. Additionally, if no newline existed, one is
>     added (unless the log-level is the explicit KERN_CONT marker, to
>     explicitly show that it's a continuation of a previous line).
> 
> 
> 
