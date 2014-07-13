Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaGMDKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:10:30 -0400
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:36706 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751786AbaGMDKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:10:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3351:3622:3867:3868:3871:3872:3874:4250:4321:5007:7652:7903:9010:10004:10400:10848:11026:11232:11658:11914:12114:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd29_32a5bb6f5b27
X-Filterd-Recvd-Size: 1296
Message-ID: <1405221019.9132.34.camel@joe-AO725>
Subject: Re: checkpatch.pl misses list_for_each_entry() coding style issues
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 12 Jul 2014 20:10:19 -0700
In-Reply-To: <20140712230828.GA15827@kroah.com>
References: <20140712230828.GA15827@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 16:08 -0700, Greg KH wrote:
> static int foo_init(void)
> {
> 
> 	list_for_each_entry(foo, &foo, list)
> 	{
> 		do_something_foo(foo);
> 	}
> 
> 	return 0;
> }
> 
> Will not be caught by checkpatch:
> 
> $ ./scripts/checkpatch.pl --file foo.c 
> total: 0 errors, 0 warnings, 11 lines checked
> 
> foo.c has no obvious style problems and is ready for submission.
> 
> 
> Any way to fix that up?

Probably.  Right now it only works on for/do tests.
It should probably also work on all functions.

I'll play with it.

