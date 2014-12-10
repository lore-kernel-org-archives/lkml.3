Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaLJDFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:05:22 -0500
Received: from ns.horizon.com ([71.41.210.147]:56374 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751792AbaLJDFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:05:21 -0500
Date: 9 Dec 2014 22:05:18 -0500
Message-ID: <20141210030518.19336.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [GIT PULL] arch/nios2 for v3.19
Cc: arnd@arndb.de, lftan@altera.com, linux@horizon.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
In-Reply-To: <20141210015421.GB3370@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, git already preserves the signed annotated tag.  That's the
> only way git show --show-signature can verify the tag's gpg signature.
> 
> You can see original signed annotated tag via a command like this:
> 
> git cat-file -p 18b34d9a7a085ba8f9cafa6a0d002e2cbac87c1f

TIL, thank you!

For the others watching in, as you know all commits have "headers"
which are normally not printed.  The above commit looks like

>  tree 939755a58a68aae5e1241b2a905ea612aeb2e589
>  parent 502fde1a0a2990ec54eab5241d3135c545da7372
>  parent bf40c92635d63fcc574c52649f7cda13e0418ac1
>  author Linus Torvalds <torvalds@linux-foundation.org> 1405282495 -0700
>  committer Linus Torvalds <torvalds@linux-foundation.org> 1405282495 -0700
>  mergetag object bf40c92635d63fcc574c52649f7cda13e0418ac1
>   type commit
>   tag ext4_for_linus_stable
>   tagger Theodore Ts'o <tytso@mit.edu> 1405281748 -0400
>   
>   More bug fixes for ext4 -- most importantly, a fix for a bug
>   (introduced in 3.15) that can end up triggering a file system
>   corruption error after a journal replay.  (It shouldn't lead to any
>   actual data corruption, but it is scary and can force file systems to
>   be remounted read-only, etc.)
>   -----BEGIN PGP SIGNATURE-----

The "mergetag" header contains the original annotated tag, indented
by one space.

In this case, Ted included the same message (formatted slightly
differently) in the pull e-mail and Linus copied it into the
merge commit, so it worked out in the end.
