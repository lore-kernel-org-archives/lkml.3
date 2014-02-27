Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaB0Diw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:38:52 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:59947 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929AbaB0Div (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:38:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7904:8603:10004:10400:10450:10455:10848:11232:11233:11658:11914:12262:12517:12519:12663:12679:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shop58_2fd14404d7662
X-Filterd-Recvd-Size: 2549
Message-ID: <1393472326.24588.82.camel@joe-AO722>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ben Pfaff <blp@nicira.com>,
        Christopher Li <sparse@chrisli.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 19:38:46 -0800
In-Reply-To: <530EB103.5070406@zytor.com>
References: <530E6F76.1070605@zytor.com>
	 <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com>
	 <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin>
	 <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin>
	 <530EB103.5070406@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Ben Pfaff and Christopher Li)

On Wed, 2014-02-26 at 19:29 -0800, H. Peter Anvin wrote:
> On 02/26/2014 06:58 PM, Josh Triplett wrote:
> > On Wed, Feb 26, 2014 at 06:53:14PM -0800, Joe Perches wrote:
> >> Allow an override to emit or not the sizeof(bool) warning
> >> Add a description to the manpage.
> >>
> >> Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> 
> I have to admit that this particular warning is a bit odd to me.  I'm
> wondering what kind of bugs it was intended to catch.
> 
> In particular, things that incorrectly assumes the size of bool to be
> anything in particular would seem unlikely to actually use sizeof().

Dunno, the commit log for the commit that added it doesn't quite
match the code and is seemingly unaware that the c99 spec doesn't
specify sizeof(bool).

Ben Pfaff <blp@nicira.com>
Date:   Wed May 4 16:39:54 2011 -0700

    evaluate: Allow sizeof(_Bool) to succeed.
    
    Without this commit, sizeof(_Bool) provokes an error with "cannot size
    expression" because _Bool is a 1-bit type and thus not a multiple of a full
    byte in size.  But sizeof(_Bool) is valid C that should evaluate to 1, so
    this commit fixes the problem and adds a regression test.
    
    Signed-off-by: Ben Pfaff <blp@nicira.com>
    Signed-off-by: Christopher Li <sparse@chrisli.org>


