Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaHGWFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:05:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaHGWFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:05:31 -0400
Message-ID: <53E3F827.9030902@nod.at>
Date: Fri, 08 Aug 2014 00:05:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at>	<20140806212720.66dbd58b@canb.auug.org.au>	<53E21186.3000702@nod.at>	<20140807102823.7a743bdf@canb.auug.org.au>	<53E32C5C.5010103@nod.at> <CA+55aFy0OFQ5ncwHwpah4xwxuOuMEWL+w6Dv-akTFnogpLo1yA@mail.gmail.com> <53E3E5C8.9090408@nod.at>
In-Reply-To: <53E3E5C8.9090408@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.08.2014 22:47, schrieb Richard Weinberger:
> Thanks for the clarification.
> 
> Here is what happened:
> 
> Branch signal_v4 is in linux-next, it never got rebased.
> While preparing the pull request I noticed that some of the patches gained new acks
> from various architectures.
> So I took the *local* copy of signal_v4 added these acks using git rebase and rebased them to v3.16.
> Then I've pushed that branch to signal-cleanup and sent you the request.
> signal-cleanup did not exist before that.
> My fault was rebasing my work from v3.16-rc6 to v3.16 before pushing it.
> It won't happen again. But I never did a push -f or something like that.
> 
> If you feel better you can still pull from:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4
> 
> It is the as-is branch from linux-next.

Btw: This is how you can verify that I did not alter any code between the branch in linux-next
and the one in the pull request:

$ git branch prove_signal_v4 v3.16
$ git branch prove_signal-cleanup v3.16
$ git checkout prove_signal_v4
$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4
$ git checkout prove_signal-cleanup
$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-cleanup
$ git diff prove_signal_v4..prove_signal-cleanup | wc -l
0

Again, sorry for any inconvenience caused.

Thanks,
//richard
