Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3C1Uem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3C1Uel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:34:41 -0400
Message-ID: <5154A8FF.4050504@redhat.com>
Date: Thu, 28 Mar 2013 16:33:03 -0400
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
Subject: Re: [PATCH v2 05/13] rwsem: simplify rwsem_down_write_failed
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-6-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-6-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> When waking writers, we never grant them the lock - instead, they have
> to acquire it themselves when they run, and remove themselves from the
> wait_list when they succeed.
>
> As a result, we can do a few simplifications in rwsem_down_write_failed():
>
> - We don't need to check for !waiter.task since __rwsem_do_wake() doesn't
>    remove writers from the wait_list
>
> - There is no point releaseing the wait_lock before entering the wait loop,
>    as we will need to reacquire it immediately. We can change the loop so
>    that the lock is always held at the start of each loop iteration.
>
> - We don't need to get a reference on the task structure, since the task
>    is responsible for removing itself from the wait_list. There is no risk,
>    like in the rwsem_down_read_failed() case, that a task would wake up and
>    exit (thus destroying its task structure) while __rwsem_do_wake() is
>    still running - wait_lock protects against that.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

