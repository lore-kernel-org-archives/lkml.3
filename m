Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaGESJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:09:14 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:38740 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754286AbaGESJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:09:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:7652:7903:9025:9040:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13138:13231:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: alley78_6bd6cd392b750
X-Filterd-Recvd-Size: 2346
Message-ID: <1404583739.6384.51.camel@joe-AO725>
Subject: Re: [PATCH v2] declance: Fix 64-bit compilation warnings
From: Joe Perches <joe@perches.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 05 Jul 2014 11:08:59 -0700
In-Reply-To: <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	 <20140702.182807.1245632778216212860.davem@davemloft.net>
	 <alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	 <alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	 <1404356734.14741.18.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	 <1404364565.14741.26.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	 <1404368746.14741.36.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	 <1404576420.6384.41.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-05 at 18:39 +0100, Maciej W. Rozycki wrote:
> On Sat, 5 Jul 2014, Joe Perches wrote:
> 
> > >  One question though, does either of you or anybody else know why we're 
> > > inconsistent about this 0x prefixing of virtual addresses vs physical 
> > > addresses?  Specifically %p vs e.g. %pad.
> > 
> > I think it's a mistake and I agree.
> > 
> > I submitted a patch to remove the prefix from %pad.
> > 
> > https://lkml.org/lkml/2014/3/21/333
> 
>  Great!  Your proposal looks good to me in principle, however you need to 
> factor in SPECIAL having been set by `#' somehow as `number' will respect 
> it.  I suggest using the same field width calculation that `pointer' uses 
> for `default_width' (sans the type used with `sizeof' of course, that is).

I don't think %#p is valid so it
shouldn't have been set by #.


