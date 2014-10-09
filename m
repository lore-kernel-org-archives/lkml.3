Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbaJIOST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:18:19 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:51238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751684AbaJIOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:18:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:4384:4605:5007:7652:10004:10400:10848:10967:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12683:12740:13069:13071:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: foot03_29a28b7e91255
X-Filterd-Recvd-Size: 2557
Message-ID: <1412864283.3438.43.camel@joe-AO725>
Subject: Re: [PATCH 2/2] ALSA: au88x0: pr_* replaced with dev_*
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 07:18:03 -0700
In-Reply-To: <s5hd2a1tlb2.wl-tiwai@suse.de>
References: <1412847397-4292-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <1412847397-4292-2-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hd2a1tlb2.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 15:38 +0200, Takashi Iwai wrote:
> At Thu,  9 Oct 2014 15:06:37 +0530,
> Sudip Mukherjee wrote:
> > 
> > pr_* macros replaced with dev_* as they are more preffered over pr_*.
> > each file which had pr_* was reviewed manually and replaced with dev_*.
> > here we have actually used the reference of the vortex which was added
> > to some functions in the previous patch of this series.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  sound/pci/au88x0/au88x0.c        |  26 +++++-----
> >  sound/pci/au88x0/au88x0_a3d.c    |  15 +++---
> >  sound/pci/au88x0/au88x0_core.c   | 103 ++++++++++++++++++++++-----------------
> >  sound/pci/au88x0/au88x0_eq.c     |   3 +-
> >  sound/pci/au88x0/au88x0_game.c   |   3 +-
> >  sound/pci/au88x0/au88x0_mpu401.c |   2 +-
> >  sound/pci/au88x0/au88x0_pcm.c    |   7 +--
> >  sound/pci/au88x0/au88x0_synth.c  |  17 ++++---
> >  8 files changed, 98 insertions(+), 78 deletions(-)
> > 
> > diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
[]
> > @@ -48,10 +48,10 @@ static void vortex_fix_latency(struct pci_dev *vortex)
> >  {
> >  	int rc;
> >  	if (!(rc = pci_write_config_byte(vortex, 0x40, 0xff))) {
> > -			pr_info( CARD_NAME
> > +			dev_info(&vortex->dev, CARD_NAME
> >  			       ": vortex latency is 0xff\n");
> 
> Omit the superfluous prefix when converting to dev_info() & co.
> Other than that, looks good to me.

Hi Sudip.

Probably all the uses of CARD_NAME and "vortex" singly and
in combination should be removed in all these conversions.


