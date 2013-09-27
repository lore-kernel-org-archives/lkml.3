Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3I0Fuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:50:51 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57767 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3I0Fut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:50:49 -0400
Message-ID: <52451CB4.20004@colorfullife.com>
Date: Fri, 27 Sep 2013 07:50:44 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ipc,msg: prevent race with rmid in msgsnd,msgrcv
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com> <1379300677-24188-5-git-send-email-davidlohr@hp.com>
In-Reply-To: <1379300677-24188-5-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Could you include the patch in -mm and push it towards Linus?

On 09/16/2013 05:04 AM, Davidlohr Bueso wrote:
> This fixes a race in both msgrcv() and msgsnd() between finding the msg and
> actually dealing with the queue, as another thread can delete shmid
> underneath us if we are preempted before acquiring the kern_ipc_perm.lock.
>
> Manfred illustrates this nicely:
>
> Assume a preemptible kernel that is preempted just after
>> msq = msq_obtain_object_check(ns, msqid)
> in do_msgrcv().
> The only lock that is held is rcu_read_lock().
>
> Now the other thread processes IPC_RMID.
> When the first task is resumed, then it will happily wait for messages on a
> deleted queue.
>
> Fix this by checking for if the queue has been deleted after taking the lock.
>
> Reported-by: Manfred Spraul <manfred@colorfullife.com>
> Cc: stable@vger.kernel.org # for 3.11
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

