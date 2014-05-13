Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaEMTNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:13:25 -0400
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:48254 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751719AbaEMTNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:13:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:6119:7652:7901:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order18_39551642f4051
X-Filterd-Recvd-Size: 1794
Message-ID: <1400008392.24350.52.camel@joe-AO725>
Subject: Re: [PATCH 1/3] FS/CODA: replace printk by pr_foo()
From: Joe Perches <joe@perches.com>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 13 May 2014 12:13:12 -0700
In-Reply-To: <20140513181629.GA24191@cs.cmu.edu>
References: <20140513184909.e5ccec32a70c2722c43c1d1e@skynet.be>
	 <20140513181629.GA24191@cs.cmu.edu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 14:16 -0400, Jan Harkes wrote:
> On Tue, May 13, 2014 at 06:49:09PM +0200, Fabian Frederick wrote:
> > No level printk converted to pr_warn or pr_info
> > 
> > Cc: Jan Harkes <jaharkes@cs.cmu.edu>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> 
> Ack, those are nice cleanups for those ugly printk's. Looks like it will
> shave off a few KB of memory too by making the strings shorter.

No.  It doesn't really.

pr_fmt prefaces the format strings with the same
content so there's no actual reduction.

One year soon, I could submit a patch that adds
a generic mechanism to printk which would get the
module name (and function name too) from kallsyms
when pr_fmt is #defined as
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
and it's actually compiled as a module.

That would reduce the format string lengths.


