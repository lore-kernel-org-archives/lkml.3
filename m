Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaJLOMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:12:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55761 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1410101913460.13164@namei.org>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org>
Date: Sun, 12 Oct 2014 10:12:28 -0400
X-Google-Sender-Auth: KE6LCGLQpBjs5J4K-fPbiA9IQt4
Message-ID: <CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com>
Subject: Re: [GIT] Security subsystem upate for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>, Paul Moore <pmoore@redhat.com>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 4:23 AM, James Morris <jmorris@namei.org> wrote:
>
> One of these is from merging with your v3.16, and the other from a merge
> of the keys tree.  That's about all I understand of it.

Please don't do back-merges. What was the reason for that v3.16 merge?
It only caused problems, and the merge message is this worthless
oneliner:

  "Merge commit 'v3.16' into next"

that's it. No reason why, and there doesn't seem to be any merge
conflicts fixed up either, so why was that merge done? The commit
message sure as hell doesn't explain it.

There's another one, by Paul Moore:

   "Merge tag 'v3.16' into next

    Linux 3.16"

and please tell me what that (now two-line) merge message adds to the
world, and why those merges were done at all?

People, stop doing these back-merges. You are doing them wrong, and
they cause problems. Just stop it. And if you have some seriously good
reason for why you are doing them, you should damn well *document*
that reason, rather than say "Merge v3.16" and leave it at that. If
you *don't* have a good reason for doing them, don't do them!

Also, James, *please* give a short description of what I'm merging,
and include both "git" and "pull" in the pull request. As it is, I see
the shortlog and the (completely incorrect, due to the back-merge)
diffstat, but I don't see *why* I should merge it at all. Give me a
synopsis of what has changed and why I should pull.

And finally - I didn't even find the pull request at all with my
normal "look for git pull requests" search that - not completely
randomly - looks for "in:inbox git pull". If I don't find a pull
request with that, it easily gets overlooked. So change your scripts
to add "Please pull" into the body of the message, or make the subject
line be "[GIT PULL]" or something.

These are all things I've ranted about many times before.  Please.

                   Linus
