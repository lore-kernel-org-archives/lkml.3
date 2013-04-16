Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682Ab3DPOVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:21:31 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35299 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935534Ab3DPOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:21:30 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
Date: Tue, 16 Apr 2013 16:21:28 +0200
Message-ID: <CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Miklos Szeredi <miklos@szeredi.hu>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:47 PM, Colin Cross <ccross@android.com> wrote:
> On Mon, Apr 15, 2013 at 1:41 PM, Colin Cross <ccross@android.com> wrote:
>> Commit 7e98d53086d18c877cb44e9065219335184024de (Synchronize fuse
>> header with one used in library) added #ifdef __linux__ around
>> defines if it is not set.  The kernel build is self-contained and
>> can be built on non-Linux toolchains.  After the mentioned commit
>> builds on non-Linux toolchains will try to include stdint.h and
>> fail due to -nostdinc, and then fail with a bunch of undefined
>> type errors.
>>
>> Change the #ifdef to check for __linux__ or __KERNEL__ so that
>> it uses the kernel typedefs if __KERNEL__ is set.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>> I think this should go in v3.9, without it bare-metal toolchains
>> that don't define __linux__ will fail to compile the kernel, and
>> cross-compiles from non-linux hosts will probably also fail.
>
> Miklos, I see Arve sent an equivalent patch to you a month ago
> (https://lkml.org/lkml/2013/3/11/620), and I agree with his response
> to your question (checking for __linux__ and __KERNEL__ is better than
> just checking for __KERNEL__ if you want this header to be used in
> userspace builds on linux targets).

And I still disagree.  Why should userspace use the linux internal
header when there's a perfectly good standard header that it can use?

Patch committed and pushed to for-next and for-linus.  I'll push to
Linus tomorrow.

Thanks,
Miklos
