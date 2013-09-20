Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3ITBHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:07:14 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:40875 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751604Ab3ITBHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:07:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: title65_214c70dc31124
X-Filterd-Recvd-Size: 2076
Message-ID: <1379639226.5862.9.camel@joe-AO722>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
From: Joe Perches <joe@perches.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: David Howells <dhowells@redhat.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Date: Thu, 19 Sep 2013 18:07:06 -0700
In-Reply-To: <523A5316.50405@att.net>
References: <1379482610.1787.7.camel@joe-AO722>
	 <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
	 <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
	 <22238.1379502295@warthog.procyon.org.uk> <523A5316.50405@att.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 20:27 -0500, Daniel Santos wrote:
> if I use ERR_PTR() on a signed int on a x86_64 where pointer 
> is 64 bits and int is 32, wouldn't that mean a signed conversion 
> instruction where the sign bit has to be moved from bit 31 to 63?

No.  It's cast to long

static inline void * __must_check ERR_PTR(long error)
{
	return (void *) error;
}

> Either way, %pE does seem to make a lot of sense for conditions where we 
> already have a pointer that we would otherwise use PTR_ERR() to convert, 
> but it just seems klunky to use it on an int, to have it treated like a 
> pointer and then re-interpreted as an int.  Maybe we can add %pE as well 
> as %dE and leave [ioxXu] out of it?

I think having just one way to format is better.


