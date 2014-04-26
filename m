Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaDZDaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 23:30:08 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:57044 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034AbaDZDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 23:30:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3870:3871:3872:3874:4321:5007:6120:7652:8957:10004:10400:10848:11026:11232:11658:11914:12043:12050:12296:12438:12517:12519:12555:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bait92_3df6796f63a
X-Filterd-Recvd-Size: 2490
Message-ID: <1398482999.3071.8.camel@joe-AO725>
Subject: [rfc PATCH] checkpatch: allow multiple const * types
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Del Piano <ndel314@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mail@berndporr.me.uk
Date: Fri, 25 Apr 2014 20:29:59 -0700
In-Reply-To: <20140425075020.GF26890@mwanda>
References: <5359DF54.50607@gmail.com> <20140425075020.GF26890@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 10:50 +0300, Dan Carpenter wrote:
> On Fri, Apr 25, 2014 at 01:06:44AM -0300, Nicolas Del Piano wrote:
> > diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
[]
> > @@ -439,6 +439,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
> >  static void comedi_report_boards(struct comedi_driver *driv)
> >  {
> >  	unsigned int i;
> > +
> >  	const char *const *name_ptr;
> 
> The original code was correct.  This is a bug in checkpatch.pl.  The
> missing line check should count any lines starting with "const" or
> "static" as declarations.

Right, thanks for the report.

I'm not around for a couple weeks.
I'll fix it properly later.

It looks like the $Type test in checkpatch
should allow multiple pointer declarations like
	"const foo * const *"
instead of just
	"const foo * const"

but it takes awhile to test that it doesn't stuff up
something else.

Andy?  Any opinion of this?

---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 89f44f1..daa4767 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -433,7 +433,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)*
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};


