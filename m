Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaIPQbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:31:40 -0400
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:35365 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754090AbaIPQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:31:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3165:3352:3622:3653:3865:3866:3867:3870:3874:4321:4605:5007:6691:7652:7903:8531:8957:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pan94_df6fb48f3207
X-Filterd-Recvd-Size: 1852
Message-ID: <1410885094.16519.6.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Tue, 16 Sep 2014 09:31:34 -0700
In-Reply-To: <1685749151.185639.1410884118738.open-xchange@webmail.nmp.skynet.be>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be>
	 <1410837769.18787.40.camel@joe-AO725>
	 <1685749151.185639.1410884118738.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 18:15 +0200, Fabian Frederick wrote:
> > On 16 September 2014 at 05:22 Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> > > Adding patch subject uniqueness check in checkpatch --strict mode.
> > > See Documentation/SubmittingPatches/globally-unique identifier.
> >
> > Perhaps something like this?
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > +     if ($check && $#git_commits < 1 && which("git") && -e ".git") {
> > +             my $output = `git log --no-color --format='%H %s' 2>&1`;
> > +             $output =~ s/^\s*//gm;
> > +             @git_commits = split("\n", $output);
> > +     }

> Perfect ! :)

Except for that _really, really_ long time to do the
git log of all commits...

Maybe the git log should be enabled only with another
command-line option.

