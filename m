Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaEaF1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 01:27:18 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41001 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaEaF1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 01:27:10 -0400
Message-ID: <538966B2.9030007@gmail.com>
Date: Sat, 31 May 2014 07:20:50 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>
CC: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de
Subject: Re: [PATCH 0/3] ipc: Further updates to sysv/mqueue limits
References: <1401389200-6758-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1401389200-6758-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 08:46 PM, Manfred Spraul wrote:
> Hi all,
> 
> a) If we increase SHMMAX/SHMALL, then it makes sense to
>    increase MSGMNI, too.
>    And: This allows to remove the automatic scaling (~300 lines)
> 
> b) We can also increase SEMMSL, SEMMNI and SEMOPM
> 
> c) I think it would make more sense if a namespace starts with the
>    limits from it's parent:
>    If an admin set the limits, then he probably wants that these limits also
>    apply for a new child namespace.

Hi Manfred,

This these patches change the API/ABI, could you CC linux-api [1] for future
iterations.

Cheers,

Michael

[1] https://www.kernel.org/doc/man-pages/linux-api-ml.html


> All patches are RFC - they compile, but that's it.
> 
> TODO:
> - check if the sysv sem limits are sane.
>   Especially the SEMOPM - if real users exist that pass > 1k ops, then
>   switch from kmalloc to vmalloc.
> 
>   @the Redhat developers: Do you have any idea where this "often
>   recommended" comes from?
>   https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-The_SEMOPM_Parameter.html
> 
> - copy Davidlohrs explanation for the sysv shm limits to sysv msg and
>   sysv sem.
> 
> - check if we should also increase the limits for posix mqueue
> 
> - decide if it would make sense to increase IPCMNI:
> 
>   Right now, it is 32768. This means that after 65536 pairs of
>   semget()/semctl(IPC_RMID), semget() will return the same identifier
>   again - and a semop(old_id) won't return -EINVAL, instead it will
>   access the "new" array, which is probably now what the caller
>   intended to do.
> 
>   The split is arbitrary - we could also split it 1048576/2048 or any
>   other split we want.
> 
> - test everything.
> 
> --
> 	Manfred
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
