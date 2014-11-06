Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaKFArx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:47:53 -0500
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:38411 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751002AbaKFArv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:47:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:6119:6261:7901:7903:9121:10004:10400:10848:10967:11232:11233:11658:11914:12517:12519:12740:13069:13149:13160:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club60_7e61c9488f546
X-Filterd-Recvd-Size: 2246
Message-ID: <1415234867.6634.42.camel@perches.com>
Subject: Re: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 16:47:47 -0800
In-Reply-To: <20141105193817.0d2cfaf3@gandalf.local.home>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	 <20141105173454.7aa47289@gandalf.local.home>
	 <1415227908.6634.30.camel@perches.com>
	 <20141105193817.0d2cfaf3@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 19:38 -0500, Steven Rostedt wrote:
> On Wed, 05 Nov 2014 14:51:48 -0800 Joe Perches <joe@perches.com> wrote:

[]
> > > I know that it's considered bad form
> > > to split strings like this, but I consider this one of the exceptions
> > > to the rule.
> > 
> > Why is that?
> > 
> > btw: when the strings fragments are put on the same line,
> > it's nicer to take out the intermediate joining " " bits too.
> > 
> > I'd've probably used 2 seq_puts calls like:
> > 
> > 	seq_puts(m, "  Function                               Hit    Time            Avg             s^2\n");
> > 	seq_puts(m, "  --------                               ---    ----            ---             ---\n");
> > 
> 
> In this case it's just that I hate that big white space followed by
> content.
> 
> Maybe I'll change my mind in the future, but for now, I'd rather just
> leave it as is.

My eyes generally skip over the embedded whitespace.

It's also generally less code space to use a single format string
instead of something like:

	printf("  %-39s%-7s%-16s%-16s%s\n", "Function", "Hit", "Time", "Avg", "s^2");


