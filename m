Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3C1TFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3C1TFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:05:18 -0400
Message-ID: <51549416.4000401@redhat.com>
Date: Thu, 28 Mar 2013 15:03:50 -0400
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
Subject: Re: [PATCH v2 02/13] rwsem: shorter spinlocked section in rwsem_down_failed_common()
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-3-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> This change reduces the size of the spinlocked and TASK_UNINTERRUPTIBLE
> sections in rwsem_down_failed_common():
>
> - We only need the sem->wait_lock to insert ourselves on the wait_list;
>    the waiter node can be prepared outside of the wait_lock.
>
> - The task state only needs to be set to TASK_UNINTERRUPTIBLE immediately
>    before checking if we actually need to sleep; it doesn't need to protect
>    the entire function.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

Feel free to keep this Reviewed-by: line across cosmetic
changes.
