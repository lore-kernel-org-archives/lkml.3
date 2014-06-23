Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaFWXsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:48:47 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:53868 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752012AbaFWXsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:48:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2899:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3770:3865:3866:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:7875:7903:7904:8599:8985:8987:9015:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12740:13069:13071:13161:13229:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: walk66_2f31e8720214f
X-Filterd-Recvd-Size: 2284
Message-ID: <1403567322.20657.14.camel@joe-AO725>
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
From: Joe Perches <joe@perches.com>
To: Julian Calaby <julian.calaby@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Jun 2014 16:48:42 -0700
In-Reply-To: <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com>
References: <cover.1403530604.git.joe@perches.com>
	 <20140623172512.GA1390@garbanzo.do-not-panic.com>
	 <1403550809.15811.13.camel@joe-AO725>
	 <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Julia Lawall and removing almost all other cc's)

On Tue, 2014-06-24 at 09:27 +1000, Julian Calaby wrote:
> Hi Joe,

Hello Julian.

> > $ cat ./scripts/coccinelle/api/alloc/pci_zalloc_consistent.cocci
> > ///
> > /// Use pci_zalloc_consistent rather than
> > ///     pci_alloc_consistent followed by memset with 0
> > ///
> > /// This considers some simple cases that are common and easy to validate
> > /// Note in particular that there are no ...s in the rule, so all of the
> > /// matched code has to be contiguous
> > ///
> > /// Blatantly cribbed from: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> >
> > @@
> > type T, T2;
> > expression x;
> > expression E1,E2,E3;
> > statement S;
> > @@
> >
> > - x = (T)pci_alloc_consistent(E1,E2,E3);
> > + x = pci_zalloc_consistent(E1,E2,E3);
> >   if ((x==NULL) || ...) S
> > - memset((T2)x,0,E2);
> 
> I don't know much about SmPL, but wouldn't having that if statement
> there reduce your matches?

No, not really.

Almost none of the pci_alloc_consistent calls
do not have a test for failure immediately after
them.

Coccinelle is a very cool code transformation tool,
quite useful for these sorts of patch conversions.

http://coccinelle.lip6.fr/documentation.php


