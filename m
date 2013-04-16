Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106Ab3DPRYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:24:31 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57253 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935825Ab3DPRYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:24:30 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
Date: Tue, 16 Apr 2013 19:24:28 +0200
Message-ID: <CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 5:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 16, 2013 at 7:21 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> And I still disagree.  Why should userspace use the linux internal
>> header when there's a perfectly good standard header that it can use?
>
> If it's called UAPI, it damn well is *meant* for user-space inclusion.
> Look at the file-name.
>
> And since the bug comment says "This file defines the kernel interface
> of FUSE" *AND* it very clearly has explicit code to support user-space
> includes with special user-space-only type defines, then your email is
> obviously just pure crap, and I don't understand how you can write
> that sentence with a straight face.

I think I meant something different by that sentence than what you
think I meant :)

What I meant is IF <linux/fuse.h> is included by userspace (it sure is
meant to be included and *is* included by libfuse and other stuff)
THEN using <stdint.h> instead of <linux/types.h> is fine regardless of
whether __linux__ is defined or not.

Does that sound better, or is there still something we disagree about?

Thanks,
Miklos
