Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427Ab3DPTLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:11:12 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48573 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935158Ab3DPTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:11:11 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
	<CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
	<CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
Date: Tue, 16 Apr 2013 21:11:10 +0200
Message-ID: <CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Miklos Szeredi <miklos@szeredi.hu>
To: Colin Cross <ccross@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 8:29 PM, Colin Cross <ccross@android.com> wrote:
> Dropping __linux__ causes a make headers_check warning, which the
> kbuild test robot reported this morning:
> usr/include/linux/fuse.h:99: found __[us]{8,16,32,64} type without
> #include <linux/types.h>
> Using my patch without modification does not cause that warning.
>
> linux/types.h defines the types that are used to communicate between
> the kernel and userspace.  Redefining those in each header makes no
> sense, and will probably cause redefined types warnings if you compile
> a userspace file that includes fuse.h and another uapi header that
> properly includes linux/types.h.

<linux/types.h> is linux specific while the fuse API is cross
platform.  So the userspace header obviously has to use some cross
platform type definitions.  Making the type definitions depend on
__linux__ is probably just as unreliable in userspace as it is in the
kernel, so why complicate things with that?

Thanks,
Miklos
