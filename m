Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaHRQ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:29:45 -0400
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:55624 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750977AbaHRQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:29:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3870:3871:3872:3874:4043:4250:4321:5007:6119:7652:7903:8603:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jump10_3776f88d46c01
X-Filterd-Recvd-Size: 2228
Message-ID: <1408379379.2741.9.camel@joe-AO725>
Subject: Re: [PATCH] drivers: net: ethernet: intel: e1000: e1000_ethtool.c
 coding style fixes
From: Joe Perches <joe@perches.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Aug 2014 09:29:39 -0700
In-Reply-To: <53F21FB1.7060607@intel.com>
References: <1408180328-4827-1-git-send-email-cristos@vipserv.org>
	 <1408214489.2683.87.camel@joe-AO725> <53F21BEC.2070204@intel.com>
	 <1408375914.2741.1.camel@joe-AO725> <53F21FB1.7060607@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 08:45 -0700, Alexander Duyck wrote:
> On 08/18/2014 08:31 AM, Joe Perches wrote:
> > On Mon, 2014-08-18 at 08:29 -0700, Alexander Duyck wrote:
> >> Doing any kind of pointer math on a void pointer is generally unsafe as
> >> it is an incomplete type.  The only reason why it works in GCC is
> >> because GCC has a nonstandard extension that makes it report as having a
> >> size of 1.
> > 
> > I know.  It's used in quite a few places in kernel code
> > so I believe it's now a base assumption for the kernel.
> 
> Well that is something that should probably be fixed then.  I don't
> believe it is safe to be doing any kind of pointer math on a void pointer.
> 
> We really shouldn't be using any GCC specific bits unless we absolutely
> have to.

Good luck with that.

Here's a little coccinelle script to find them:

$ cat void_arithmetic.spatch
@@
void *p;
expression e;
@@

*	p + e
$

There are at least 23 uses just in lib/

$ spatch -sp_file void_arithmetic.spatch lib | \
  grep "^\-[^\-]" | wc -l
23

I'm fairly confident there are more than that,
but using spatch with --recursive-includes is
pretty slow on my machine.


