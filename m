Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaAKCQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 21:16:00 -0500
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:49665 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751263AbaAKCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 21:15:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3871:3874:4041:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12533:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade82_50d72b72c7750
X-Filterd-Recvd-Size: 1602
Message-ID: <1389406553.2537.52.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, pavel@ucw.cz, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Fri, 10 Jan 2014 18:15:53 -0800
In-Reply-To: <201401111059.HCH39012.MFtVHFOFQOLOJS@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	 <20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
	 <201401111059.HCH39012.MFtVHFOFQOLOJS@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 10:59 +0900, Tetsuo Handa wrote:
> I just added noinline_for_stack as with other functions does.
> But indeed, stack used by name[] is only 16 bytes but stack used by function
> arguments are larger than 16 bytes. We should remove noinline_for_stack ?

My recollection is that certain gcc versions don't do
well with multiple inline functions that have stack
variables.

Instead of collapsing the variables, gcc will
accumulate the stack depth of all the inlines
args instead of reusing the stack.


