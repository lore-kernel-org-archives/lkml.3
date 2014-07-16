Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbaGPEIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:08:47 -0400
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:34430 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933644AbaGPEIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:08:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:7514:7652:7903:8957:10004:10400:10450:10455:10848:11026:11232:11658:11914:12296:12517:12519:12555:12740:13069:13255:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dad51_694d700ccec37
X-Filterd-Recvd-Size: 2200
Message-ID: <1405483722.14773.12.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/get_maintainer: increase threshold for
 --follow to reduce time
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 21:08:42 -0700
In-Reply-To: <CAJhHMCC1bY5ras7-W17Qh7yZq5-_eD0C-CJfa09ZpjWNoTOZ=w@mail.gmail.com>
References: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
	 <CAJhHMCC1bY5ras7-W17Qh7yZq5-_eD0C-CJfa09ZpjWNoTOZ=w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 22:23 -0400, Pranith Kumar wrote:
> ping?
> 
> On Sat, Jul 12, 2014 at 3:25 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> > get_maintainer tries to follow files with a matching threshold of default 50%.
> > This is not really necessary as we do not change a file and move it in the same
> > commit usually. Increasing the threshold to 90% should be sufficient.
[]
> > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> > index d701627..bc4a69e 100755
> > --- a/scripts/get_maintainer.pl
> > +++ b/scripts/get_maintainer.pl
> > @@ -98,7 +98,7 @@ my %VCS_cmds_git = (
> >      "execute_cmd" => \&git_execute_cmd,
> >      "available" => '(which("git") ne "") && (-e ".git")',
> >      "find_signers_cmd" =>
> > -       "git log --no-color --follow --since=\$email_git_since " .
> > +       "git log --no-color --follow -M90 --since=\$email_git_since " .
> >             '--numstat --no-merges ' .
> >             '--format="GitCommit: %H%n' .
> >                       'GitAuthor: %an <%ae>%n' .

While I understand the goal, I wonder if this should
be in a .gitconfig, not in get_maintainers at all.

(git doesn't seem to have a config entry for score though)

If not, the % should probably be cmd-line configurable.


