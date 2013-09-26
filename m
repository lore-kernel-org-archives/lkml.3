Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IZPaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:30:22 -0400
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:33412 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281Ab3IZPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:30:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owl13_3ca02458d5161
X-Filterd-Recvd-Size: 1512
Message-ID: <1380209415.17366.66.camel@joe-AO722>
Subject: Re: [PATCH 3/4] SunRPC: Use no_printk() for the null dprintk() and
 dfprintk()
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: bfields@fieldses.org, Trond.Myklebust@netapp.com, olof@lixom.net,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 08:30:15 -0700
In-Reply-To: <20130926144525.29424.11130.stgit@warthog.procyon.org.uk>
References: <20130926144502.29424.21633.stgit@warthog.procyon.org.uk>
	 <20130926144525.29424.11130.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 15:45 +0100, David Howells wrote:
> Use no_printk() for the null dprintk() and dfprintk() so that the compiler
> doesn't complain about unused variables for stuff that's just printed.

no_printk doesn't prevent any argument side-effects
from being optimized away by the compiler.

ie:
	dprintk("%d", func())
func is now always called when before it wasn't.

Are there any side-effects?

btw: Using

#define dprintk(fmt, ...)
do {
	if (0)
		printk(fmt, ##__VA_ARGS__);
} while (0)

does away with side-effects.


