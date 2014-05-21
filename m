Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaEUKuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:50:21 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44915 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <1397587118-1214-3-git-send-email-dh.herrmann@gmail.com>
References: <1397587118-1214-1-git-send-email-dh.herrmann@gmail.com>
	<1397587118-1214-3-git-send-email-dh.herrmann@gmail.com>
Date: Wed, 21 May 2014 14:50:19 +0400
Message-ID: <CALYGNiM5dVhW9rp8Xpbu=DpENobUtRpRNTteJXbg1s99_STNiw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] shm: add memfd_create() syscall
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:38 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
> that you can pass to mmap(). It can support sealing and avoids any
> connection to user-visible mount-points. Thus, it's not subject to quotas
> on mounted file-systems, but can be used like malloc()'ed memory, but
> with a file-descriptor to it.
>
> memfd_create() does not create a front-FD, but instead returns the raw
> shmem file, so calls like ftruncate() can be used. Also calls like fstat()
> will return proper information and mark the file as regular file. If you
> want sealing, you can specify MFD_ALLOW_SEALING. Otherwise, sealing is not
> support (like on all other regular files).
>
> Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
> subject to quotas and alike.
>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---

<cut>

> +++ b/include/linux/syscalls.h
> @@ -802,6 +802,7 @@ asmlinkage long sys_timerfd_settime(int ufd, int flags,
>  asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
>  asmlinkage long sys_eventfd(unsigned int count);
>  asmlinkage long sys_eventfd2(unsigned int count, int flags);
> +asmlinkage long sys_memfd_create(const char *uname_ptr, u64 size, u64 flags);

Is it right to use u64 here? I think arguments sould be 'loff_t' and 'int'.

>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
>  asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
>  asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
