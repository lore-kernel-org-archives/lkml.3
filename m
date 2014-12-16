Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaLPAvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:51:05 -0500
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:50506 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751206AbaLPAvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:51:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6261:10004:10400:10848:11232:11658:11914:12296:12517:12519:12555:12679:12740:13069:13255:13311:13357:13870:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rake55_8820f15aa301
X-Filterd-Recvd-Size: 1882
Message-ID: <1418691057.2674.26.camel@perches.com>
Subject: Re: [PATCH] checkpatch giving bogus advice (was staging: goldfish:
 Fix minor coding style)
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jeremiah Mahler <jmmahler@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, jun.j.tian@intel.com,
        linux-kernel@vger.kernel.org, octavian.purdila@intel.com,
        apw@canonical.com, nnk@google.com, alan@linux.intel.com
Date: Mon, 15 Dec 2014 16:50:57 -0800
In-Reply-To: <20141215115956.GD4856@mwanda>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
	 <20141213175518.GA28616@hudson.localdomain> <20141213182238.GA6979@iron>
	 <20141213194647.GA30065@hudson.localdomain>
	 <20141215114421.7389d32a@lxorguk.ukuu.org.uk>
	 <20141215115956.GD4856@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 14:59 +0300, Dan Carpenter wrote:
> I prefer !foo because it is more common in the kernel and I think it's
> easier to read but I don't feel strongly about this.

Me too.  But I do prefer consistency.

fyi: for variants of:

	"if (!foo)"
vs
	"if (foo == NULL)"

a little cocci script shows a preference for "if (!foo)"
of >5:1 in drivers/net/
(actual: 11557:2145)
and a little less (>3:1) in net/
(actual: 10263:3045)

$ cat pointer_style.cocci
@@
type T;
T *a;
@@

*	a == NULL

@@
type T;
T *a;
@@

*	a != NULL

@@
type T;
T *a;
@@

*	!a


