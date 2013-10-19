Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3JSA0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:26:04 -0400
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:53963 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752904Ab3JSA0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:26:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 26,1.8,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2505:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:9010:9040:9108:10004:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13160:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knee24_345037d4bfd02
X-Filterd-Recvd-Size: 2844
Message-ID: <1382142357.2041.12.camel@joe-AO722>
Subject: Re: [bug] get_maintainer.pl incomplete output
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 18 Oct 2013 17:25:57 -0700
In-Reply-To: <alpine.DEB.2.02.1310181557020.20283@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
	 <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
	 <1382069821.22110.168.camel@joe-AO722>
	 <alpine.DEB.2.02.1310181557020.20283@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 15:58 -0700, David Rientjes wrote:
> On Thu, 17 Oct 2013, Joe Perches wrote:
> > Try this:
> > It adds authored/lines_added/lines_deleted to rolestats
> > For instance:
> > $ ./scripts/get_maintainer.pl -f mm/vmpressure.c
> > Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%,authored:3/7=43%,removed_lines:15/21=71%)
> > Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%,authored:3/7=43%,added_lines:22/408=5%,removed_lines:6/21=29%)
> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> > Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> > "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> > Anton Vorontsov <anton.vorontsov@linaro.org> (authored:1/7=14%,added_lines:374/408=92%)
> > linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> > linux-kernel@vger.kernel.org (open list)
> > 
> > I haven't tested it much.
> This looks good, thanks very much!

Oh sure, it's a trifle.

> I'm not sure how useful the 
> removed_lines stat is, but perhaps it can be useful for someone to chime 
> in if someone proposes a patch that includes support that had already been 
> removed.

The whole concept of lines +/- is kind of dubious.
Quantity really doesn't judge value.

It makes some sense for patches where new files
are added, but new files are a relatively a small
percentage of the overall kernel source tree.

Let it stew for awhile in Andrew's tree and when
-next opens up again, let's see if there are any
other comments about it.

My guess is very few people will notice.

The best mechanism is to have MAINTAINERS entries.

