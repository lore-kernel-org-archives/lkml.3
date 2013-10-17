Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3JQEga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 00:36:30 -0400
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:41104 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab3JQEg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 00:36:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2198:2199:2200:2393:2553:2559:2562:2739:2828:2916:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4041:4321:5007:7652:7875:7903:9010:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: linen64_557b92ff2b43d
X-Filterd-Recvd-Size: 3520
Message-ID: <1381984585.22110.92.camel@joe-AO722>
Subject: Re: [bug] get_maintainer.pl incomplete output
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 16 Oct 2013 21:36:25 -0700
In-Reply-To: <alpine.DEB.2.02.1310162117140.2453@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
	 <1381982635.22110.84.camel@joe-AO722>
	 <alpine.DEB.2.02.1310162117140.2453@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 21:19 -0700, David Rientjes wrote:
> On Wed, 16 Oct 2013, Joe Perches wrote:
> 
> > > I haven't looked closely at scripts/get_maintainer.pl, but I recently 
> > > wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
> > > author, Anton Vorontsov <anton.vorontsov@linaro.org>.
> > > 
> > > Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
> > > missing and git blame attributs >90% of the lines to his authorship.
> > > 
> > > $ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
> > > Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
> > > Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
> > > Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> > > Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> > > "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> > > linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> > > linux-kernel@vger.kernel.org (open list)
> > > 
> > > Any ideas?
> > 
> > get_maintainer has a lot of options.
> > 
> > get_maintainer tries to find people that are either
> > listed in the MAINTAINERS file or that have recently
> > (in the last year by default) worked on the file.
> > 
> > If you want to find all authors, use the --git-blame option
> > 
> > It's not the default because it can take quite awhile to run.
> > 
> 
> Hmm, it's a little strange to only consider recent activity when >90% of 
> the lines were written by someone not listed.  Isn't there any faster way 
> to determine that besides using the expensive git blame?

Not so far as I know.

> Something like 
> weighing the output of "git show --shortstat" for all commits in "git log 
> mm/vmpressure.c" to determine the most important recent changes?  That 
> should be fairly cheap.

Important can be hard to determine.

git blame effectively does a --follow

get_maintainers already does a git log <file>
and accumulates all the signatures for the
time selected by --git-since

It doesn't weight each commit by +/- count.

I think the most significant negative to
the current get_maintainer is that only the
"signature" lines are considered.

The "Author:" line isn't.

The default ris for get_maintainer to only list
a maximum of 5 "maintainers" ordered by signature
count.

Anton has only signed/acked 1.


