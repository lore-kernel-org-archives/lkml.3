Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaFDXMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:12:53 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:55344 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaFDXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406042048420.18296@nanos>
References: <alpine.DEB.2.10.1406042048420.18296@nanos>
Date: Wed, 4 Jun 2014 16:12:50 -0700
X-Google-Sender-Auth: -uUMjeyV2ys99XPjPwwO37FZY-E
Message-ID: <CA+55aFxTLKJuWvUUvVEi4LssQEMzA_3nMR=_LYjv4ksmkRO-ZQ@mail.gmail.com>
Subject: Re: [GIT pull] irq core changes for 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 12:34 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Is what my script uses for years now, but this time it created a diff
> with random extra content from all over the tree.
>
> $BASE is 2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf

You have criss-cross merges, so there are multiple merge-bases. You
can see if it you use the "--all" flag to "git merge-base". For
example, there's that "Merge branches 'linus' and 'irq/urgent' into
irq/core" that does a back-merge of my tree, and there's also a "Merge
tag 'irqchip-mvebu-3.16' of git://git.infradead.org/linux-mvebu into
irq/core" that merges stuff that is already in my tree. So there is
not a single unique shared base-point.

When that happens, doing the diff against one of the base points *can*
happen to work, but generally gives other random cruft from the other
shared part of the tree as part of the diff. It happened for your
timer core pull too, you just didn't notice because the shared part
was much smaller.

Anyway, for the "there are multiple different commits in common" case,
the only way to get a true diff is to generate the actual merge in a
temporary branch, and see what the result is (and then just throw away
the merge). The git merge facilities are much smarter than just
diffing between two points, and will actually recursively merge up the
different base points in order to generate the final merge result.

But if it's rare, it doesn't much matter if the trivial "let's just
diff against the base" doesn't always work. But this *is* one of the
reasons why I suggest against back-merges, because it makes the
history harder to figure out, and it causes these kinds of "there are
many different independent base points" issues.

                Linus
