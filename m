Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175Ab3DOVrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:47:12 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:61217 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3DOVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <1366058481-21033-1-git-send-email-ccross@android.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
Date: Mon, 15 Apr 2013 14:47:10 -0700
X-Google-Sender-Auth: C6nSUxUUOx6zK8-BBi2XmeDedqY
Message-ID: <CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Colin Cross <ccross@android.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Cross <ccross@android.com>, Miklos Szeredi <miklos@szeredi.hu>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 1:41 PM, Colin Cross <ccross@android.com> wrote:
> Commit 7e98d53086d18c877cb44e9065219335184024de (Synchronize fuse
> header with one used in library) added #ifdef __linux__ around
> defines if it is not set.  The kernel build is self-contained and
> can be built on non-Linux toolchains.  After the mentioned commit
> builds on non-Linux toolchains will try to include stdint.h and
> fail due to -nostdinc, and then fail with a bunch of undefined
> type errors.
>
> Change the #ifdef to check for __linux__ or __KERNEL__ so that
> it uses the kernel typedefs if __KERNEL__ is set.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
> I think this should go in v3.9, without it bare-metal toolchains
> that don't define __linux__ will fail to compile the kernel, and
> cross-compiles from non-linux hosts will probably also fail.

Miklos, I see Arve sent an equivalent patch to you a month ago
(https://lkml.org/lkml/2013/3/11/620), and I agree with his response
to your question (checking for __linux__ and __KERNEL__ is better than
just checking for __KERNEL__ if you want this header to be used in
userspace builds on linux targets).  Can you pull one of these two
patches before 3.9?
