Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537Ab3JQTYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:24:01 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:33595 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762469Ab3JQTYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:24:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:7903:9010:10004:10400:10429:10430:10431:10848:10967:11232:11658:11914:12517:12519:12740:13069:13072:13311:13357:19903:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: value06_79cd3f9164421
X-Filterd-Recvd-Size: 2951
Message-ID: <1382037835.22110.137.camel@joe-AO722>
Subject: Re: [bug] get_maintainer.pl incomplete output
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 17 Oct 2013 12:23:55 -0700
In-Reply-To: <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
	 <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 12:12 -0700, Andrew Morton wrote:
> On Wed, 16 Oct 2013 20:51:18 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > I haven't looked closely at scripts/get_maintainer.pl, but I recently 
> > wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
> > author, Anton Vorontsov <anton.vorontsov@linaro.org>.
> > 
> > Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
> > missing and git blame attributs >90% of the lines to his authorship.
> > 
> > $ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
> > Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
> > Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> > Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> > "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> > linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> > linux-kernel@vger.kernel.org (open list)
> 
> get_maintainer should, by default, answer the question "who should I
> email about this file".  It clearly isn't doing this, and that's a
> pretty big fail.

I disagree.

It's decidedly good at doing precisely that when a
MAINTAINERS entry exists.

When no one is a listed maintainer, the results
can certainly be tweaked to be better.

> I've learned not to trust it, so when I use it I always have to check
> its homework with "git log | grep Author" :(
> 
> Joe, pretty please?

It's really a question of "how long ago is too long ago" as
older commits way too often also show old/invalid email
addresses.

I also don't want to wait over 30 seconds or so to find out
who is listed as a git signer/author by default.

Adding the commit listed "Author:" as a signer doesn't seem
too hard though.  I'll play with that.

