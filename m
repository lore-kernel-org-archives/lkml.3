Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056Ab3DPSVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:21:06 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:56934 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3DPSVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
Date: Tue, 16 Apr 2013 11:21:02 -0700
X-Google-Sender-Auth: 5wbBlQAgMJXC6XRA88WcRnLs-H4
Message-ID: <CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I meant is IF <linux/fuse.h> is included by userspace (it sure is
> meant to be included and *is* included by libfuse and other stuff)
> THEN using <stdint.h> instead of <linux/types.h> is fine regardless of
> whether __linux__ is defined or not.

That's probably true. But the patch in question adds the __KERNEL__
test, and *that* seems required.

If you think that we should instead drop the __linux__ test, than yes,
that part sounds fine. I thought that by "linux internal header" you
meant the fuse.h file, but you seem to mean the indirectly included
<inux/types.h>. That's fine.

                Linus
