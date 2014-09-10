Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaIJOgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:36:47 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:47962 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750935AbaIJOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:36:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2898:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6119:6742:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12663:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: team41_74b4cd994c33b
X-Filterd-Recvd-Size: 2296
Message-ID: <1410359800.24028.51.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Warn on macros with flow control statements
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Wed, 10 Sep 2014 07:36:40 -0700
In-Reply-To: <alpine.DEB.2.10.1409101604210.4747@hadrien>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
	 <20140909125410.GJ6549@mwanda> <1410295093.12560.60.camel@joe-AO725>
	 <20140910084306.GV6600@mwanda> <1410357331.24028.39.camel@joe-AO725>
	 <alpine.DEB.2.10.1409101604210.4747@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 16:06 +0200, Julia Lawall wrote:
> On Wed, 10 Sep 2014, Joe Perches wrote:
> > On Wed, 2014-09-10 at 11:43 +0300, Dan Carpenter wrote:
> > > On Tue, Sep 09, 2014 at 01:38:13PM -0700, Joe Perches wrote:
> > > > Macros with flow control statements (goto and return) are
> > > > not very nice to read as any flow movement is unexpected.
> >
> > break and continue are also flow control statements
> > but are those are frequently used in macros in
> > complete switch statements so were not added.
> 
> Would it be possible to make a warning when there is a break or continue
> but no while/switch/etc.

I suppose the has_flow_statement could be extended.

Maybe something like:

			if ($ctx =~ /\b(goto|return|break|continue)\b/ &&
			    $ctx !~ /\b(switch|if|do|while)\b/) {
				has_flow_statement = 1;
			}

but checkpatch isn't really capable  of doing proper
flow logic analysis.

I'm not sure it's worthwhile.



