Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3C1U4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3C1U4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:56:24 -0400
Message-ID: <5154AE1E.6000007@redhat.com>
Date: Thu, 28 Mar 2013 16:54:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/13] rwsem: more agressive lock stealing in rwsem_down_write_failed
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-7-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-7-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> Some small code simplifications can be achieved by doing more agressive
> lock stealing:
>
> - When rwsem_down_write_failed() notices that there are no active locks
>    (and thus no thread to wake us if we decided to sleep), it used to wake
>    the first queued process. However, stealing the lock is also sufficient
>    to deal with this case, so we don't need this check anymore.
>
> - In try_get_writer_sem(), we can steal the lock even when the first waiter
>    is a reader. This is correct because the code path that wakes readers is
>    protected by the wait_lock. As to the performance effects of this change,
>    they are expected to be minimal: readers are still granted the lock
>    (rather than having to acquire it themselves) when they reach the front
>    of the wait queue, so we have essentially the same behavior as in
>    rwsem-spinlock.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

