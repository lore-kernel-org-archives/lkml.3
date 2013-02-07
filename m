Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab3BGXOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:14:12 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40807 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3BGXOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:14:10 -0500
Message-ID: <5114353D.1060202@linaro.org>
Date: Thu, 07 Feb 2013 15:14:05 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
References: <1358896415-28569-1-git-send-email-walken@google.com> <1358896415-28569-2-git-send-email-walken@google.com> <20130207223434.GG2545@linux.vnet.ibm.com>
In-Reply-To: <20130207223434.GG2545@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 02:34 PM, Paul E. McKenney wrote:
> On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
>> Introduce queue spinlocks, to be used in situations where it is desired
>> to have good throughput even under the occasional high-contention situation.
>>
>> This initial implementation is based on the classic MCS spinlock,
>> because I think this represents the nicest API we can hope for in a
>> fast queue spinlock algorithm. The MCS spinlock has known limitations
>> in that it performs very well under high contention, but is not as
>> good as the ticket spinlock under low contention. I will address these
>> limitations in a later patch, which will propose an alternative,
>> higher performance implementation using (mostly) the same API.
>>
>> Sample use case acquiring mystruct->lock:
>>
>>    struct q_spinlock_node node;
>>
>>    q_spin_lock(&mystruct->lock, &node);
>>    ...
>>    q_spin_unlock(&mystruct->lock, &node);
> It is possible to keep the normal API for MCS locks by having the lock
> holder remember the parameter in the lock word itself.  While spinning,
> the node is on the stack, is not needed once the lock is acquired.
> The pointer to the next node in the queue -is- needed, but this can be
> stored in the lock word.
>
> I believe that John Stultz worked on something like this some years back,
> so added him to CC.
Oh yea, its been quite awhile.

Here are some of the discussion threads google remembers for me:

http://marc.info/?l=lse-tech&m=101227079817027&w=2

http://marc.info/?l=lse-tech&m=101380783015065&w=2  (missing the patch)
     http://marc.info/?l=lse-tech&m=101380783615084&w=2 (patch for above)


thanks
-john


