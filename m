Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaCVS4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:56:46 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:45824 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751465AbaCVS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:56:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:6119:6120:7652:10004:10400:10848:10967:11232:11658:11914:12043:12296:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plot00_56f1b383ba72c
X-Filterd-Recvd-Size: 2500
Message-ID: <1395514595.3667.10.camel@joe-AO722>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, David Rientjes <rientjes@google.com>
Date: Sat, 22 Mar 2014 11:56:35 -0700
In-Reply-To: <20140322105524.7baec73a.akpm@linux-foundation.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	 <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
	 <20140322170322.GA23583@thunk.org>
	 <20140322101512.eaeb542b.akpm@linux-foundation.org>
	 <20140322172606.GB23583@thunk.org> <20140322173207.GC23583@thunk.org>
	 <20140322105524.7baec73a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 10:55 -0700, Andrew Morton wrote:
> On Sat, 22 Mar 2014 13:32:07 -0400 tytso@mit.edu wrote:
> 
> > On Sat, Mar 22, 2014 at 01:26:06PM -0400, tytso@MIT.EDU wrote:
> > > > Well.  Converting an existing retry-for-ever caller to GFP_NOFAIL is
> > > > good.  Adding new retry-for-ever code is not good.
> > 
> > Oh, and BTW --- now that checkpatch.pl now flags an warning whenever
> > GFP_NOFAIL is used
> 
> I don't know what the basis for this NOFAIL-is-going-away theory could
> have been.  What's the point in taking a centrally implemented piece of
> logic and splattering its implementation out to tens of different
> callsites?
[]
> diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-__gfp_nofail-isnt-going-away scripts/checkpatch.pl
[]
> @@ -4240,12 +4240,6 @@ sub process {
>  			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
>  		}
>  
> -# check for GFP_NOWAIT use
> -		if ($line =~ /\b__GFP_NOFAIL\b/) {
> -			WARN("__GFP_NOFAIL",
> -			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
> -		}

How about just changing this message to something like:

			WARN("__GFP_NOFAIL",
			     "Use of __GFP_NOFAIL may cause the OOM handler to kill a random process\n" . $herecurr);


