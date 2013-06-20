Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238Ab3FTLzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:55:38 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48870 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030215Ab3FTLzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:55:37 -0400
Date: Thu, 20 Jun 2013 13:55:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, daniel@ffwll.ch, tglx@linutronix.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 2/7] mutex: add support for wound/wait style locks, v5
Message-ID: <20130620115532.GA12479@gmail.com>
References: <20130620112811.4001.86934.stgit@patser>
 <20130620113111.4001.47384.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620113111.4001.47384.stgit@patser>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> Changes since RFC patch v1:
>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>  - removed mutex_locked_set_reservation_id (or w/e it was called)
> Changes since RFC patch v2:
>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>    mutex_(,reserve_)lock/unlock.
> Changes since v1:
>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>    for the constant 0 in that case. Tests for this have been added in the next patch.
>  - Updated documentation slightly.
> Changes since v2:
>  - Renamed everything to ww_mutex. (mlankhorst)
>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>  - Added a lot of checks for wrong api usage. (mlankhorst)
>  - Documentation updates. (danvet)
> Changes since v3:
>  - Small documentation fixes (robclark)
>  - Memory barrier fix (danvet)
> Changes since v4:
>  - Remove ww_mutex_unlock_single and ww_mutex_lock_single.
>  - Rename ww_mutex_trylock_single to ww_mutex_trylock.
>  - Remove separate implementations of ww_mutex_lock_slow*, normal
>    functions can be used. Inline versions still exist for extra
>    debugging.
>  - Cleanup unneeded memory barriers, add comment to the remaining
>    smp_mb().

That's not a proper changelog. It should be a short description of what it 
does, possibly referring to the new Documentation/ww-mutex-design.txt file 
for more details.

> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Rob Clark <robdclark@gmail.com>

That's not a valid signoff chain: the last signoff in the chain is the 
person sending me the patch. The first signoff is the person who wrote the 
patch. The other two gents should be Acked-by I suspect?

Thanks,

	Ingo
