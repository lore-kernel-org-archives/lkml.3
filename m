Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3JHA3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:29:09 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:59617 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591Ab3JHA3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:29:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3315:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6117:7652:7903:8603:10004:10400:10450:10455:10848:10967:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:13523:13524:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crook33_14b8998d9e64c
X-Filterd-Recvd-Size: 2127
Message-ID: <1381192140.2081.235.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Add check for sscanf without return use
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 17:29:00 -0700
In-Reply-To: <CAErSpo75uQL5woms175LR4KCAmqT_SWpQcXGdbKccgVPdh6xhg@mail.gmail.com>
References: <1381189523.2081.225.camel@joe-AO722>
	 <20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
	 <1381190594.2081.228.camel@joe-AO722>
	 <CAErSpo75uQL5woms175LR4KCAmqT_SWpQcXGdbKccgVPdh6xhg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 18:10 -0600, Bjorn Helgaas wrote:
> On Mon, Oct 7, 2013 at 6:03 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2013-10-07 at 16:56 -0700, Andrew Morton wrote:
> >> On Mon, 07 Oct 2013 16:45:23 -0700 Joe Perches <joe@perches.com> wrote:
> >>
> >> > Naked use sscanf can be troublesome.
> >>
> >> It would be helpful to expand on "troublesome"?
> >
> > Dunno, you either know or the couple of paragraphs
> > it takes to explain with examples won't really be
> > too helpful in a commit log.
> 
> It would be helpful to me, since I don't write code with sscanf every
> day.  A URL to an LKML description or something would be enough if the
> commit log size is the concern.

I sent a V2 patch to Andrew and mm using this commit log:

Naked use sscanf can be troublesome because the pointed
to variables may not have been set.

Add a warning when the sscanf return value is not used.

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Use the $Compare variable instead of just == or !=
    There are some tests that use < and >


