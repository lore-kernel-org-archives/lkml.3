Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbaGRWru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:47:50 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:56175 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762194AbaGRWrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:47:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1963:2198:2199:2393:2553:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4470:5007:6117:6119:6691:7652:7903:9010:10004:10400:10450:10455:10848:11232:11658:11914:12050:12296:12517:12519:12740:13137:13141:13150:13161:13229:13230:13231:13255:13869:14039:14040:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sense50_60f53d6274255
X-Filterd-Recvd-Size: 3759
Message-ID: <1405723664.14358.98.camel@joe-AO725>
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        kernelnewbies@kernelnewbies.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 18 Jul 2014 15:47:44 -0700
In-Reply-To: <20140718222215.GF18775@thunk.org>
References: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
	 <20140718222215.GF18775@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 18:22 -0400, Theodore Ts'o wrote:
> On Fri, Jul 18, 2014 at 05:38:30PM +0300, Andrey Utkin wrote:
> > Is there script for automated checkpatch.pl && get_maintainers.pl &&
> > git send-email for range of commits? I see none. Would it be welcome
> > to submit such one to kernel tree?
> 
> Too much automation can be a really bad thing.  You **really** want to
> sanity check the output of checkpatch.pl

True.

checkpatch should not be used on existing commits.
checkpatch should be used prior to committing.

>  and get_maintainers.pl.

I think checkpatch is pretty good about cc'ing mostly the
right folk by default.

Where it's not adequate is when some particular bit of code
was written by someone not the maintainer and that writer
should also be copied on a patch.

Many different command-line options exist for get_maintainer.
Perhaps too many.  --git-blame can be used with patches to
also list the author of any modified commit.  Using that
option can take a fairly long while to run though.

> Their output is not always correct, and some amount of human common
> sense is required.

True.  Experience is more of a benefit than common sense here.

> And then think very hard about which patches people need to see in
> order to be able to evaluate a patch.  For example, if you have patch
> 1 out of a series which adds a new function, and then patches 2
> through 1000 modify a thousand different drivers to use that new
> function, if you use an automated get_maintainers.pl script to send
> each patch to just the maintainer, then the device driver maintainer
> might not see patch #1 which is critical context to understanding the
> patch that you want to make to his driver.  And then you will have
> several hundred very angry and annoyed developers wondering why you
> sent them patch 345/1000, with no other context, and wondering what
> the heck they are supposed to do with the email that you have just
> launched into their inbox.

There is no good solution to this problem.

You can't cc the world on patch 1/n (vger rejects emails
with too many recipients) and cc just the maintainers on x/n.

One solution is to send the 0/n and 1/n patches to all the
email lists that are cc'd on any single patch of large patch
series.

A better solution might be to send _only_ the 1/n patch to
lkml and to someone like Andrew Morton with an explanation
as to why it's useful, wait for it to be applied, then send
the large patch series during the next release cycle.

> There's a reason why many developers cordially hate these scripts;
> it's too easy to misuse them,

Yup, though cordial can be a misdescription for some of
those developers...

I hope everyone enjoys their weekends...

