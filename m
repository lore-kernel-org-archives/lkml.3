Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3IKAlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:41:31 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54393 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3IKAla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:41:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130911103005.edd86001b641e53becc05ad2@canb.auug.org.au>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<CA+55aFwiK+=7N3EDoX+s8dVCoraba9bCPrgqHgsMKppogEFBnw@mail.gmail.com>
	<20130910154400.75bb3328fbb9eaa937715652@linux-foundation.org>
	<20130911103005.edd86001b641e53becc05ad2@canb.auug.org.au>
Date: Tue, 10 Sep 2013 17:41:29 -0700
X-Google-Sender-Auth: A_xrS1GByQbUii2JRDauiPNupRE
Message-ID: <CA+55aFwHMdOsyMO70DpPaBLMtuDSu43v4Gi0Vc1aKVyJhHrT=g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 5:30 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> So, Andrew, you should be able to just about send those 375 patches to
> Linus (I know that there may be some fix folding to do before that) and
> have him apply them on top of v3.11-rc7-14-gfa8218d in a separate branch
> and then merge that branch.

That's how I have been doing Andrew's patch-bombs anyway, since I
started asking him what they were based on (they *usually* apply on
top of my current tip, but during the merge window so much happens
that it wasn't all that unusual that one or two patches didn't quite
apply). So these days I just always do a "git checkout -b akpm
<base-andrew-gives-me>" and apply the patches that way.

It's just that normally the base is within about six hours of my tip
anyway. This would be the first time it's way back.

But I much prefer having more of a merge of well-tested code over
having an easier merge of something that was rebased. That's
especially true if the rebasing ends up delaying me getting the
patches in the first place. I detest having merge windows where the
last few days are busy, I'd really much rather have a couple of days
with very little going on before doing the -rc1 (in the hope that rc1
actually ends up being pretty good).

> I have included the "git diff-tree --cc"
> output from my merge of that into linux-next yesterday.  Some of it is
> not applicable yet (since there are still some other outstanding trees),
> but it gives you some idea of how little the merge is a problem.

Yes. We actually seldom have real merge problems. The only really
annoying merges tend to be when somebody did something that isn't
really code-related, like sorting a big list of entries (Makefiles,
Kconfig files, device tree cleanups) and then both sides do a fair
amount of changes on their respective - and very different - sides.

The "multiple people worked on the same code" part is fairly unusual,
and particular if I know the code and can even compile it, it's all
fine.

              Linus
