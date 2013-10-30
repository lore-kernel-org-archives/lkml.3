Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3J3BFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:05:50 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:60616 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751086Ab3J3BFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:05:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3874:4321:5007:7652:10004:10400:10848:11658:11914:12517:12519:12679:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake14_1541c9c5e0c5a
X-Filterd-Recvd-Size: 1491
Message-ID: <1383095144.12439.41.camel@joe-AO722>
Subject: Re: [PATCH 1/2] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
From: Joe Perches <joe@perches.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
Date: Tue, 29 Oct 2013 18:05:44 -0700
In-Reply-To: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 01:40 +0100, Peter Huewe wrote:
> strcmp does return the difference between two strings not only -1,0,1
> consequently
>  if (strcmp (a,b) == -1)
> might lead to taking the wrong branch
> 
> -> compare with <= instead.

lib/string.c:strcmp returns only -1,0,1
so that's what the arch versions should do too.
However, arch implementations do vary...

fyi: using
	if (strcmp(foo, bar) < 0)
is canonical.

There are no existing <= -1 uses.


