Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaF2JeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:34:04 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:45521 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752383AbaF2JeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:34:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2375:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3871:3872:3873:4321:5007:7652:10004:10400:10848:10967:11232:11658:11914:12050:12517:12519:12663:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bait68_400f3ff106105
X-Filterd-Recvd-Size: 1846
Message-ID: <1404034438.9064.55.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: update kmalloc_array/kcalloc
 conversion warning
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 29 Jun 2014 02:33:58 -0700
In-Reply-To: <20140629112156.6a14ad3599a016a1c05c4771@skynet.be>
References: <1403899823-4461-1-git-send-email-fabf@skynet.be>
	 <1403905024.9064.16.camel@joe-AO725>
	 <20140629112156.6a14ad3599a016a1c05c4771@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-29 at 11:21 +0200, Fabian Frederick wrote:
> On Fri, 27 Jun 2014 14:37:04 -0700 Joe Perches <joe@perches.com> wrote:
[]
> > I'm not sure of the value of this as I think at some point
> > if not already today, the compiler will optimize the multiply
> > away.
> > 
> > But it's probably better to look at the non-sizeof variable
> > and emit the warning only when it's not $Constant or some
> > upper-case only macro #define like "\b[A-Z_]+\b" is used.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > +			}
> > +			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
> > +			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_]+$/)) {

This last test should be

/^[A-Z_][A-Z0-9_]*$/

to allow upper case macros with digits too

> Already tested ? If not I can do it and give you some feedback ...

Lightly.  Test away.


