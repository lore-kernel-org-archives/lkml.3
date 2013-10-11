Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3JKF6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:58:41 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:45044 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086Ab3JKF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:58:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:2904:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6691:7652:9108:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crow31_11128b8f1c758
X-Filterd-Recvd-Size: 2079
Message-ID: <1381471115.27498.6.camel@joe-AO722>
Subject: Re: [PATCH 1/2] vsprintf/sysctl: Bugfix, neaten and document %pK
 usages
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Oct 2013 22:58:35 -0700
In-Reply-To: <52579160.1090800@gmail.com>
References: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
	 <52578D37.2000004@gmail.com> <1381469910.14017.45.camel@joe-AO722>
	 <52579160.1090800@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 16:49 +1100, Ryan Mallon wrote:

> It doesn't matter what the value of kptr_restrict happens to be, the
> code is still broken. So, with your patch, values 0 and 2 of
> kptr_restrict will print a seemingly correct value, but when
> kptr_restrict is 1 then it will print 'pK-error'.

I think it's _wrong_ to break existing code.

And no, 0 and 2 will print "correct" values.

Only the relatively uncommon 1 use case is broken.
kptr_restrict is simply broken relative to interrupts.

%pK is used outside of seq and goes to dmesg too btw.
You can't simply check the process permissions at open.

> It should print 'pK-error' in all cases, so that any bugs where %pK is
> being used from interrupt content are identified regardless of the
> setting of kptr_restrict.
> 
> Anyway, with the approach that Eric and George suggested, this would
> become a non-issue. So probably just best to leave the code as is.

Or do as I did and shrink it and make it clearer
until your use cases might be implemented.


