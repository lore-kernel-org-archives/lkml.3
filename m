Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaITKbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:31:37 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:55454 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaITKbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:31:36 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=XryuEu0TkPcA:10 a=qeYcf6Gh41QA:10 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8
 a=pyTQFJ9HQLFcPeAzTYIA:9 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkLAPRWHVTD7hTU/2dsb2JhbABfgw1TV4MBslABAQEBAQEGlCqHVQF9FgF5hAMBAQEDASNWBQsFBAIYAgIYDgICVwYTEYglDJAknEeGf48jgSyEYYlGMweCeIFTBZYMiGiTbYNiOy+CSgEBAQ
Date: Sat, 20 Sep 2014 12:31:34 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <2022098628.197398.1411209094968.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1410885094.16519.6.camel@joe-AO725>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be> <1410837769.18787.40.camel@joe-AO725> <1685749151.185639.1410884118738.open-xchange@webmail.nmp.skynet.be> <1410885094.16519.6.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 16 September 2014 at 18:31 Joe Perches <joe@perches.com> wrote:
>
>
> On Tue, 2014-09-16 at 18:15 +0200, Fabian Frederick wrote:
> > > On 16 September 2014 at 05:22 Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> > > > Adding patch subject uniqueness check in checkpatch --strict mode.
> > > > See Documentation/SubmittingPatches/globally-unique identifier.
> > >
> > > Perhaps something like this?
> []
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > > +     if ($check && $#git_commits < 1 && which("git") && -e ".git") {
> > > +             my $output = `git log --no-color --format='%H %s' 2>&1`;
> > > +             $output =~ s/^\s*//gm;
> > > +             @git_commits = split("\n", $output);
> > > +     }
>
> > Perfect ! :)
>
> Except for that _really, really_ long time to do the
> git log of all commits...
>
> Maybe the git log should be enabled only with another
> command-line option.
>
Hello Joe,

checkpatck does already execute git log in seed_camelcase_includes and
git_commit_info when .git exists
so we could add some specific option instead like --complete --verbose
--checkduplicates or something for this test ?

Regards,
Fabian
 
