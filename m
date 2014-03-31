Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaCaSoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:44:19 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:43190 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287AbaCaSoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:44:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2538:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3872:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skate66_407da402cfd3c
X-Filterd-Recvd-Size: 1666
Message-ID: <1396291441.21529.52.camel@joe-AO722>
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 31 Mar 2014 11:44:01 -0700
In-Reply-To: <alpine.DEB.2.10.1403311334060.3313@nuc>
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
	 <1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
	 <alpine.DEB.2.10.1403311334060.3313@nuc>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 13:35 -0500, Christoph Lameter wrote:
> On Thu, 27 Mar 2014, Mitchel Humpherys wrote:
> 
> > diff --git a/mm/slub.c b/mm/slub.c
[]
> > @@ -9,6 +9,8 @@
> >   * (C) 2011 Linux Foundation, Christoph Lameter
> >   */
> >
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> This is implicitly used by some macros? If so then please define this
> elsewhere. I do not see any use in slub.c of this one.

Hi Christoph

All the pr_<level> macros use it.

from include/linux/printk.h:

#ifndef pr_fmt
#define pr_fmt(fmt) fmt
#endif

#define pr_emerg(fmt, ...) \
	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)

etc...


