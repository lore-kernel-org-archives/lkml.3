Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaGUO2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:28:55 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:45762 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932270AbaGUO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:28:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3872:3873:3874:4321:5007:7652:8531:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12679:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rose38_876f4bdc65559
X-Filterd-Recvd-Size: 1370
Message-ID: <1405952929.27900.7.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Allow case labels with ranges
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 21 Jul 2014 07:28:49 -0700
In-Reply-To: <20140721132116.GZ30888@lee--X1>
References: <20140721113948.GX30888@lee--X1>
	 <1405948406.21586.10.camel@joe-AO725> <20140721132116.GZ30888@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 14:21 +0100, Lee Jones wrote:
> On Mon, 21 Jul 2014, Joe Perches wrote:
> > The MISSING_BREAK / fallthrough test does not support
> > gcc's extension for case labels with ranges.
[]
> Yep, that's much worse [1] - I wish I never mentioned it. ;)

I'm glad you did actually.

The code itself:

bool foo(int bar)
{
	case (bar) {
	case 1:
	case 2:
	case 4:
		return true;
	default:
		return false;
}

should not emit any error.

I'll fix it soon.

