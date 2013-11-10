Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3KJVJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 16:09:35 -0500
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:41651 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752061Ab3KJVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 16:09:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:6119:7652:7903:8603:10004:10400:10848:11232:11658:11914:12043:12048:12438:12517:12519:12555:12679:12740:13069:13149:13200:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jewel77_6f86371847031
X-Filterd-Recvd-Size: 1862
Message-ID: <1384117768.3081.10.camel@joe-AO722>
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand
 size
From: Joe Perches <joe@perches.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, james.t.kukunas@intel.com, hpa@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Date: Sun, 10 Nov 2013 13:09:28 -0800
In-Reply-To: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 18:15 -0700, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  9b710506a03b01a9fdd83962912bc9d8237b82e8
[]
> x86, bitops: Change bitops to be native operand size
> 
> Change the bitops operation to be naturally "long", i.e. 63 bits on
> the 64-bit kernel.  Additional bugs are likely to crop up in the
> future.

> We already have bugs which machines with > 16 TiB of memory in a
> single node, as can happen if memory is interleaved.  The x86 bitop
> operations take a signed index, so using an unsigned type is not an
> option.

I think it odd that any bitop index nr should be
anything other than unsigned long for any arch.

Why should this arch be any different than the
defined type in Documentation/atomic_ops.txt?

What value is a negative index when the bitmap
array address passed is the starting 0th bit?

btw: asm-generic/bitops.h doesn't match
Documentation/atomic_ops.txt either.


