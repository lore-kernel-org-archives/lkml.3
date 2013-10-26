Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3JZT3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 15:29:25 -0400
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:59641 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753627Ab3JZT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 15:29:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3874:4321:4605:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bun16_6b7326bb3cc2d
X-Filterd-Recvd-Size: 1478
Message-ID: <1382815736.3238.10.camel@joe-AO722>
Subject: Re: [PATCH] atmusb: Fix dynamic_debug macros
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sat, 26 Oct 2013 12:28:56 -0700
In-Reply-To: <1382813729.3238.8.camel@joe-AO722>
References: <20131026132955.GA9251@shrek.podlesie.net>
	 <20131026173730.GA18320@kroah.com> <1382813729.3238.8.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 11:55 -0700, Joe Perches wrote:
> Fix use of atm_dbg to all normal pr_debug not dynamic_pr_debug
> because dynamic_pr_debug may not be compiled in at all.

Greg, please don't apply this one.
I'll resubmit one that actually works.

(the arg...) should be ...

> +#define atm_dbg(instance, format, arg...)				\
                                     ^ oops.

> +#define atm_rldbg(instance, format, arg...)				\
> +	pr_debug_ratelimited("ATM dev %d: " format,			\
> +			     (instance)->atm_dev->number, ##__VA_ARGS__)

here too.


