Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaFPS1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:27:40 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:59898 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147AbaFPS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:27:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2736:2828:3138:3139:3140:3141:3142:3352:3622:3743:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:7652:7903:10004:10400:10848:11232:11233:11658:11914:12043:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cakes35_257e5179ca838
X-Filterd-Recvd-Size: 2922
Message-ID: <1402943256.3182.2.camel@joe-AO725>
Subject: Re: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 11:27:36 -0700
In-Reply-To: <20140616064053.GJ5015@mwanda>
References: <20140613065346.GA28134@mwanda>
	 <1402651822.12385.31.camel@joe-AO725> <20140613094651.GF5015@mwanda>
	 <1402689145.4462.13.camel@joe-AO725> <20140616064053.GJ5015@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 09:40 +0300, Dan Carpenter wrote:
> On Fri, Jun 13, 2014 at 12:52:25PM -0700, Joe Perches wrote:
> > On Fri, 2014-06-13 at 12:46 +0300, Dan Carpenter wrote:
> > > On Fri, Jun 13, 2014 at 02:30:22AM -0700, Joe Perches wrote:
> > > 
> > > > > +# check for missing a space in a string concatination
> > > > > +        if ($prevrawline =~ /[^\\][a-zA-Z]"$/ && $rawline =~ /^\+[\t ]+"[a-zA-Z]/) {
> > > > > +            WARN('MISSING_SPACE',
> > > > > +                 "break quoted strings at a space character\n" . $hereprev);
> > > > > +        }
> > > > 
> > > > Probably want digits too so maybe \w instead of "[a-zA-Z]/
> > 
> > Couple nits:
> > 
> > The indentation isn't right here.
> > 
> > And this check is probably better placed immediately
> > after the "SPLIT_STRING" test.
> > 
> > []
> > 
> > > ./drivers/scsi/pm8001/pm8001_ctl.c:297 			       "0x%08x 0x%08x\n",
> > > ./drivers/scsi/pm8001/pm8001_ctl.c:432 			       "0x%08x 0x%08x\n",
> > > ./drivers/scsi/qla2xxx/qla_nx2.c:1457 	    "0x%X 0x%X 0x%X 0x%X 0x%X 0x%X\n"
> > > 	- hex false positives
> > 
> > These look more like defects to me.
> > 
> > > I thought about doing that when I wrote my original patch but I was
> > > worried about more hex false positives.  If there are only those 3 then
> > > it's probably not a big deal.  What do you think?
> > 
> > I know it works on files, but I'm not sure it works on patches.
> > 
> > What happens when checking a single line replacement patch?
> > 
> > Likely the \\[a-zA-Z] check should include
> > all the tests that the multiple line string exceptions use.
> > 
> > (?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$
> 
> That kind of complicate regex hurts my head.  How do I make it not
> complain about:
> 		"foo\n\t"
> 		"bar";

Did you try it?

The first test should handle any \n, \t or \r
at the end of a string.

[0-7]{1,3] is for octal

x[0-9afAF]{1,2} is for hex constants


