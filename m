Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaGUNGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:06:30 -0400
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:38260 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754690AbaGUNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:06:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:173:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3873:3874:4250:4321:4425:4605:5007:7652:7903:10004:10400:10848:11232:11473:11658:11914:12517:12519:12555:12663:12679:12740:13069:13071:13095:13161:13180:13229:13311:13357:13972:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: screw15_8f9a8861cec35
X-Filterd-Recvd-Size: 2392
Message-ID: <1405947985.21586.5.camel@joe-AO725>
Subject: Re: Checkpatch query
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 21 Jul 2014 06:06:25 -0700
In-Reply-To: <20140721113948.GX30888@lee--X1>
References: <20140721113948.GX30888@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 12:39 +0100, Lee Jones wrote:
> Hi Andy, Joe,

Hi Lee.

> When running checkpatch on drivers/mfd/tps80031.c I recieve the
> following warning:
> 
> > WARNING: Possible switch case/default not preceeded by break or
> >          fallthrough comment
> > #337: FILE: drivers/mfd/tps80031.c:337:
> > +       case TPS80031_BACKUP_REG:
> > 
> > total: 0 errors, 1 warnings, 573 lines checked
> 
> ... but we use switch statement fall through all the time when
> identifying different types of registers used with Regmap.  Placing a
> fall-through comment between them all sounds very messy to me.

Yes, it can be messy, but it's found some
actual bugs/defects.

> Also, the warning only fires on 'case's which do not use '...'
> notation, which seems a little odd.

That's a checkpatch defect.  Thanks for the report.

> Anyway, I'm not sure placing a 'fall through' comment makes the code
> any cleaner or reduces possible failure rate in any way.  Is there any
> chance that this check can be removed?

You could use the --ignore= cmd-line option or add it to
a .checkpatch.conf file.

$ ./scripts/checkpatch.pl -f drivers/mfd/tps80031.c  --ignore=missing_break
WARNING: Possible unnecessary 'out of memory' message
#435: FILE: drivers/mfd/tps80031.c:435:
+	if (!tps80031) {
+		dev_err(&client->dev, "Malloc failed for tps80031\n");

total: 0 errors, 1 warnings, 573 lines checked

NOTE: Ignored message types: MISSING_BREAK

drivers/mfd/tps80031.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


