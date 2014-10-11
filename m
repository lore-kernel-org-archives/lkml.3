Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaJKPcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:32:55 -0400
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:39889 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752271AbaJKPcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:32:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4384:4385:4395:4605:5007:7652:7875:7903:9121:10004:10848:11026:11232:11233:11473:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13019:13095:13137:13141:13150:13161:13229:13230:13231:14039:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: elbow47_531d86737a155
X-Filterd-Recvd-Size: 5962
Message-ID: <1413041569.16385.20.camel@joe-AO725>
Subject: Re: [alsa-devel] [PATCH v2 2/2] ALSA: au88x0: pr_* replaced with
 dev_*
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: h@sudip-PC, Raymond Yau <superquad.vortex2@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 08:32:49 -0700
In-Reply-To: <20141011113349.GA9962@sudip-PC>
References: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <1412930199-24797-2-git-send-email-sudipm.mukherjee@gmail.com>
	 <CAN8ccibSw_85wdnxbNSKfjXQ-7Lg3C6_5fhKQJJi5xMi8pMabA@mail.gmail.com>
	 <20141011090903.GC8231@sudip-PC> <1413024491.16385.10.camel@joe-AO725>
	 <20141011113349.GA9962@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 17:03 +0530, Sudip Mukherjee wrote:
> On Sat, Oct 11, 2014 at 03:48:11AM -0700, Joe Perches wrote:
> > On Sat, 2014-10-11 at 14:39 +0530, Sudip Mukherjee wrote:
> > > On Sat, Oct 11, 2014 at 03:20:56PM +0800, Raymond Yau wrote:
> > > > >
> <snip>
> > > > > ---
> > > > >
> > > > 
> > > > >  static int vortex_core_init(vortex_t *vortex)
> > > > >  {
> > > > >
> > > > > -       pr_info( "Vortex: init.... ");
> > > > > +       dev_info(vortex->card->dev, "init.... ");
> > > > 
> > > > Is it possible to add linefeed  since "done/n" won't appear in the same
> > > > line with init nor shutdown?
> > > > 
> > > should we add linefeed ?
> > > as of now it will print init.... then it will print done as the init is complete.
> > > so dmesg will show us:
> > > 
> > > init....done.
> > > 
> > > same for shutdown.
> > > but if we give linefeed , then it will become : 
> > > 
> > > init....
> > > done.
> > > 
> > > the meaning will be lost. and many user might just wonder what is done ? 
> > []
> > > > > @@ -2738,7 +2744,7 @@ static int vortex_core_init(vortex_t *vortex)
> > > > >  static int vortex_core_shutdown(vortex_t * vortex)
> > > > >  {
> > > > >
> > > > > -       pr_info( "Vortex: shutdown...");
> > > > > +       dev_info(vortex->card->dev, "shutdown...");
> > > > >  #ifndef CHIP_AU8820
> > > > >         vortex_eq_free(vortex);
> > > > >         vortex_Vort3D_disable(vortex);
> > > > > @@ -2760,7 +2766,7 @@ static int vortex_core_shutdown(vortex_t * vortex)
> > > > >         msleep(5);
> > > > >         hwwrite(vortex->mmio, VORTEX_IRQ_SOURCE, 0xffff);
> > > > >
> > > > > -       pr_info( "done.\n");
> > > > > +       dev_info(vortex->card->dev, "done.\n");
> > > > >         return 0;
> > > > >  }
> > 
> > It's actually on 2 lines before your patch.
> > 
> > 	pr_info("a");
> > 	pr_info("b\n");
> > 
> > already emits 2 separate lines.
> > 
> > 	pr_info("a");
> > 	pr_cont("b\n");
> > 
> > emits a single line "ab"
> > (unless some other thread emits something in-between)
> > 
> > pr_cont or a bare printk can be used after a dev_info
> > without a newline to avoid unwanted newlines.
> 
> i think i was not thinking while writing the previous mail.

It seems you were thinking then and now,
but unfortunately, you are assuming a bit
more than you have actual experience or
knowledge of printk inner workings.
 
> pr_info("a");
> pr_info("b\n");
> should print as "ab" ,
 
This is not true.

All pr_<level> uses but pr_cont always
start on a new line by emitting a newline
if the last line did not have one.

The difference between using:

pr_info("a")
pr_info("b\n")

and

pr_info("a\n")
pr_info("b\n")

is not emitted line count.

The first may unintentionally be continued
by another thread using a printk that does
not start with a KERN_<LEVEL>.

printk has had this behavior for ~5 years
since these 2 commits:

commit e28d713704117bca0820c732210df6075b09f13b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jun 16 11:02:28 2009 -0700

    printk: Add KERN_DEFAULT printk log-level
    
    This adds a KERN_DEFAULT loglevel marker, for when you cannot decide
    which loglevel you want, and just want to keep an existing printk
    with the default loglevel.
    
    The difference between having KERN_DEFAULT and having no log-level
    marker at all is two-fold:
    
     - having the log-level marker will now force a new-line if the
       previous printout had not added one (perhaps because it forgot,
       but perhaps because it expected a continuation)
    
     - having a log-level marker is required if you are printing out a
       message that otherwise itself could perhaps otherwise be mistaken
       for a log-level.
    
and

commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jun 16 10:57:02 2009 -0700

    printk: clean up handling of log-levels and newlines
    
    It used to be that we would only look at the log-level in a printk()
    after explicit newlines, which can cause annoying problems when the
    previous printk() did not end with a '\n'. In that case, the log-level
    marker would be just printed out in the middle of the line, and be
    seen as just noise rather than change the logging level.
    
    This changes things to always look at the log-level in the first
    bytes of the printout. If a log level marker is found, it is always
    used as the log-level. Additionally, if no newline existed, one is
    added (unless the log-level is the explicit KERN_CONT marker, to
    explicitly show that it's a continuation of a previous line).



