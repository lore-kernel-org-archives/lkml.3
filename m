Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab3GCVCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:02:05 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46527 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3GCVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <51D3D9AD.9070800@samsung.com>
References: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
	<20130703100903.81ab08c6db864c20498b558d@canb.auug.org.au>
	<51D3D9AD.9070800@samsung.com>
Date: Wed, 3 Jul 2013 14:02:01 -0700
X-Google-Sender-Auth: fNz-y-5CQRmdMaKr8bxVa2n3nlk
Message-ID: <CA+55aFww7SG3BVDs5jUTwX9pjARG3XQXA2g_9XQJf6agq=fD9g@mail.gmail.com>
Subject: Re: [GIT PULL] DMA-mapping updates for v3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 12:58 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Right, I dropped one commit, which I found in other 'for_next' kernel tree
> (the one from Russell King) before sending the pull request. What's wrong with
> this approach?

What did dropping the commit fix? Anything?

DO NOT REBASE UNLESS YOU HAVE SERIOUSLY PRESSING REASONS!

Why does this keep on coming up EVERY SINGLE RELEASE? Does nobody read my rants?

A duplicate commit not a "seriously pressing reason". It may be reason
for some introspection ("why did I and Russell end up applying the
same patch and stepping on each others toes?") but it is not in itself
at all a reason for rebasing.

Reasons for rebasing include:

 - "I am a complete moron, and I have terminally messed up my history
with merges from random places to the point where it is completely
unpullable"

 - "There are commits that are so horribly broken in the history that
I can't even revert them, because seeing them mentioned one more time
will make me go blind"

and the best one:

 - "I never made my patches public in the first place, and I'll clean
my ugly series up before posting them publicly for the first time".

but that last one shouldn't happen just before sending it to me, it
should happen a few weeks before sending to me so that linux-next has
time to digest the beauty of the rebased series.

The fact is, rebasing is a perfectly fine operation, but it's a fine
operation that causes lots of problems if those commits have ever been
public before. It means that linux-next cannot easily be compared to
what I pull (which is why Stephen complains), but it also results in
other developers not being able to trust your tree, and in the commits
randomly changing and the testing base thus not being reliable any
more (which is why I complain).

                   Linus
