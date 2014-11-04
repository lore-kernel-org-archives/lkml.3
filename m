Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKDOJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:09:32 -0500
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:54229 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153AbaKDOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:09:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leg57_189b144c02f3c
X-Filterd-Recvd-Size: 1783
Message-ID: <1415110167.24560.4.camel@perches.com>
Subject: Re: [PATCH] fs: quota: Use quota_err and use %pf to reduce code size
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
Date: Tue, 04 Nov 2014 06:09:27 -0800
In-Reply-To: <20141104111525.GE2953@quack.suse.cz>
References: <b0c0688733c11770bd03433eeac7cb2843d9f166.1415073710.git.joe@perches.com>
	 <20141104111525.GE2953@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 12:15 +0100, Jan Kara wrote:
> On Mon 03-11-14 20:04:41, Joe Perches wrote:
> > Use more standard logging style and remove __func__ passed
> > to quota_err.
> > 
> > Remove the quota_error macro, rename __quota_error to quota_err.
> > Add %pf and __builtin_return_address(0) instead of __func__
[]
> Changing
> __func__ to __builtin_return_address(0) is mostly pointless. OK, saves you
> 600 bytes but quota isn't really aimed at embedded systems and it reduces
> usefullness of the message because of inlining.

That doesn't make any sense to me.
__quota_error or quota_err is specifically not inlined.
It's EXPORT_SYMBOL.

>  Adding '\n' at the end of
> messages instead of doing it automatically in quota_error() is also IMO
> pointless churn (there are other error reporting functions in kernel which
> do this so it's not like we have a consensus on this).

Fewer and fewer


