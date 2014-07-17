Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaGQPvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:51:31 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:56339 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757179AbaGQPv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:51:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2736:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13184:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: land69_2974d0b679d04
X-Filterd-Recvd-Size: 1850
Message-ID: <1405612283.12363.10.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, apw@canonical.com, tytso@mit.edu,
        dwalter@google.com, bp@suse.de, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 08:51:23 -0700
In-Reply-To: <1405611268-12463-1-git-send-email-richard@nod.at>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 17:34 +0200, Richard Weinberger wrote:
> checkpatch.pl is a nice tool to find issues in patches.

grep is a similar tool, just less automated.

> Sadly this tool gets more and more abused by various people to create
> style cleanups for source files within the kernel.
> In order to deal with that bad habit let's remove the --file option
> and bring checkpatch.pl back to its original purpose.

Any tool can be misused.

diff -urN /dev/null $file | ./scripts/checkpatch.pl -

does the same thing as --file so I don't see any real
fundamental difference.

I think it should really only be used in --file mode
on drivers/staging/.

I wouldn't mind adding some additional "yes, I really
mean to do this" cmd-line flag when it's used on any
file outside of staging with some additional warning
that "--file" is discouraged outside of staging when
it's not there.

But additional documentation only goes so far.


