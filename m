Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3KQWpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 17:45:14 -0500
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:52916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751377Ab3KQWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 17:45:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:3871:3872:3873:3874:4321:5007:7652:9012:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shirt71_2cd8481336d4b
X-Filterd-Recvd-Size: 1418
Message-ID: <1384728305.14335.4.camel@joe-AO722>
Subject: Re: [PATCH] jffs2: fix sparse errors: directive in argument list
From: Joe Perches <joe@perches.com>
To: Erico Nunes <nunes.erico@gmail.com>
Cc: linux-sparse@vger.kernel.org, dwmw2 <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 17 Nov 2013 14:45:05 -0800
In-Reply-To: <CAK4VdL2nKEE+xb=HtMGNsMGNR_ivUn_WnLi7X-rrXT0fpGbSTw@mail.gmail.com>
References: <1384719513-27386-1-git-send-email-nunes.erico@gmail.com>
	 <1384724403.2727.22.camel@joe-AO722>
	 <CAK4VdL2nKEE+xb=HtMGNsMGNR_ivUn_WnLi7X-rrXT0fpGbSTw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 20:34 -0200, Erico Nunes wrote:
> Do you mean it as an error in the sparse tool?

Yes.  I think it's a defect in how sparse
treats string concatenation.

That style:

	printk("%s\n",
#ifdef FOO
	"foo"
#endif
#ifdef BAR
	"bar"
#endif
	"string");

is pretty common in the kernel sources.

The patch itself is otherwise fine, but
perhaps unnecessary.


