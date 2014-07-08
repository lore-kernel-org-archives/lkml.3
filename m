Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaGHU5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:57:51 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:39689 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845AbaGHU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:57:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:7903:8985:9025:10004:10400:10450:10455:10848:10967:11232:11658:11854:11914:12043:12517:12519:12740:13069:13255:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skirt57_9bcdd0e31e25
X-Filterd-Recvd-Size: 2344
Message-ID: <1404853064.932.49.camel@joe-AO725>
Subject: Re: [PATCH 2/2] checkpatch: Add ability to insert and delete lines
 to patch/file
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 13:57:44 -0700
In-Reply-To: <20140708132409.625c8c90c49b9db9efe6eb8d@linux-foundation.org>
References: <cover.1404840958.git.joe@perches.com>
	 <678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
	 <20140708132409.625c8c90c49b9db9efe6eb8d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 13:24 -0700, Andrew Morton wrote:
> On Tue,  8 Jul 2014 10:53:36 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > This can be valuable to insert or delete blank lines as well
> > as fix misplaced brace or else uses.
> 
> hm, do we really want to go down this path?

Maybe, maybe not.

I've seen a lot of patches that people seem to spend
time producing (frequently incorrectly done too) that
could be better automated.

> It's a very long one and it leads to /usr/bin/indent?

For now, I think it's a pretty minimal bit of code.

I think most of the formatting suggestions emitted by
checkpatch are maybe a bit more sensible than indent.

indent makes crappy decisions about line length and
argument wrapping, comment location, and other things.

checkpatch doesn't (and I won't make it) even try.

checkpatch's --fix option hasn't been taken up very
widely.  (not yet?, not ever?  dunno)

I've suggested Lindent be removed from the tree.
https://lkml.org/lkml/2013/2/11/390

I once suggested a template script that uses individual
--fix options to try to make it easier to clean up files.

https://lkml.org/lkml/2013/9/23/504

Maybe that could be used to supplement or replace Lindent.

