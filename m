Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFOXcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 19:32:48 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:47070 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752146AbaFOXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 19:32:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:857:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3871:3872:3876:4321:4605:5007:7652:9149:10004:10400:10848:11026:11232:11233:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime93_1766647f16907
X-Filterd-Recvd-Size: 2157
Message-ID: <1402875159.2750.4.camel@joe-AO725>
Subject: Re: [PATCH -next 25/26] fbdev: Use dma_zalloc_coherent
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Date: Sun, 15 Jun 2014 16:32:39 -0700
In-Reply-To: <CAMuHMdWHJ1LY0r1aMZViQW_ZZYrbGkHb4Hpkt+YZfRbERfyE3Q@mail.gmail.com>
References: <cover.1402863904.git.joe@perches.com>
	 <881b8f8d85c96b6e9d8735aa10bbf18468688b9d.1402863905.git.joe@perches.com>
	 <CAMuHMdWHJ1LY0r1aMZViQW_ZZYrbGkHb4Hpkt+YZfRbERfyE3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 00:16 +0200, Geert Uytterhoeven wrote:
> On Sun, Jun 15, 2014 at 10:37 PM, Joe Perches <joe@perches.com> wrote:
> > diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx-fb.c
[]
> > @@ -1447,18 +1447,15 @@ static int fb_probe(struct platform_device *device)
> >                 da8xx_fb_fix.line_length - 1;
> >
> >         /* allocate palette buffer */
> > -       par->v_palette_base = dma_alloc_coherent(NULL,
> > -                                              PALETTE_SIZE,
> > -                                              (resource_size_t *)
> > -                                              &par->p_palette_base,
> > -                                              GFP_KERNEL | GFP_DMA);
> > +       par->v_palette_base = dma_zalloc_coherent(NULL, PALETTE_SIZE,
> > +                                                 (resource_size_t *)&par->p_palette_base,
> 
> Suggestion for further cleanup: It seems this cast is no longer needed.

Sure, but after this is applied.

