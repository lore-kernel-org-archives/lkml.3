Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3DQTpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:45:13 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40818 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3DQTpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130417095728.GA20829@tucsk.piliscsaba.szeredi.hu>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
	<CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
	<CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
	<CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
	<CAMbhsRR7iWabAgMqJ8g6FJK+SMAf_s0Rrz+wHiODzoB6joAzCw@mail.gmail.com>
	<20130417095728.GA20829@tucsk.piliscsaba.szeredi.hu>
Date: Wed, 17 Apr 2013 12:45:06 -0700
X-Google-Sender-Auth: s2bxNEOnm5GFzbddx586xNRfRp0
Message-ID: <CAMbhsRTwRSW_c5xSMC4Xk3aQFDoqXpcfspxoqOPiUmfPwNa1EQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Colin Cross <ccross@android.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 2:57 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Apr 16, 2013 at 01:00:37PM -0700, Colin Cross wrote:
>
>> Every other uapi header includes linux/types.h to get its type
>> definitions, and fuse.h should do the same when compiling for
>> userspace targeting linux
>
> Not necessarily.
>
> Here's a patch (largish but only search&replace) that should fix all the issues
> and actually removes a hack instead of adding more.
>
> Thanks,
> Miklos
> ----
>
> From: Miklos Szeredi <mszeredi@suse.cz>
> Subject: fuse: fix type definitions in uapi header
>
> Commit 7e98d53086d18c877cb44e9065219335184024de (Synchronize fuse
> header with one used in library) added #ifdef __linux__ around
> defines if it is not set.  The kernel build is self-contained and
> can be built on non-Linux toolchains.  After the mentioned commit
> builds on non-Linux toolchains will try to include stdint.h and
> fail due to -nostdinc, and then fail with a bunch of undefined
> type errors.
>
> Fix by checking for __KERNEL__ instead of __linux__ and using the standard int
> types instead of the linux specific ones.
>
> Reported-by: Arve Hjønnevåg <arve@android.com>
> Reported-by: Colin Cross <ccross@android.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

This fixes my build issue, and doesn't introduce a new make
headers_check warning so you can add my Tested-by: Colin Cross
<ccross@android.com>

I still like my patch better though.  This patch results in different
typedefs being used when compiling in userspace vs. kernel, so you're
trusting that the host stdint.h matches the kernel's definitions.  In
practice I don't see how they would differ, so I guess its up to you.
If it were up to me, I would use linux/types.h for kernel and linux
userspace, and maybe replace the #defines with typedefs for non-linux
userspace builds.
