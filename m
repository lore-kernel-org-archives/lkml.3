Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3JCQOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:14:49 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:38836 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754578Ab3JCQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:14:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3872:3873:3874:4250:4321:4425:5007:7652:7807:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss49_80e7e74d2553d
X-Filterd-Recvd-Size: 2585
Message-ID: <1380816884.2081.113.camel@joe-AO722>
Subject: Re: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug
From: Joe Perches <joe@perches.com>
To: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Cc: OS Engineering <osengineering@stec-inc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Date: Thu, 03 Oct 2013 09:14:44 -0700
In-Reply-To: <24CA9A5C93173F48A9E3313B866A7C280F1C10@MYMBX3.stec-inc.ad>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E70587F@sambx4.stec-inc.ad>
	 <1380652383.1924.5.camel@joe-AO722>
	 <24CA9A5C93173F48A9E3313B866A7C280F1C10@MYMBX3.stec-inc.ad>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 10:09 +0000, Ramprasad Chinthekindi wrote:
> > -----Original Message-----
> > On Tue, 2013-10-01 at 12:25 +0000, OS Engineering wrote:
> > > Hi Jens,
> > > I'm sending a patch to replace custom debug macros with pr_debug().
> > Kindly please review the patch.
> > > Thanking you.
> > 
> > I think that this doesn't differentiate between
> > the 2 debugging levels currently implemented.
> > 
> > I'd do something like this:
> > 
> > Add pr_fmt to prefix pr_<level> uses with "skd: "
> > Add skd_<level> convenience logging macros
> > Convert VPRINTK/DPRINTK to skd_dbg(level, skdev, fmt, ...)
> > Convert pr_<level>("(%s): ...", skd_name(skdev), ...) uses to
> > 	skd_<level>(skdev, ...)
> > Use kcalloc not kzalloc with multiply
> > Remove a couple unnecessary pr_err function logging uses
> > Add missing newline to logging
[]
> Jens Axboe and other community members suggested us to remove the custom PRINTK macros from driver and replace them with pr_* macros directly.
> From driver's perspective, it's perfectly fine not to distinguish VPRINTs and DPRINTs. Hence, both have been replaced with pr_debug().

The initial patch net adds ~120 line of code,
the suggested patch net removes ~50 and
consolidates a few different output styles.

Also, please don't quote the entire patch
without commenting on it.  Delete the
quoted stuff that's not relevant please.

