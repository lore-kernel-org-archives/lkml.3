Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaKCSjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:39:24 -0500
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:59609 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752484AbaKCSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:39:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2561:2564:2682:2685:2692:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:6261:6691:8599:8957:8985:9025:9388:10004:10400:10848:11232:11257:11658:11914:12043:12438:12517:12519:12682:12740:12776:13069:13137:13150:13230:13231:13311:13357:14039:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fear80_8b91dfea3af16
X-Filterd-Recvd-Size: 2121
Message-ID: <1415039957.17743.29.camel@perches.com>
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 10:39:17 -0800
In-Reply-To: <20141103180528.GA9026@jtriplet-mobl1>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
	 <20141103114656.3bf200df@lwn.net> <1415036860.17743.25.camel@perches.com>
	 <20141103180528.GA9026@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 10:05 -0800, Josh Triplett wrote:
> On Mon, Nov 03, 2014 at 09:47:40AM -0800, Joe Perches wrote:
[]
> "don't put an else after an if condition
> ending with break or return;

Maybe that's a bit _too_ simple.
Yes for a simple if, but not necessarily an else if

	if (foo) {
		...;
	} else if (bar) {
		more code...;
		return;
	} else {
		...
	}

still needs that last else.

checkpatch isn't very good at that code flow
interpretation so it emits a warning anyway.

> > Another thing that could go is the suggestion to
> > use Lindent.
> > 
> > https://lkml.org/lkml/2013/2/11/390
> 
> Agreed completely.  We might consider coming up with settings for
> clang-format, which seems like a far more capable replacement that
> actually understands C.

Never used it.
It does seem to have a large number of options
(including a trivial linux-kernel style) though.

http://clang.llvm.org/docs/ClangFormatStyleOptions.html

Dunno how much work it would be to create a proper
linux-kernel style for clang-format.

It might work well, it might not.
Anyone have experience with it?


