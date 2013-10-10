Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3JJXOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:14:47 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:58355 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850Ab3JJXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:14:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4385:5007:6119:7652:7903:9025:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13163:13229:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,M
X-HE-Tag: uncle16_7a8be7661415e
X-Filterd-Recvd-Size: 2001
Message-ID: <1381446840.14017.21.camel@joe-AO722>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "sangjung.woo" <sangjung.woo@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>
Date: Thu, 10 Oct 2013 16:14:00 -0700
In-Reply-To: <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
	 <1381291649.2040.1.camel@joe-AO722> <5254DD64.4090205@samsung.com>
	 <1381294767.2040.5.camel@joe-AO722>
	 <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 16:06 -0700, Andrew Morton wrote:
> On Tue, 08 Oct 2013 21:59:27 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > I was a bit surprised to find there isn't a devm_kmalloc.
> 
> Yes, the unconditional memset is silly.  Especially when the
> function has a handy gfp_t and could be passed __GFP_ZERO.
> 
> The comment says "managed kzalloc/kfree for device drivers, no kmalloc,
> always use kzalloc".  There's no explanation for this - it looks like
> some ideological thing.

Try this patch instead:
https://lkml.org/lkml/2013/10/9/14

Yours has an unnecessary duplicate memset of the whole
block when __GFP_ZERO is passed when that's already
done by the kmalloc_track_caller allocator.

Also if __GFP_ZERO is not passed, you should still
zero the struct devres header.


