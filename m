Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab3KKCXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:23:15 -0500
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:52166 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751061Ab3KKCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:22:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:7652:9108:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blow29_52b3de8c9fd09
X-Filterd-Recvd-Size: 2121
Message-ID: <1384136570.4771.5.camel@joe-AO722>
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand
 size
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        james.t.kukunas@intel.com, hpa@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Date: Sun, 10 Nov 2013 18:22:50 -0800
In-Reply-To: <52803BA2.2080908@zytor.com>
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>
	 <1384117768.3081.10.camel@joe-AO722>
	 <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>
	 <1384123457.3081.33.camel@joe-AO722> <52803BA2.2080908@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-10 at 18:06 -0800, H. Peter Anvin wrote:
> On 11/10/2013 02:44 PM, Joe Perches wrote:
> > On Sun, 2013-11-10 at 14:10 -0800, H. Peter Anvin wrote:
> >> Yes, on the generic it is int.
> >> The problem is in part that some architectures have bitop
> >> instructions with specific behavior.
> > I think that all bitop indices should be changed
> > to unsigned (int or long, probably long) for all
> > arches.
> > Is there any impediment to that?
> It is at the very best misleading.  On x86 bit indicies will be signed
> no matter what the data type says,

?

> and having an unsigned data type
> being interpreted as signed seems like really dangerous.
> On the other hand, for the generic implementation unsigned long makes sense.
> We might need a bitindex_t or something like that for it to be clean.

Is there really any reason to introduce bitindex_t?

Perhaps the current x86 bitops asm code is being conflated
with the ideal implementation?

