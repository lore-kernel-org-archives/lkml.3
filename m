Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaJLVTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 17:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaJLVTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 17:19:35 -0400
From: Paul Moore <pmoore@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security subsystem upate for 3.18
Date: Sun, 12 Oct 2014 17:19:24 -0400
Message-ID: <1585069.kQpl3ZVDtr@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org> <18599898.QtEUVscf6i@sifl> <CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 12, 2014 11:50:41 AM Linus Torvalds wrote:
> 
> Examples of *good* reasons to do a back-merge:
> 
>  - the code was developed on a really ancient tree, and is *so*
> out-of-date that not only are there conflicts, they are complicated
> and might be more than simple data conflicts - semantic changes etc
> that you as a submaintainer might be better off handlng the merge of,
> since you presumably know the code you are merging intimately.
> 
>    Note: you may know your code intimately, but maybe you don't know
> the other changes intimately, and maybe the top-level maintainer is
> actually better at merging (possibly because that maintainer does 10+
> merges a day at times). So "a few conflicts" is not necessarily a good
> reason in itself, but there are certainly cases where things just get
> so ugly that "break the rules" is a very valid approach.
> 
>  - you actively need infrastructure from newer versions, so you need
> to merge an upstream kernel for further development.
> 
>    Even this is often questionable, but it's one of the best reasons
> to do back-merges. However, if so, that back-merge should very much
> spell out the exact reason why the merge was needed (not just "needed
> upstream features" in general, but what particular features were
> needed etc).
> 
>  - and hey, as with so many (all) kernel development rules, I don't
> actually want people to think that the rules are completely hard.
> Mistakes happen, shit happens, things go wrong, whatever.

Okay, understood.  I suppose I was hoping to see something a little less 
subjective (?), if for no other reason than to avoid the "what the hell?!" 
moments.  However, like you said, development is messy, and it's probably 
naive to try and force too rigid a process.

I'll stop back merging each new release without a valid reason.  I suspect 
there will be disagreements at points in the future about if the merge was 
truly warranted, but at least that is a step in the right direction.

Regardless, sorry for the problems this time around, hopefully things will be 
smoother in the future.

On Sunday, October 12, 2014 12:01:25 PM Linus Torvalds wrote:
> One more comment on this..
> 
> On Sun, Oct 12, 2014 at 11:50 AM, Linus Torvalds
> 
> <torvalds@linux-foundation.org> wrote:
> >  - you actively need infrastructure from newer versions, so you need
> > to merge an upstream kernel for further development.
> > 
> >    Even this is often questionable, but it's one of the best reasons
> > to do back-merges. However, if so, that back-merge should very much
> > spell out the exact reason why the merge was needed (not just "needed
> > upstream features" in general, but what particular features were
> > needed etc).
> 
> Btw, rather than merge from upstream, a better way is often to simply
> start a new development branch. If you need a particular new feature,
> you're *likely* to start doing new development rather than continuing
> on some previous development, so it's often a good time to simply
> create a new feature branch.

Aside from my own patches/work, I've tried to keep a single, continuous 
development branch (next) that can be used by others for SELinux development, 
in the linux-next tree, and by James via pull requests.  Unless this becomes 
to difficult to manage without regular back-merges (and I don't think this 
would be the case), I'd just assume keep this approach.

-Paul

-- 
paul moore
security and virtualization @ redhat

