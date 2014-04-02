Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbaDBNii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:38:38 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:62782 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676AbaDBNig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <1395256011-2423-4-git-send-email-dh.herrmann@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<1395256011-2423-4-git-send-email-dh.herrmann@gmail.com>
Date: Wed, 2 Apr 2014 17:38:35 +0400
Message-ID: <CALYGNiPnAVf+wSsdn4aO=89H_HqyjL_-vNHpZdop=Wchf7gTtw@mail.gmail.com>
Subject: Re: [PATCH 3/6] shm: add memfd_create() syscall
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 11:06 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
> that you can pass to mmap(). It explicitly allows sealing and
> avoids any connection to user-visible mount-points. Thus, it's not
> subject to quotas on mounted file-systems, but can be used like
> malloc()'ed memory, but with a file-descriptor to it.
>
> memfd_create() does not create a front-FD, but instead returns the raw
> shmem file, so calls like ftruncate() can be used. Also calls like fstat()
> will return proper information and mark the file as regular file. Sealing
> is explicitly supported on memfds.
>
> Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
> subject to quotas and alike.

Instead of adding new syscall we can extend existing openat() a little
bit more:

openat(AT_FDSHM, "name", O_TMPFILE | O_RDWR, 0666)
