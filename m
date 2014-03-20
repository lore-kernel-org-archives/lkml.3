Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbaCTTWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:22:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51659 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670AbaCTTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:22:09 -0400
Message-ID: <532B3FDD.1090108@linaro.org>
Date: Thu, 20 Mar 2014 12:22:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org
CC: Hugh Dickins <hughd@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, dri-devel@lists.freedesktop.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 3/6] shm: add memfd_create() syscall
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com> <1395256011-2423-4-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1395256011-2423-4-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 12:06 PM, David Herrmann wrote:
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

This syscall would also be useful to Android, since it would satisfy the
requirement for providing atomically unlinked tmpfs fds that ashmem
provides (although upstreamed solutions to ashmem's other
functionalities are still needed).

My only comment is that I think memfd_* is sort of a new namespace.
Since this is providing shmem files, it seems it might be better named
something like shmfd_create() or my earlier suggestion of shmget_fd(). 
Otherwise, when talking about functionality like sealing, which is only
available on shmfs, we'll have to say "shmfs/tmpfs/memfd" or risk
confusing folks who might not initially grasp that its all the same
underneath.

thanks
-john







