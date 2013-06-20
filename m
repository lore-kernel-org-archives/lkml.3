Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3FTMQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:16:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42126 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3FTMQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:16:37 -0400
Message-ID: <51C2F2A0.3080606@canonical.com>
Date: Thu, 20 Jun 2013 14:16:32 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, daniel@ffwll.ch, tglx@linutronix.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 2/7] mutex: add support for wound/wait style locks,
 v5
References: <20130620112811.4001.86934.stgit@patser> <20130620113111.4001.47384.stgit@patser> <20130620115532.GA12479@gmail.com>
In-Reply-To: <20130620115532.GA12479@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 20-06-13 13:55, Ingo Molnar schreef:
> * Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>
>> Changes since RFC patch v1:
>>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>>  - removed mutex_locked_set_reservation_id (or w/e it was called)
>> Changes since RFC patch v2:
>>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>>    mutex_(,reserve_)lock/unlock.
>> Changes since v1:
>>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>>    for the constant 0 in that case. Tests for this have been added in the next patch.
>>  - Updated documentation slightly.
>> Changes since v2:
>>  - Renamed everything to ww_mutex. (mlankhorst)
>>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>>  - Added a lot of checks for wrong api usage. (mlankhorst)
>>  - Documentation updates. (danvet)
>> Changes since v3:
>>  - Small documentation fixes (robclark)
>>  - Memory barrier fix (danvet)
>> Changes since v4:
>>  - Remove ww_mutex_unlock_single and ww_mutex_lock_single.
>>  - Rename ww_mutex_trylock_single to ww_mutex_trylock.
>>  - Remove separate implementations of ww_mutex_lock_slow*, normal
>>    functions can be used. Inline versions still exist for extra
>>    debugging.
>>  - Cleanup unneeded memory barriers, add comment to the remaining
>>    smp_mb().
> That's not a proper changelog. It should be a short description of what it 
> does, possibly referring to the new Documentation/ww-mutex-design.txt file 
> for more details.
Well they've helped me with some of the changes and contributed some code and/or fixes, but if acked-by is preferred I'll use that..
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Signed-off-by: Rob Clark <robdclark@gmail.com>
> That's not a valid signoff chain: the last signoff in the chain is the 
> person sending me the patch. The first signoff is the person who wrote the 
> patch. The other two gents should be Acked-by I suspect?
>
I guess so.
