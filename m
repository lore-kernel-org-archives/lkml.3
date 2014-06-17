Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbaFQUFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:05:45 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:44708 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933313AbaFQUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:05:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:965:966:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3873:3874:4321:4385:4390:4395:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd26_4eb6cfebd3f49
X-Filterd-Recvd-Size: 1314
Message-ID: <1403035539.2722.3.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree test
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>
Date: Tue, 17 Jun 2014 13:05:39 -0700
In-Reply-To: <1403034199-9824-1-git-send-email-fabf@skynet.be>
References: <1403034199-9824-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 21:43 +0200, Fabian Frederick wrote:
> This patch adds a trivial script warning on
> 
> if(foo)
> 	kfree(foo)
> 
> (based on checkpatch)
[]
> diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
[]
> +* if (E)
> +*	kfree@p(E);

You should probably add all of the unnecessary
conditional tests that checkpatch uses:

kfree
usb_free_urb
debugfs_remove
debugfs_remove_recursive


