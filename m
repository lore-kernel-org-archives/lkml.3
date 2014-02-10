Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBJRTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:19:51 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:43460 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaBJRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:19:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:7652:7903:8531:8985:9010:9025:9388:10004:10049:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tail95_72ac8cab9bd13
X-Filterd-Recvd-Size: 2161
Message-ID: <1392052786.2507.20.camel@joe-AO722>
Subject: Re: WARNING: Unnecessary parentheses - maybe == should be = ?
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 09:19:46 -0800
In-Reply-To: <20140210092710.GA10899@elgon.mountain>
References: <20140210092710.GA10899@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 12:27 +0300, Dan Carpenter wrote:
> These messages are terrifying...

Hey Dan.

Do bumps in the night keep you up too? :)

> We do not want to encourage a million
> first patch submitters to start introducing = vs == bugs.

Definitely true and I didn't think of that.

> Did you look through the warning messages this generates?  Was it ever
> appropriate to change the == to =?

I didn't check.  My thought was that this was for
patches not files and the use of:

	if ((foo == bar))

in a patch was excessive parentheses.  The reason
to use the ((foo == bar)) form is when the intent
is to assign.

> Please remove the second part of that message.

Maybe emit it when what being scanned is a patch,
but not a file and only emit the excessive parens
when it's a file.

> Also there needs to be a mailing list for checkpatch.pl.  LKML is a
> write only archive, but it's not a discussion list.

<shrug>.

A mailing list just for checkpatch seems excessive.

Maybe a combined source tools mailing list for scripts/
would be better and maybe smatch should be there too.

> Also the seq_puts() warning messages should be put under --strict
> because we have to fight against people submitting those patches.

Another <shrug>.

I still kind of like the seq_printf macro hack.
http://lkml.org/lkml/2013/3/16/79


