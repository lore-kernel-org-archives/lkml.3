Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbbADIiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 03:38:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbADIiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 03:38:20 -0500
Message-ID: <54A8FBF9.7000105@redhat.com>
Date: Sun, 04 Jan 2015 16:38:17 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Sharing MSIX irq for tx/rx queue pairs
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com> <20141228075226.GA25704@redhat.com>
In-Reply-To: <20141228075226.GA25704@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/28/2014 03:52 PM, Michael S. Tsirkin wrote:
> On Fri, Dec 26, 2014 at 10:53:42AM +0800, Jason Wang wrote:
>> Hi all:
>>
>> This series try to share MSIX irq for each tx/rx queue pair. This is
>> done through:
>>
>> - introducing virtio pci channel which are group of virtqueues that
>>   sharing a single MSIX irq (Patch 1)
>> - expose channel setting to virtio core api (Patch 2)
>> - try to use channel setting in virtio-net (Patch 3)
>>
>> For the transport that does not support channel, channel paramters
>> were simply ignored. For devices that does not use channel, it can
>> simply pass NULL or zero to virito core.
>>
>> With the patch, 1 MSIX irq were saved for each TX/RX queue pair.
>>
>> Please review.
> How does this sharing affect performance?
>

Patch 3 only checks more_used() for tx ring which in fact reduces the
effect of event index and may introduce more tx interrupts. After fixing
this issue, tested with 1 vcpu and 1 queue. No obvious changes in
performance were noticed.

Thanks

