Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaEVBD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:03:56 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:57052 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750770AbaEVBDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:03:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2689:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7652:7901:8957:8985:9025:9040:10004:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass76_5c3efaec37c12
X-Filterd-Recvd-Size: 2329
Message-ID: <1400720632.11896.7.camel@joe-AO725>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Date: Wed, 21 May 2014 18:03:52 -0700
In-Reply-To: <20140522002822.GA6446@roeck-us.net>
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
	 <1400605602.26709.11.camel@joe-AO725> <20140522002822.GA6446@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 17:28 -0700, Guenter Roeck wrote:
> On Tue, May 20, 2014 at 10:06:42AM -0700, Joe Perches wrote:
> > On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
> > > Cc: Kurt Garloff <garloff@suse.de>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > > ---
> > >  drivers/scsi/tmscsim.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> > []
> > > @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
> > >        printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
> > >      else
> > >        lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
> > > -    id = 0; while (lun >>= 1) id++;
> > > +    id = ilog2(lun);
> > >      /* Get LUN */
> > >      lun = DC390_read8 (ScsiFifo);
> > >      if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
> > 
> > Hey Fabian.
> > 
> > You've submitted several of these now.
> > 
> > Have you gone through all of these to make sure
> > that the ilog2(<foo>) uses are always using a
> > non-zero <foo>?
> > 
> Maybe I am missing something. Why not just use fls() ?

fls strains Andrew Morton's brain.

https://lkml.org/lkml/2014/5/19/771


