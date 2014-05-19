Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaESXuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:50:11 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:45765 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894AbaESXuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:50:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3866:3867:3871:3872:4321:5007:6119:7652:7901:7903:10004:10400:10848:10967:11232:11658:11914:12049:12517:12519:12740:13069:13311:13357:13548,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cork47_3b531f738fd2f
X-Filterd-Recvd-Size: 1872
Message-ID: <1400543405.19786.4.camel@joe-AO725>
Subject: Re: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by fls
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 19 May 2014 16:50:05 -0700
In-Reply-To: <20140519164037.ec6438686bd29efeebffa610@linux-foundation.org>
References: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
	 <20140519160946.84e79c832dfc4db0fbae573b@linux-foundation.org>
	 <1400541748.14238.58.camel@joe-AO725>
	 <20140519164037.ec6438686bd29efeebffa610@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 16:40 -0700, Andrew Morton wrote:
> On Mon, 19 May 2014 16:22:28 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2014-05-19 at 16:09 -0700, Andrew Morton wrote:
> > > On Fri, 16 May 2014 22:38:15 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > > > Replace while blocksize;shift by fls -1
> > []
> > > fls() always makes my brain hurt.  ilog() is nicer?
> > Maybe take an aspirin?
> > ilog2(n) is effectively fls(n) - 1
> Precisely.  ilog2() means "integer log 2".  Whereas fls() is some weird
> low-level bit-scanning thing.

<shrug>  find-last[bit]-set is pretty obvious to me.
ilog2(n) makes me think just a little more.

> What we want at this callsite is "integer log 2".  So use it.

Same thing.  Same ratio of use too.

$ git grep -w fls | wc -l
457
$ git grep -w ilog2 | wc -l
391


