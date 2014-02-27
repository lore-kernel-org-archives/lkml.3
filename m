Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaB0BGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:06:45 -0500
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:54188 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751989AbaB0BGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:06:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:560:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mice85_1d60d0c9cc64c
X-Filterd-Recvd-Size: 1577
Message-ID: <1393463199.24588.54.camel@joe-AO722>
Subject: Re: The sheer number of sparse warnings in the kernel
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 17:06:39 -0800
In-Reply-To: <530E8C2E.7080307@zytor.com>
References: <530E6F76.1070605@zytor.com>
	 <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 16:51 -0800, H. Peter Anvin wrote:
> On 02/26/2014 04:48 PM, Joe Perches wrote:
> > err.h could also return bool instead of long for the
> > IS_ERR and IS_ERR_OR_NULL tests.
> 
> This is definitely true... although we should check that that doesn't
> make the code worse as this is used *all over* the kernel.

I tested using arch/x86/crypto/ x86-64 and 32
and there are no .o file differences using
bool or long via objdump -d new and old

> > Maybe something like this could be useful.
> > 
> > Shut up the unsigned<->signed pointer conversions
> > and implicit conversions in the Makefile.
> 
> Sounds like two separate patches to me.

Yeah, it was just for discussion.

I think gcc 4.8 is overly noisy about those 2.


