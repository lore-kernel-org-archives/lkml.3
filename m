Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaAVChh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:37:37 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:32812 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaAVChf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:37:35 -0500
Date: Tue, 21 Jan 2014 21:37:31 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] percpu changes for v3.14-rc1
Message-ID: <20140122023711.GA4860@htj.dyndns.org>
References: <20140121094814.GB6928@htj.dyndns.org>
 <CA+55aFy6k0ezh69eXGDAJPfKHDRLPurCUBKXW4pcV-UjQVGLmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy6k0ezh69eXGDAJPfKHDRLPurCUBKXW4pcV-UjQVGLmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, Jan 21, 2014 at 05:51:13PM -0800, Linus Torvalds wrote:
> On Tue, Jan 21, 2014 at 1:48 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > I messed up the for-3.14 branch (committed stuff to for-next) and had
> > to rebuild for-3.14 by cherry-picking; however, the result is the same
> > as published to the next tree through for-next.
> >
> > The changes are available in the following git branch
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
> 
> You messed up the pull request too.. The branch name is missing from
> that git line, even if you did mention it a few lines earlier...

Oops, sorry.  The branch is for-3.14.

I have no idea how that happened tho.  That even isn't a part that I
edit.  I did

  git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.14 > out

and then pulled in that file and added the description on top and diff
at the end.  I still have the "out" file created by the above command
and it also lacks the branch tag, so it definitely wasn't me somehow
deleting it while editing.  If I run the git-request-pull again, it
does have "for-3.14" there with everything else identical.  I wonder
whether git-request-pull somehow skips over branch tag when remote
for-3.14 doesn't match local one?

Ooh, right, that was it.  So, after running git-request-pull for the
first time, I rebuilt for-3.14, did git push -f and then ran
git-request-pull.  At that point, the new for-3.14 hasn't propagated
to git://git.kernel.org yet, so git-request-pull couldn't find the
head which matched the SHA1 and thus omitted printing the branch.  I
wonder whether this is a new behavior.  I saw the warning message
multiple times but ISTR the generated pull request having the branch
name specified on the command line regardless.  Maybe it should just
fail rather than generating pull request w/o branch tag?

Thanks.

-- 
tejun
