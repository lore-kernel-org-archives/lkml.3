Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3IIELi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:11:38 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:42270 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663Ab3IIELg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:11:36 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 00:11:36 EDT
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2197:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4385:5007:7652:10011:10400:10848:11232:11658:11914:12346:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: force45_2c0754f2f670b
X-Filterd-Recvd-Size: 2232
Message-ID: <1378699300.1928.1.camel@joe-AO722>
Subject: Re: [PATCH] kernel-doc: Update script to find more "Return:"
 sections
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Date: Sun, 08 Sep 2013 21:01:40 -0700
In-Reply-To: <1378688750.8385.5@driftwood>
References: <1378688750.8385.5@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-08 at 20:05 -0500, Rob Landley wrote:
> On 09/03/2013 07:34:28 PM, Joe Perches wrote:
> > Many kernel-doc return description sections headers
> > use variants of the "Return:" section prefix.
> > 
> > (some or maybe even most of these aren't in
> >  kernel-doc sections, but many are)
> > 
> > $ git grep -E -i "^\s*\*\s*return[s]?:"| \
> >   cut -f2- -d":" | awk '{print $1 $2}' | \
> >   sort | uniq -c
> >     121 *return:
> >     838 *Return:
> >     778 *RETURN:
> >     191 *returns:
> >    1965 *Returns:
> >     603 *RETURNS:
> > 
> > Rather than change all of the variants to the
> > canonical "Return:", adapt the script to accept
> > case insensitive "Return:" and "Returns:"
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> > 
> > I don't know that this actually works.
> > It does seem right though.
> > 
> > Randy?  Rob?  Can you test this please?
> 
> I stopped reading this file at the line "#!/usr/bin/perl -w", but I'm  
> not sure if this is the right approach. Something that finds these and  
> lets us patch them to the cannonical version might be more appropriate.

~3500 different lines to patch is a lot.

> Or are you going to add similar fuzzy matching for all the other  
> keywords?

What other keywords are there that are not freeform?

The only other style I know of is @arg:

