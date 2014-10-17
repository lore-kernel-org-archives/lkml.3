Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaJQFXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 01:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaJQFXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 01:23:50 -0400
Message-ID: <5440A7DE.5030806@redhat.com>
Date: Fri, 17 Oct 2014 13:23:42 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next RFC 1/3] virtio: support for urgent descriptors
References: <1413011806-3813-1-git-send-email-jasowang@redhat.com> <1413011806-3813-2-git-send-email-jasowang@redhat.com> <877g01c2ml.fsf@rustcorp.com.au>
In-Reply-To: <877g01c2ml.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 01:40 PM, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
>> Below should be useful for some experiments Jason is doing.
>> I thought I'd send it out for early review/feedback.
>>
>> event idx feature allows us to defer interrupts until
>> a specific # of descriptors were used.
>> Sometimes it might be useful to get an interrupt after
>> a specific descriptor, regardless.
>> This adds a descriptor flag for this, and an API
>> to create an urgent output descriptor.
>> This is still an RFC:
>> we'll need a feature bit for drivers to detect this,
>> but we've run out of feature bits for virtio 0.X.
>> For experimentation purposes, drivers can assume
>> this is set, or add a driver-specific feature bit.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> The new VRING_DESC_F_URGENT bit is theoretically nicer, but for
> networking (which tends to take packets in order) couldn't we just set
> the event counter to give us a tx interrupt at the packet we want?
>
> Cheers,
> Rusty.

Yes, we could. Recent RFC of enabling tx interrupt use this.
