Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLEPY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:24:58 -0500
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:55450 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaLEPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:24:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:965:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3874:4321:4390:5007:6261:7808:9040:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13160:13229:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clam57_de20e973fa14
X-Filterd-Recvd-Size: 1479
Message-ID: <1417793094.2721.51.camel@perches.com>
Subject: Re: printf vs. printk (was Re: Side-effect free printk?)
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Julia Lawall <julia.lawall@lip6.fr>, cocci <cocci@systeme.lip6.fr>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Dec 2014 07:24:54 -0800
In-Reply-To: <20141205103248.GA6945@amd>
References: <1417629003.2902.14.camel@perches.com>
	 <20141205103248.GA6945@amd>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 11:32 +0100, Pavel Machek wrote:
> Hi!
> 
> BTW... All the time I'm programming in kernel, I use printf(), and
> when hacking userspace, I use printk().
> 
> Nasty.
> 
> Given that printf() and printk() have exactly the same behaviour,
> could we allow printf() in kernel? Now... printk()s are usually
> removed before merging the driver, so code will not see much change,
> but it will certainly result in less 4-letter words while developing.

My preference would be to eventually eliminate printk
altogether but I don't see a real problem adding 
	#define printf printk
to include/linux/printk.h

but

