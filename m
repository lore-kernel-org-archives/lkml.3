Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262Ab3DPS3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:29:52 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54804 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3DPS3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:29:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
	<CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
Date: Tue, 16 Apr 2013 11:29:48 -0700
X-Google-Sender-Auth: PTZzSv2ddJyZcBNwaIYGmk_ulfA
Message-ID: <CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Colin Cross <ccross@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:21 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> What I meant is IF <linux/fuse.h> is included by userspace (it sure is
>> meant to be included and *is* included by libfuse and other stuff)
>> THEN using <stdint.h> instead of <linux/types.h> is fine regardless of
>> whether __linux__ is defined or not.
>
> That's probably true. But the patch in question adds the __KERNEL__
> test, and *that* seems required.
>
> If you think that we should instead drop the __linux__ test, than yes,
> that part sounds fine. I thought that by "linux internal header" you
> meant the fuse.h file, but you seem to mean the indirectly included
> <inux/types.h>. That's fine.
>
>                 Linus

Dropping __linux__ causes a make headers_check warning, which the
kbuild test robot reported this morning:
usr/include/linux/fuse.h:99: found __[us]{8,16,32,64} type without
#include <linux/types.h>
Using my patch without modification does not cause that warning.

linux/types.h defines the types that are used to communicate between
the kernel and userspace.  Redefining those in each header makes no
sense, and will probably cause redefined types warnings if you compile
a userspace file that includes fuse.h and another uapi header that
properly includes linux/types.h.
