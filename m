Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbbAKEz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:55:26 -0500
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:35105 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089AbbAKEzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:55:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:6261:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: curve19_11eceebafb832
X-Filterd-Recvd-Size: 1773
Message-ID: <1420952121.32288.1.camel@perches.com>
Subject: Re: [PATCH] staging: unisys: Convert direct LOGERR uses to pr_err
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 10 Jan 2015 20:55:21 -0800
In-Reply-To: <20150111041319.GB22334@kroah.com>
References: <1420945742.16787.12.camel@perches.com>
	 <20150111041319.GB22334@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-10 at 20:13 -0800, Greg Kroah-Hartman wrote:
> On Sat, Jan 10, 2015 at 07:09:02PM -0800, Joe Perches wrote:
> > Use the normal logging facility instead of a new macro.
> > 
> > Miscellanea:
> > 
> > o Realign arguments
> > o Remove unnecessary alloc error messages as alloc failures
> >   already emits a generic OOM message with a dump_stack
> > o Add missing newlines to these messages to avoid interleaving
> > o Spelling/typo fixes in those messages
[]
> I rejected the other patch that did much this same thing, almost all of
> these should be converted to use dev_* calls instead of pr_* calls, as
> this is a driver, and drivers should always have access to a struct
> device.  If not, they need to be fixed.

Baby steps.

This one prevents interleaving
and fixes typos.


