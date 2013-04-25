Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab3DYM4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:56:14 -0400
Received: from shelob.surriel.com ([74.92.59.67]:46770 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3DYM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:56:12 -0400
Message-ID: <517927E2.1090907@surriel.com>
Date: Thu, 25 Apr 2013 08:56:02 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ipc: make refcounter atomic (was Re: linux-next:
 Tree for Apr 23 [ Call-Traces: lib/debugobjects.c | kernel/rcupdate.c | kernel/rcutree.c
 ])
References: <CA+icZUWXpaXi9GwB37hLaPbZaAi2aOMXez1f79DDtb_22ZY1jQ@mail.gmail.com> <CA+icZUXmsvbj2km=PxbAs5K+hoP+zjcXqG_wCdKR9akWF5Eucw@mail.gmail.com> <CA+55aFw5J+DFgQjAdhUnhitHw+wHEmspeZP9jbyZowqNE6Nafg@mail.gmail.com> <CA+icZUXHkcj_bAuPcfghZMHjRTud2jN91hjpOUiLaXd0yN9diw@mail.gmail.com> <1366741069.1802.12.camel@buesod1.americas.hpqcorp.net> <1366741394.1802.13.camel@buesod1.americas.hpqcorp.net> <CA+icZUV48SZeNt4GRKi8yDKbsO_c7ApUOgb4mRX67=d_ridE8w@mail.gmail.com> <CA+55aFxh_-3BSBXrm8j1-3bN_oLLA66ApykRcfFFKRvrb6MDkQ@mail.gmail.com> <1366841773.1790.7.camel@buesod1.americas.hpqcorp.net> <CA+icZUUY1U=gxxT8hbU-JyyuoRgaht=KUwttQT=yh4_Yh32VnQ@mail.gmail.com>
In-Reply-To: <CA+icZUUY1U=gxxT8hbU-JyyuoRgaht=KUwttQT=yh4_Yh32VnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 07:05 PM, Sedat Dilek wrote:
> On Thu, Apr 25, 2013 at 12:16 AM, Davidlohr Bueso
> <davidlohr.bueso@hp.com> wrote:

>> This patch converts the IPC RCU header's reference counter to atomic_t. The return of
>> ipc_rcu_getref() is modified to inform the callers if it actually succeeded.
>>
>> Now all callers return -EIDRM upon failure and abort the current operation. Two exceptions are
>> in semaphore code where sem_getref_and_unlock() and sem_getref() trigger a warning but proceed
>> to freeing up any held locks.
>>
>> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
>> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: Rik van Riel <riel@surriel.com>
>> CC: Paul McKenney <paul.mckenney@linaro.org>
>> CC: Sedat Dilek <sedat.dilek@gmail.com>
>> CC: Emmanuel Benisty <benisty.e@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>
> Missing my Reported-by ...!

> ...so please add also my Tested-by!

And my ax!

I mean ... Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
