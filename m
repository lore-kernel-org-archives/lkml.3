Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaLEHlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:41:35 -0500
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:52687 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751132AbaLEHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:41:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:7901:8603:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13156:13161:13228:13229:13255:13311:13357:14040:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane60_2a24cbd1a325a
X-Filterd-Recvd-Size: 2131
Message-ID: <1417765287.2721.39.camel@perches.com>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Date: Thu, 04 Dec 2014 23:41:27 -0800
In-Reply-To: <alpine.DEB.2.02.1412050820290.2059@localhost6.localdomain6>
References: <1417731809.2721.17.camel@perches.com>
	 <alpine.DEB.2.02.1412050820290.2059@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 08:21 +0100, Julia Lawall wrote:
> On Thu, 4 Dec 2014, Joe Perches wrote:
> > It's generally nicer to replace embedded function names
> > with "%s: ", __func__
> > 
> > 			pr_warn("%s: cipher_encrypt failed\n", __func__);
> 
> Doing so may potentially allow some strings to be shared, thus saving a 
> little space.  Perhaps not in this case, though.

It's not necessarily a code size savings in any case.

It can be, but the real benefits are stylistic
consistency and lack of mismatch between function
name and message.

If the code is refactored or copy/pasted into another
function, a moderately common defect is not modifying
the embedded function name in the message.

There may be some smallish savings if ever these
__func__ uses were converted to use %pf via some
internal standardized mechanism.

A negative to that approach is inlined functions would
take the function name of the parent not keep the
inlined function name.


