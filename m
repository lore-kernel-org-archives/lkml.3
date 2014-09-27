Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaI0E66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 00:58:58 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:36147 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750781AbaI0E65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 00:58:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:965:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:2903:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4041:4321:4390:4605:4823:5007:6119:7652:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: snow52_88129646e6931
X-Filterd-Recvd-Size: 2973
Message-ID: <1411793932.21874.10.camel@joe-AO725>
Subject: Re: [OPW kernel] checkpatch: Does anyone care that comments are
 freeform aligned?
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>,
        tapaswenipathak@gmail.com, opw-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>
Date: Fri, 26 Sep 2014 21:58:52 -0700
In-Reply-To: <20140926230314.GN20632@cloud>
References: <alpine.DEB.2.02.1409240745160.2051@localhost6.localdomain6>
	 <1411584074.3594.17.camel@joe-AO725> <20140926230314.GN20632@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 16:03 -0700, josh@joshtriplett.org wrote:
> On Wed, Sep 24, 2014 at 11:41:14AM -0700, Joe Perches wrote:
> > On Wed, 2014-09-24 at 07:47 +0200, Julia Lawall wrote:
> > > In the following patch extract, one line is indented with spaces rather 
> > > than tabs.  Is it intentional that checkpatch doesn't complain about this, 
> > > I guess due to the line being a comment?
> > []
> > >  struct bcm_hdr_suppression_contextinfo {
> > > -	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
> > > -	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
> > > +    /* Intermediate buffer to accumulate pkt Header for PHS */
> > > +	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS];
> > > +	/* Intermediate buffer containing pkt Header after PHS */
> > > +	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN];
> > >  };
> > 
> > checkpatch does not care when comments start in any
> > particular position or ensure comments have tabs
> > preceding them.
> > 
> > Does anyone care?
> 
> This should have already been caught by other whitespace checks that
> check for indentations of 8 or more spaces.  Similarly, mixed tab/space
> indentations would get caught by those same checks.

Yes and no.

Leading whitespace over 8 chars would (ie: "^ {8,}" is a warning)
but a statement like:

	int foo;                    	/* some comment */
[tab]	            [20 spaces]     [tab]

would not.

> I don't think checkpatch needs to check those.

For the most part, I agree.

On Fri, 2014-09-26 at 16:06 -0700, josh@joshtriplett.org wrote:
> Lines starting with at least 8 spaces before a comment: 
> $ git grep -E '^ {8,}/\*' | wc -l
> 1544
> 
> I think just about all of those are bugs.

Maybe.

Most of those are from Linus' first git commit.


