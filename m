Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaIVORe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:17:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49557 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIVORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:17:31 -0400
Message-ID: <54202F75.8080401@kernel.dk>
Date: Mon, 22 Sep 2014 08:17:25 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>, tom.leiming@gmail.com
CC: David Hildenbrand <dahi@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, ppinatti@linux.vnet.ibm.com
Subject: Re: [PATCH] blk-mq: Avoid race condition with uninitialized requests
References: <1411031071-40390-1-git-send-email-dahi@linux.vnet.ibm.com> <1411031071-40390-2-git-send-email-dahi@linux.vnet.ibm.com> <54202EF8.4080909@de.ibm.com>
In-Reply-To: <54202EF8.4080909@de.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-22 08:15, Christian Borntraeger wrote:
> On 09/18/2014 11:04 AM, David Hildenbrand wrote:
>> This patch should fix the bug reported in https://lkml.org/lkml/2014/9/11/249.
>>
>> We have to initialize at least the atomic_flags and the cmd_flags when
>> allocating storage for the requests.
>>
>> Otherwise blk_mq_timeout_check() might dereference uninitialized pointers when
>> racing with the creation of a request.
>>
>> Also move the reset of cmd_flags for the initializing code to the point where a
>> request is freed. So we will never end up with pending flush request indicators
>> that might trigger dereferences of invalid pointers in blk_mq_timeout_check().
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>
> Can you please add
> Reported-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
> Tested-by: Paulo De Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
>
> as Paulo did the testing work?
>
> We thing this patch is fine and should go upstream.

I might have to pick'n rebase the series, in which case I'll add it. But 
I already queued it up last week, so if I don't, then I can't easily add 
it. I wish the git notes wasn't such a horrible and unusable hack, so we 
had a chance to annotate commits without having to rewrite history...

-- 
Jens Axboe

