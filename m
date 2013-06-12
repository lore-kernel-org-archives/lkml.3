Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3FLHoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:44:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3FLHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:43:49 -0400
Message-ID: <51B826B2.5000508@canonical.com>
Date: Wed, 12 Jun 2013 09:43:46 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 0/4] add mutex wait/wound/style style locks
References: <20130528144420.4538.70725.stgit@patser>
In-Reply-To: <20130528144420.4538.70725.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-05-13 16:48, Maarten Lankhorst schreef:
> Version 4 already?
>
> Small api changes since v3:
> - Remove ww_mutex_unlock_single and ww_mutex_lock_single.
> - Rename ww_mutex_trylock_single to ww_mutex_trylock.
> - Remove separate implementations of ww_mutex_lock_slow*, normal
>   functions can be used. Inline versions still exist for extra
>   debugging, and to annotate.
> - Cleanup unneeded memory barriers, add comment to the remaining
>   smp_mb().
>
> Thanks to Daniel Vetter, Rob Clark and Peter Zijlstra for their feedback.
> ---
>
> Daniel Vetter (1):
>       mutex: w/w mutex slowpath debugging
>
> Maarten Lankhorst (3):
>       arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
>       mutex: add support for wound/wait style locks, v5
>       mutex: Add ww tests to lib/locking-selftest.c. v4
>
>
>  Documentation/ww-mutex-design.txt |  344 +++++++++++++++++++++++++++++++
>  arch/ia64/include/asm/mutex.h     |   10 -
>  arch/powerpc/include/asm/mutex.h  |   10 -
>  arch/sh/include/asm/mutex-llsc.h  |    4 
>  arch/x86/include/asm/mutex_32.h   |   11 -
>  arch/x86/include/asm/mutex_64.h   |   11 -
>  include/asm-generic/mutex-dec.h   |   10 -
>  include/asm-generic/mutex-null.h  |    2 
>  include/asm-generic/mutex-xchg.h  |   10 -
>  include/linux/mutex-debug.h       |    1 
>  include/linux/mutex.h             |  363 +++++++++++++++++++++++++++++++++
>  kernel/mutex.c                    |  384 ++++++++++++++++++++++++++++++++---
>  lib/Kconfig.debug                 |   13 +
>  lib/debug_locks.c                 |    2 
>  lib/locking-selftest.c            |  410 +++++++++++++++++++++++++++++++++++--
>  15 files changed, 1492 insertions(+), 93 deletions(-)
>  create mode 100644 Documentation/ww-mutex-design.txt
>
Bump, do you have any feedback peterz?
