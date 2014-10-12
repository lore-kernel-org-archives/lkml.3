Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJLQB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:01:28 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45156 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaJLQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org>
	<CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com>
	<18599898.QtEUVscf6i@sifl>
	<CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
Date: Sun, 12 Oct 2014 12:01:25 -0400
X-Google-Sender-Auth: 3g7Bkua4KFHgvAUKLWjcLJaFJIE
Message-ID: <CA+55aFxtxBe8SaEYD6vAQME_YE+eD6mhU8F6Q850k-XBfzz4QQ@mail.gmail.com>
Subject: Re: [GIT] Security subsystem upate for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Moore <pmoore@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more comment on this..

On Sun, Oct 12, 2014 at 11:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  - you actively need infrastructure from newer versions, so you need
> to merge an upstream kernel for further development.
>
>    Even this is often questionable, but it's one of the best reasons
> to do back-merges. However, if so, that back-merge should very much
> spell out the exact reason why the merge was needed (not just "needed
> upstream features" in general, but what particular features were
> needed etc).

Btw, rather than merge from upstream, a better way is often to simply
start a new development branch. If you need a particular new feature,
you're *likely* to start doing new development rather than continuing
on some previous development, so it's often a good time to simply
create a new feature branch. I don't know how James feels about
merging multiple separate feature branches, but I know that *I* tend
to appreciate it when I get multiple well-defined pull requests rather
than one big one that does many different things.

And even if you then want to send just one pull-request, what you can
do if you have (say) three different feature branches is to create a
combined branch to be sent upstream, by just starting from one of the
feature branches and then merging the two other ones into that
combined one.  Some submaintainers do this quite a lot, and use
"octopus merges" to combine their different feature branches into one
final "please pull" branch. See for example Mark Brown's ASoC merge
for upstreaming (to Takashi Iwai, and then to me): commit bdf20b4291e.

             Linus
