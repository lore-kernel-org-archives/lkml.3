Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936062Ab3DPP77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:59:59 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:34830 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab3DPP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:59:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
Date: Tue, 16 Apr 2013 08:59:56 -0700
X-Google-Sender-Auth: X81-ahnvw9z-6FERQ6NNItKsws0
Message-ID: <CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
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

On Tue, Apr 16, 2013 at 7:21 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> And I still disagree.  Why should userspace use the linux internal
> header when there's a perfectly good standard header that it can use?

If it's called UAPI, it damn well is *meant* for user-space inclusion.
Look at the file-name.

And since the bug comment says "This file defines the kernel interface
of FUSE" *AND* it very clearly has explicit code to support user-space
includes with special user-space-only type defines, then your email is
obviously just pure crap, and I don't understand how you can write
that sentence with a straight face.

The *whole* point of the UAPI includes is two-fold:

 - to make it easier for user-space libraries to get at the kernel
definitions. Not everybody wants to use glibc for various reasons, and
where do you want people to *get* these declarations from?

 - to make kernel people more AWARE of when they are changing stuff
that affects user-space.

Now, the uapi model not perfect, but there are damn good reasons to at
least *strive* for both of those things, so I really don't understand
your comment there.

                Linus
