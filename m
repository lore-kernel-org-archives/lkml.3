Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3KFUHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:07:38 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:37140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755017Ab3KFUHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:07:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:4384:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glue03_422727ffc0d07
X-Filterd-Recvd-Size: 1913
Message-ID: <1383768458.7940.33.camel@joe-AO722>
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Wed, 06 Nov 2013 12:07:38 -0800
In-Reply-To: <20131106200204.GB11415@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
	 <20131106153429.GA26336@redhat.com>
	 <20131106155445.GB6357@neilslaptop.think-freely.org>
	 <1383758363.7940.19.camel@joe-AO722>
	 <20131106200204.GB11415@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 15:02 -0500, Neil Horman wrote:
> On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
[]
> > __always_inline instead of inline
> > static __always_inline void prefetch_lines(const void *addr, size_t len)
> > {
> > 	const void *end = addr + len;
> > ...
> > 
> > buff doesn't need a void * cast in prefetch_lines
> > 
> Actually I take back what I said here, we do need the cast, not for a conversion
> from unsigned char * to void *, but rather to discard the const qualifier
> without making the compiler complain.

Not if the function is changed to const void *
and end is also const void * as shown.


