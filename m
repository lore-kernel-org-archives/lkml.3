Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3D3O2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:28:33 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:59796 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3D3O2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <1367281038.30667.43.camel@gandalf.local.home>
References: <20130429195100.202681236@goodmis.org>
	<CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
	<CA+55aFzSfRv26E3UF1a8jwQK+vHSru-YTg8ADefZxOKZNnn6fA@mail.gmail.com>
	<1367280494.30667.38.camel@gandalf.local.home>
	<1367281038.30667.43.camel@gandalf.local.home>
Date: Tue, 30 Apr 2013 07:28:22 -0700
X-Google-Sender-Auth: cNphZI2DcHnYcZ8pnByxyTina_k
Message-ID: <CA+55aFwvc_u8hDmq4m6O+Q9C-iryHjutXEFBU7w4NY4sXk+LqQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] localmodconfig: Fix missing depends of
 config files included in if statements
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 5:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> BTW, what's the preferred method for this. I already posted a lot of
> work to linux-next when I found bugs that required going into your tree.
> I backported the fixes knowing that it will cause conflicts when you
> merge.
>
> IIRC, you stated that you don't mind doing conflict resolutions
> yourself, so I did not try to fix it a head of time, as the conflicts
> were rather minor.
>
> Should I have merged your tree and done the conflict resolutions myself,
> or was it OK to do what I did, and let you do the conflict resolution
> and send you any fixes that needed to be done afterward?

You did the right thing. In general, if you know there will be
conflicts, it's nice if you mention then in the pull request, but for
simple stuff like this it's really not a big deal. The fact that I
screwed up and then missed a "!" when editing it all is embarrassing,
but it wasn't because the conflict was really *complicated*, it was
just stupid editing error.

If the conflicts are really complex, at some point I really enjoy
getting a "here's a pre-merged branch if you prefer it", and if people
send that, I still tend to do the merge myself, but then I often just
compare against the pre-merged one afterwards to verify. But that's
actually extra work, so I'd suggest doing that only for things that
really warrant it. It's generally a bad thing if it happens, because
it means that we had some bad workflow and people stepped on each
others toes (or we had unlucky backports etc that ended up being in
the same area as much more work).

                   Linus
