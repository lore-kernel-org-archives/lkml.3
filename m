Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaKWP4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:56:45 -0500
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:40821 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648AbaKWP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:56:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:965:967:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4390:5007:6261:7903:8526:9025:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:12926:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pet74_1cfb94587d837
X-Filterd-Recvd-Size: 3133
Message-ID: <1416758195.6651.47.camel@perches.com>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
From: Joe Perches <joe@perches.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Sun, 23 Nov 2014 07:56:35 -0800
In-Reply-To: <CAMxnaaVb0253q7V-M7089Et+bfnmgN1E+Ttne4MFG8_U+CTbOA@mail.gmail.com>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>
	 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
	 <546F2E50.5040804@users.sourceforge.net>
	 <1416593688.6651.39.camel@perches.com>
	 <5471EBAC.40903@users.sourceforge.net>
	 <1416756022.6651.45.camel@perches.com>
	 <CAMxnaaVb0253q7V-M7089Et+bfnmgN1E+Ttne4MFG8_U+CTbOA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 16:45 +0100, Andreas Noever wrote:
> On Sun, Nov 23, 2014 at 4:20 PM, Joe Perches <joe@perches.com> wrote:
> > On Sun, 2014-11-23 at 15:14 +0100, SF Markus Elfring wrote:
> >> >> 2. Are any additional prefixes appropriate so that further name space
> >> >>    conflicts can be better avoided?
> >> >
> >> > To avoid possible external naming conflicts, add tb_ prefix to
> >> > various ring_<foo> structs and functions.
> >>
> >> Do you imagine that any XEN software developers need also to reconsider
> >> this implementation detail?
> >> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/char/tpm/xen-tpmfront.c?id=fc14f9c1272f62c3e8d01300f52467c0d9af50f9#n268
> >
> > I think static functions can be named whatever
> > the developer chooses.
> Do symbols which are not exported (no EXPORT_SYMBOL_(GPL)) cause
> conflicts?

If the symbol is not static, yes.

eg: the static uses of "debug" as a control
variable vs the non-static uses of <prefix>debug
when shared among multiple objects in a single
driver.


