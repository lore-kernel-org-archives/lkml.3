Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaKEX0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:26:40 -0500
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:52223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbaKEX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:26:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:6261:7576:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12295:12296:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: duck08_90f02f9200f17
X-Filterd-Recvd-Size: 2467
Message-ID: <1415229994.6634.35.camel@perches.com>
Subject: Re: [PATCH 3/8] netfilter: Convert print_tuple functions to return
 void
From: Joe Perches <joe@perches.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Wed, 05 Nov 2014 15:26:34 -0800
In-Reply-To: <20141105232314.GA3195@salvia>
References: <20141105192426.348510548@goodmis.org>
	 <20141105192544.214361386@goodmis.org> <20141105232314.GA3195@salvia>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 00:23 +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 05, 2014 at 02:24:29PM -0500, Steven Rostedt wrote:
> > From: Joe Perches <joe@perches.com>
> > 
> > Since adding a new function to seq_file (seq_has_overflowed())
> > there isn't any value for functions called from seq_show to
> > return anything.   Remove the int returns of the various
> > print_tuple/<foo>_print_tuple functions.
[]
> I replied to this yesterday, but it seems some spam filter also
> munched it. One comment below.
> 
> > @@ -202,9 +203,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
> >  	if (l4proto->print_conntrack)
> >  		l4proto->print_conntrack(s, ct);
> >  
> > -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > -			l3proto, l4proto))
> > -		goto release;
> > +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> > +		    l3proto, l4proto);
> >  
> >  	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
> >  		goto release;
> 
> seq_print_acct returns seq_printf which is now void. I guess you have
> to remove this check too.

seq_printf shouldn't be void yet.
There are still other places that need conversion.

> >  	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
> >  		goto release;
> 
> And here.

Eventually I trust it will be fixed, but these
patches are an intermediate step on the way there.


