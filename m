Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3KRCPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:15:43 -0500
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:38898 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751546Ab3KRCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:15:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2730:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7903:9012:10004:10400:10471:10848:11232:11658:11914:12517:12519:12740:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nerve62_880f253720057
X-Filterd-Recvd-Size: 2093
Message-ID: <1384740932.5814.4.camel@joe-AO722>
Subject: Re: [PATCH] Clarify error on directive in macro arguments (Re:
 [PATCH] jffs2: fix sparse errors: directive in argument list)
From: Joe Perches <joe@perches.com>
To: Greg Price <price@MIT.EDU>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Erico Nunes <nunes.erico@gmail.com>, linux-sparse@vger.kernel.org,
        dwmw2 <dwmw2@infradead.org>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 17 Nov 2013 18:15:32 -0800
In-Reply-To: <20131118020746.GX16018@ringworld.MIT.EDU>
References: <20131118020746.GX16018@ringworld.MIT.EDU>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 21:07 -0500, Greg Price wrote:
> [+linux-sparse and Chris]
> 
> On Mon, Nov 18, 2013 at 01:33:49AM +0000, Al Viro wrote:
> > On Sun, Nov 17, 2013 at 02:45:05PM -0800, Joe Perches wrote:
> > > Yes.  I think it's a defect in how sparse
> > > treats string concatenation.
> > > 
> > > That style [... with printk ...] is pretty common in the kernel sources.
> > 
> > ... and it's perfectly fine, until somebody starts playing in nasal
> > daemon country and do that in *macro* arguments.  And a nasal daemon
> > country it is - it's an undefined behaviour.  See 6.10.3p11 in C99.
> > And trying to define a semantics for that gets real ugly real fast.
> > sparse matches gcc behaviour (I hope), but it warns about such abuses.
> > It's a defect, all right - one being reported by sparse.
> 
> Perhaps the following tweak to the error message would make this
> subtlety clearer?

Maybe, but this case isn't a macro.  It's a function.
Dunno if differentiating when it's a macro or a
function is difficult though.


