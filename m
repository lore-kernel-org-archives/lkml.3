Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3E0Rv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:51:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab3E0Rv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:51:27 -0400
Message-ID: <51A39D19.4070400@redhat.com>
Date: Mon, 27 May 2013 13:51:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] ipc/sem.c: Fix missing wakeups in do_smart_update_queue()
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-2-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1369559335-13491-2-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:08 AM, Manfred Spraul wrote:
> do_smart_update_queue() is called when an operation
> (semop, semctl(SETVAL), semctl(SETALL), ...) modified the array.
> It must check which of the sleeping tasks can proceed.
>
> do_smart_update_queue() missed a few wakeups:
> - if a sleeping complex op was completed, then all per-semaphore queues
>    must be scanned - not only those that were modified by *sops
> - if a sleeping simple op proceeded, then the global queue
>    must be scanned again
>
> And:
> - the test for "|sops == NULL) before scanning the global
>    queue is not required: If the global queue is empty, then
>    it doesn't need to be scanned - regardless of the reason
>    for calling do_smart_update_queue()
>
> The patch is not optimized, i.e. even completing a wait-for-zero
> operation causes a rescan. This is done to keep the patch as simple as
> possible.
> Avoiding unnecessary scans is implemented in the following patches.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Very much not optimized, but we need to fix the regression.

Acked-by: Rik van Riel <riel@redhat.com>

