Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaCZXfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:35:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaCZXfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:35:12 -0400
Message-ID: <53336425.6030409@oracle.com>
Date: Wed, 26 Mar 2014 19:35:01 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: davem@davemloft.net, hannes@stressinduktion.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] random32: avoid attempt to late reseed if in the middle
 of seeding
References: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com> <53336049.4060901@redhat.com>
In-Reply-To: <53336049.4060901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 07:18 PM, Daniel Borkmann wrote:
> On 03/26/2014 06:12 PM, Sasha Levin wrote:
>> Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
>> nonblocking pool becomes initialized") has added a late reseed stage
>> that happens as soon as the nonblocking pool is marked as initialized.
>>
>> This fails in the case that the nonblocking pool gets initialized
>> during __prandom_reseed()'s call to get_random_bytes(). In that case
>> we'd double back into __prandom_reseed() in an attempt to do a late
>> reseed - deadlocking on 'lock' early on in the boot process.
>>
>> Instead, just avoid even waiting to do a reseed if a reseed is already
>> occuring.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>
> Thanks for catching! (If you want Dave to pick it up, please also
> Cc netdev.)
>
> Why not via spin_trylock_irqsave() ? Thus, if we already hold the
> lock, we do not bother any longer with doing the same work twice
> and just return.

Your code looks much better, I'll should really stop sending patches
too early in the morning...

It's also worth adding lib/random32.c to the MAINTAINERS file, as my
list of recipients is solely based on what get_maintainer.pl tells
me to do (and I'm assuming that I'm not the last person who will be
sending patches for this).


Thanks,
Sasha
