Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaB0CJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:09:35 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:56955 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754478AbaB0CJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:09:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:560:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:4250:4321:5007:6119:7652:7903:8603:10004:10400:10450:10455:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: unit06_8d9450b1b0603
X-Filterd-Recvd-Size: 1510
Message-ID: <1393466971.24588.69.camel@joe-AO722>
Subject: Re: The sheer number of sparse warnings in the kernel
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 18:09:31 -0800
In-Reply-To: <20140227013424.GA9991@kroah.com>
References: <530E6F76.1070605@zytor.com> <20140226232859.GA9213@kroah.com>
	 <530E82B2.3040305@zytor.com> <20140227013424.GA9991@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 17:34 -0800, Greg KH wrote:
> On Wed, Feb 26, 2014 at 04:11:30PM -0800, H. Peter Anvin wrote:
> > I have seen this phenomenon, too.  I also see a bunch of sparse warnings
> > which are clearly bogus, for example complaining about sizeof(bool) when
> > in bits like:
> > 
> > 		__this_cpu_write(swallow_nmi, false);
[]
> I guess the first thing would be to do is look to try to fix things like
> the "bool" issue you have here.

I wonder what the "fix" would be as by standard
_Bool doesn't have a defined size.

Probably another sparse -Wno-sizeof-bool flag.
(just added and submitted)

