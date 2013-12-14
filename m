Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3LNRuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:50:03 -0500
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:53803 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753810Ab3LNRuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:50:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:8531:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quiet67_3a37f9fea4c53
X-Filterd-Recvd-Size: 2012
Message-ID: <1387043399.2276.12.camel@joe-AO722>
Subject: Re: bnx2x_sriov.c: Missing switch/case breaks?
From: Joe Perches <joe@perches.com>
To: Yuval Mintz <yuvalmin@broadcom.com>
Cc: Ariel Elior <ariele@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Dec 2013 09:49:59 -0800
In-Reply-To: <979A8436335E3744ADCD3A9F2A2B68A52AF1A7FF@SJEXCHMB10.corp.ad.broadcom.com>
References: <1386975703.2479.48.camel@joe-AO722>
	 <979A8436335E3744ADCD3A9F2A2B68A52AF1A735@SJEXCHMB10.corp.ad.broadcom.com>
	 <1387004267.2276.7.camel@joe-AO722>
	 <979A8436335E3744ADCD3A9F2A2B68A52AF1A7FF@SJEXCHMB10.corp.ad.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 13:26 +0000, Yuval Mintz wrote:
> > > The `vfop' part of the code contains a lot of usage of the
> > `bnx2x_vfop_finalize()',
> > > which either goto or return at the end of almost every case.
> > > "Normal" analysis tools/scripts fail to recognize them as  valid case
> > breaks.
> > >
> > > Adding `fallthrough' comments would make little sense, as this is not the
> > real
> > > behavior; Perhaps we need some alternative comment? (something in the
> > line
> > > of `macro case break')
> > 
> > No idea.  It's certainly an ugly macro.
> > 
> 
> True.
[]
> > maybe there should be a break after most all
> > uses of this macro anyway.  When next is
> 
> Won't some static code analysis tools regard such `break' calls as
> unreachable code?

I suppose that maybe true,
but this could also work...

		bnx2x_vfop_finalize(vf, vfop->rc, VFOP_CONT); 
				/* Ugly goto|return macro, not fall-through */

;)


