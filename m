Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaDKSBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:01:55 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:47360 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbaDKSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:01:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4605:5007:7652:8531:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: geese00_2d5f977850b04
X-Filterd-Recvd-Size: 1725
Message-ID: <1397239310.7113.35.camel@joe-AO722>
Subject: Re: [PATCH 1/3] sched,numa: count pages on active node as local
From: Joe Perches <joe@perches.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com, mgorman@suse.de
Date: Fri, 11 Apr 2014 11:01:50 -0700
In-Reply-To: <53482953.3070201@redhat.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
	 <1397235629-16328-2-git-send-email-riel@redhat.com>
	 <1397237673.7113.22.camel@joe-AO722> <53482953.3070201@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 13:41 -0400, Rik van Riel wrote:
> On 04/11/2014 01:34 PM, Joe Perches wrote:
> > On Fri, 2014-04-11 at 13:00 -0400, riel@redhat.com wrote:
> >> This should reduce the overhead of the automatic NUMA placement
> >> code, when a workload spans multiple NUMA nodes.
[]
> > Perhaps local would look nicer as bool
> > and be better placed next to migrated.
> 
> The problem is, at the end of the function, local is used as an
> array index...

Oh, thanks.

>         p->numa_faults_locality[local] += pages;
> 
> I'm not sure I really want to use a bool as an array index :)

Nor I particularly but using bool as an array index is
already done in at least kernel/workqueue.c and
kernel/trace/blktrace.c

Doesn't make it right of course.

