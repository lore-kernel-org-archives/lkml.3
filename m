Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3E0SYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 14:24:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab3E0SYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 14:24:01 -0400
Message-ID: <51A39F23.2080507@redhat.com>
Date: Mon, 27 May 2013 14:00:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] ipc/sem.c: Always use only one queue for alter operations.
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-4-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369559335-13491-4-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:08 AM, Manfred Spraul wrote:
> There are two places that can contain alter operations:
> - the global queue: sma->pending_alter
> - the per-semaphore queues: sma->sem_base[].pending_alter.
>
> Since one of the queues must be processed first, this causes an odd
> priorization of the wakeups:
> Right now, complex operations have priority over simple ops.
>
> The patch restores the behavior of linux <=3.0.9: The longest
> waiting operation has the highest priority.
>
> This is done by using only one queue:
> - if there are complex ops, then sma->pending_alter is used.
> - otherwise, the per-semaphore queues are used.
>
> As a side effect, do_smart_update_queue() becomes much simpler:
> No more goto logic.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

This is the one where I really wonder whether the
complexity is warranted.

Again, the code does look correct.

Acked-by: Rik van Riel <riel@redhat.com>

