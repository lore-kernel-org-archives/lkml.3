Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbbAEFKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 00:10:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbAEFKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 00:10:16 -0500
Message-ID: <54AA1CB6.9020109@redhat.com>
Date: Mon, 05 Jan 2015 13:10:14 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Sharing MSIX irq for tx/rx queue pairs
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com> <87ppauovjb.fsf@rustcorp.com.au>
In-Reply-To: <87ppauovjb.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/05/2015 09:39 AM, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
>> Hi all:
>>
>> This series try to share MSIX irq for each tx/rx queue pair. This is
>> done through:
>>
>> - introducing virtio pci channel which are group of virtqueues that
>>   sharing a single MSIX irq (Patch 1)
>> - expose channel setting to virtio core api (Patch 2)
>> - try to use channel setting in virtio-net (Patch 3)
> Hi Jason,
>
>         Is "channel" a term you created yourself, or something I was
> just unaware of?  

By myself and probably not accurate.
> irq_group would seem more obvious, if the former.
>

Yes, will use this in next version. Thanks.
>> For the transport that does not support channel, channel paramters
>> were simply ignored. For devices that does not use channel, it can
>> simply pass NULL or zero to virito core.
>>
>> With the patch, 1 MSIX irq were saved for each TX/RX queue pair.
> It seems fairly straightforward.
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Thanks,
> Rusty.
> --

