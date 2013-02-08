Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947448Ab3BHX4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:56:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29170 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947361Ab3BHX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:56:07 -0500
Message-ID: <5115908A.2000302@oracle.com>
Date: Fri, 08 Feb 2013 18:55:54 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jamie Iles <jamie.iles@oracle.com>
CC: mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] liblockdep: support using LD_PRELOAD
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com> <1360188694-25077-10-git-send-email-sasha.levin@oracle.com> <20130207102843.GG17781@cedar> <5113BABA.6010306@oracle.com> <20130208104318.GG3468@cedar>
In-Reply-To: <20130208104318.GG3468@cedar>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 05:43 AM, Jamie Iles wrote:
> On Thu, Feb 07, 2013 at 09:31:22AM -0500, Sasha Levin wrote:
>> On 02/07/2013 05:28 AM, Jamie Iles wrote:
>>>> +int pthread_rwlock_init(pthread_rwlock_t *rwlock,
>>>>> +			const pthread_rwlockattr_t *attr)
>>>>> +{
>>>>> +	if (ll_pthread_rwlock_init == NULL)
>>>>> +		init_preload();
>>> Why is this one special, doesn't init_preload being a constructor make 
>>> this redundant?
>>
>> I was testing it on different things, and stumbled on an interesting case:
>> when pthread_mutex was taken from the constructor of a different module.
>>
>> In that case, the other constructor would try to init the mutex and take
>> a lock, but we would segfault because we haven't resolved the pthread
>> symbols yet ourselves (since our constructor was yet to be called).
> 
> Okay, that makes sense, but shouldn't we do this for all of the lock 
> operations?  pthread locks can be statically initialized and they are 
> initializaed lazily on the first access so I think that this could 
> happen on any of the lock operations.

hmm... I've had it only in init() because I thought it doesn't make sense
to actually lock/unlock in constructor code, but yeah - better safe than
sorry.


Thanks,
Sasha

