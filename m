Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632Ab3BNUNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:13:35 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:37640 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:13:33 -0500
MIME-Version: 1.0
In-Reply-To: <511D0E77.2090907@parallels.com>
References: <511D0E50.7090505@parallels.com> <511D0E77.2090907@parallels.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 14 Feb 2013 15:13:11 -0500
Message-ID: <CA+1xoqdk5PArnjSnu=7gUq_4got09a0PxBd4Yy=inezPTGsdAA@mail.gmail.com>
Subject: Re: [PATCH 1/3] posix timers: Allocate timer id per process
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:19 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> From: Stanislav Kinsbursky <skinsbursky@parallels.com>
>
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per process. Next free timer id is
> type of integer and stored on signal struct (posix_timer_id). If free timer
> id reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
>
> Hash table has 512 slots.
> Key is constructed as follows:
> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
>
> Note: with this patch, id, returned to user, is not the minimal free
> amymore. It means, that id, returned to user space in loop, listed below, will
> be increasing on each iteration till INT_MAX and then dropped to zero:
>
> while(1) {
>         id = timer_create(...);
>         timer_delete(id);
> }
>
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

Hi Pavel,

Why not use linux/hashtable.h?


Thanks,
Sasha
