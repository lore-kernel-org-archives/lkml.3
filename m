Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaJKKsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:48:16 -0400
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:36997 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752099AbaJKKsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:48:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:4321:4384:4385:4395:4605:5007:7652:10004:10400:10450:10455:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:19904:19999:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pin50_47c69a6e2893d
X-Filterd-Recvd-Size: 3413
Message-ID: <1413024491.16385.10.camel@joe-AO725>
Subject: Re: [alsa-devel] [PATCH v2 2/2] ALSA: au88x0: pr_* replaced with
 dev_*
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Raymond Yau <superquad.vortex2@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 03:48:11 -0700
In-Reply-To: <20141011090903.GC8231@sudip-PC>
References: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <1412930199-24797-2-git-send-email-sudipm.mukherjee@gmail.com>
	 <CAN8ccibSw_85wdnxbNSKfjXQ-7Lg3C6_5fhKQJJi5xMi8pMabA@mail.gmail.com>
	 <20141011090903.GC8231@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 14:39 +0530, Sudip Mukherjee wrote:
> On Sat, Oct 11, 2014 at 03:20:56PM +0800, Raymond Yau wrote:
> > >
> > > pr_* macros replaced with dev_* as they are more preffered over pr_*.
> > > each file which had pr_* was reviewed manually and replaced with dev_*.
> > > here we have actually used the reference of the vortex which was added
> > > to some functions in the previous patch of this series.
> > >
> > > The prefix of the CARD_NAME and prefix of "vortex:" was also
> > > removed as the dev_* will print the device name.
> > >
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > ---
> > >
> > 
> > >  static int vortex_core_init(vortex_t *vortex)
> > >  {
> > >
> > > -       pr_info( "Vortex: init.... ");
> > > +       dev_info(vortex->card->dev, "init.... ");
> > 
> > Is it possible to add linefeed  since "done/n" won't appear in the same
> > line with init nor shutdown?
> > 
> should we add linefeed ?
> as of now it will print init.... then it will print done as the init is complete.
> so dmesg will show us:
> 
> init....done.
> 
> same for shutdown.
> but if we give linefeed , then it will become : 
> 
> init....
> done.
> 
> the meaning will be lost. and many user might just wonder what is done ? 
[]
> > > @@ -2738,7 +2744,7 @@ static int vortex_core_init(vortex_t *vortex)
> > >  static int vortex_core_shutdown(vortex_t * vortex)
> > >  {
> > >
> > > -       pr_info( "Vortex: shutdown...");
> > > +       dev_info(vortex->card->dev, "shutdown...");
> > >  #ifndef CHIP_AU8820
> > >         vortex_eq_free(vortex);
> > >         vortex_Vort3D_disable(vortex);
> > > @@ -2760,7 +2766,7 @@ static int vortex_core_shutdown(vortex_t * vortex)
> > >         msleep(5);
> > >         hwwrite(vortex->mmio, VORTEX_IRQ_SOURCE, 0xffff);
> > >
> > > -       pr_info( "done.\n");
> > > +       dev_info(vortex->card->dev, "done.\n");
> > >         return 0;
> > >  }

It's actually on 2 lines before your patch.

	pr_info("a");
	pr_info("b\n");

already emits 2 separate lines.

	pr_info("a");
	pr_cont("b\n");

emits a single line "ab"
(unless some other thread emits something in-between)

pr_cont or a bare printk can be used after a dev_info
without a newline to avoid unwanted newlines.

