Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaFZEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 00:16:56 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:48491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750721AbaFZEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 00:16:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1362:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2828:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:7652:7903:7974:8957:9010:9121:9149:9163:10004:10226:10400:10848:11026:11232:11658:11876:11914:12043:12294:12438:12517:12519:12555:12663:12740:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: arch99_1efdeeebf8838
X-Filterd-Recvd-Size: 3391
Message-ID: <1403756211.7977.22.camel@joe-AO725>
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 21:16:51 -0700
In-Reply-To: <20140626034430.GA22836@thin>
References: <20140625154629.GA21519@thin>
	 <1403741107.28663.9.camel@joe-AO725> <20140626022448.GA22091@thin>
	 <1403749983.7977.6.camel@joe-AO725> <20140626034430.GA22836@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 20:44 -0700, Josh Triplett wrote:
> On Wed, Jun 25, 2014 at 07:33:03PM -0700, Joe Perches wrote:
> > On Wed, 2014-06-25 at 19:24 -0700, Josh Triplett wrote:
> > > On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > > > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > > > Regardless of the long-standing debate over line width, checkpatch
> > > > > should not warn about it by default.
> > > > 
> > > > I'm not getting involved here.
> > > > I don't care much one way or another.
> > []
> > > I'm not asking you to get involved in the Great Line Length Debate;
> > > that's why I didn't attempt to patch CodingStyle or similar.  However, I
> > > think it makes sense for *checkpatch* to stop emitting this warning.
> > 
> > I think checkpatch should encourage people to write code in
> > a style that matches CodingStyle as well as the predominant
> > styles used in the rest of the kernel.
> 
> Not arguing with that, but in this particular case the warning seems
> counterproductive to that goal, especially compared to the
> DEEP_INDENTATION warning.  More subjective or "to taste" issues tend
> to have lower severity in checkpatch.  And CodingStyle *already* says
> "unless exceeding 80 columns significantly increases
> readability"

Just some suggestions off the top of my head.

If the goal is to reduce long line lengths, then maybe
more warnings or --strict tests for things like:

long variable names: (pick a length)

	some_long_variable_name_with_a_color

consecutive dereferences where a temporary might be better:

	foo->bar[baz].member1 = 1;
	foo->bar[baz].member2 = 2;

Multiple logical tests on a single line:

	foo > bar && baz < quz && etc...

Arguments after column 80
                                                                                                   1
         1         2         3         4         5         6         7         8         9         0
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	result = some_long_function(some_arg(arg1, arg2), another_arg(arg3, arg4), 4);

where a single argument of a short length before a
statement terminating ; may be ignored, but a longer
argument list may not.

Long trigraphs:

	should be on multiple lines

Comments beyond 80 column

	No idea what's right.

etc...


