Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3JJXZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:25:17 -0400
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:42685 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850Ab3JJXZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:25:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3871:3872:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pull75_4a97e1aa7430e
X-Filterd-Recvd-Size: 1621
Message-ID: <1381447511.14017.24.camel@joe-AO722>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "sangjung.woo" <sangjung.woo@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Date: Thu, 10 Oct 2013 16:25:11 -0700
In-Reply-To: <20131010231851.GB14030@mtj.dyndns.org>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
	 <1381291649.2040.1.camel@joe-AO722> <5254DD64.4090205@samsung.com>
	 <1381294767.2040.5.camel@joe-AO722>
	 <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
	 <20131010231851.GB14030@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 19:18 -0400, Tejun Heo wrote:
> Do we have an
> actual cases where this makes meaningful differences?

There are already a few array allocations
where the array is completely reinitialized.

Does it matter?  Shrug.

It's more API compatible and more symmetric.

Direct conversions of kmalloc blocks don't
involve kmalloc->kzalloc translations, so
it'll be bug-for-bug compatible.

