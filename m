Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbaEPUMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:12:32 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:45562 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755179AbaEPUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:12:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:4250:4321:5007:7576:7652:7903:9040:9545:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13071:13072:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jelly78_1546bf0baaf63
X-Filterd-Recvd-Size: 2069
Message-ID: <1400271144.12373.21.camel@joe-AO725>
Subject: Re: [PATCH] bnx2x: Convert return 0 to return rc
From: Joe Perches <joe@perches.com>
To: Dmitry Kravkov <Dmitry.Kravkov@qlogic.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Cc: Ariel Elior <ariel.elior@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 May 2014 13:12:24 -0700
In-Reply-To: <87B4DDAD5EAFA041BDC28F314593782D0172ECD7@avmb3.qlogic.org>
References: <1400223103.30884.5.camel@joe-AO725>
	 <87B4DDAD5EAFA041BDC28F314593782D0172ECD7@avmb3.qlogic.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 12:02 +0000, Dmitry Kravkov wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org [mailto:netdev-
> > owner@vger.kernel.org] On Behalf Of Joe Perches
> > Sent: Friday, May 16, 2014 9:52 AM
> > To: Ariel Elior; Dmitry Kravkov
> > Cc: netdev; linux-kernel
> > Subject: [PATCH] bnx2x: Convert return 0 to return rc
> >
> > These "return 0;" uses seem wrong as there are
> > rc variables where error return values are set
> > but unused.
[]
> Thanks Joe for catching this!
> 
> Acked-by: Dmitry Kravkov <Dmitry.Kravkov@qlogic.com>

Hello Dmitry.

Couple things actually:
o Could you please update the MAINTAINER entry for
  BNX2X?  Ariel Elior's email address is still listed
  as @broadcom and that seems to bounce.

o I found this via coccinelle actually.
  Julia Lawall submitted a patch to remove unused
  netdev_priv calls.  I modified that to check for
  any expression that returns an unused value and
  found this and many others.  There are a lot of
  false positives though.

@@
local idexpression x;
expression E;
@@
-x = E;
    ... when != x


