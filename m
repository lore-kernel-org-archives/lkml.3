Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaJOTpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:45:52 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:57026 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059AbaJOTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:45:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3874:4321:5007:6119:6261:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kite84_32f37a0032526
X-Filterd-Recvd-Size: 1820
Message-ID: <1413402348.7484.8.camel@perches.com>
Subject: Re: [PATCH 2/3] checkpatch: Add error on use of attribute((weak))
 or __weak
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 12:45:48 -0700
In-Reply-To: <20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
References: <cover.1413400022.git.joe@perches.com>
	 <4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
	 <20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 12:42 -0700, Andrew Morton wrote:
> On Wed, 15 Oct 2014 12:32:08 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Using weak can have unintended link defects.
> > Emit an error on its use.
> 
> Well, we don't want a warning about use of __weak in function
> definitions.  Only in declarations.

Why is that?

> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -4671,6 +4671,14 @@ sub process {
> >  			}
> >  		}
> >  
> > +# Check for __attribute__ weak, or __weak (may have link issues)
> > +		if ($realfile !~ m@\binclude/uapi/@ &&
> 
> And this bit maybe is checking for use in a header file, which is not
> as good as checking for a declaration but is probably good enough. 
> However the "uapi" bit is confusing.
> 
> Can we have a better changelog please?

Suggestions?

