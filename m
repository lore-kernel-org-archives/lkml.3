Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaKZWiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:38:51 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:47284 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752651AbaKZWiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:38:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3872:3874:4321:4385:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan48_4cc51f2b2764d
X-Filterd-Recvd-Size: 1509
Message-ID: <1417041526.16355.7.camel@perches.com>
Subject: Re: [patch] fs, seq_file: fallback to vmalloc instead of oom kill
 processes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Wed, 26 Nov 2014 14:38:46 -0800
In-Reply-To: <20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
References: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com>
	 <20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 14:24 -0800, Andrew Morton wrote:
> There are eleventy billion places where we do the open coded
> kmalloc-or-vmalloc thing.  Sigh.  Perhaps it is time to add a helper
> function which does this, so that all such callers use
> __GFP_NO_OOM_KILL.

That would go along nicely with kvfree() in mm/util.c

void kvfree(const void *addr)
{
	if (is_vmalloc_addr(addr))
		vfree(addr);
	else
		kfree(addr);
}
EXPORT_SYMBOL(kvfree);


