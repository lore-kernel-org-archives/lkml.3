Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaAPE00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:26:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaAPE0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:26:22 -0500
Message-ID: <52D75F13.2060504@redhat.com>
Date: Thu, 16 Jan 2014 12:24:51 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] virtio-net: drop rq->max and rq->num
References: <1388134685-30691-1-git-send-email-jasowang@redhat.com>	<87mwixx670.fsf@rustcorp.com.au>	<87zjmwvlzl.fsf@rustcorp.com.au> <20140115.164649.533508366980529205.davem@davemloft.net>
In-Reply-To: <20140115.164649.533508366980529205.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 08:46 AM, David Miller wrote:
> From: Rusty Russell<rusty@rustcorp.com.au>
> Date: Thu, 16 Jan 2014 10:25:26 +1030
>
>> Rusty Russell<rusty@rustcorp.com.au>  writes:
>>> Jason Wang<jasowang@redhat.com>  writes:
>>>> It looks like there's no need for those two fields:
>>>>
>>>> - Unless there's a failure for the first refill try, rq->max should be always
>>>>    equal to the vring size.
>>>> - rq->num is only used to determine the condition that we need to do the refill,
>>>>    we could check vq->num_free instead.
>>>> - rq->num was required to be increased or decreased explicitly after each
>>>>    get/put which results a bad API.
>>>>
>>>> So this patch removes them both to make the code simpler.
>>> Nice.  These fields date from when the vq struct was opaque.
>>>
>>> Applied,
>>> Rusty.
>> Oops, this doesn't require any core virtio changes, so it's for DaveM:
>>
>> Acked-by: Rusty Russell<rusty@rustcorp.com.au>
> Jason please repost this with Rusty's ACK, thanks.

Sure, will repost.
