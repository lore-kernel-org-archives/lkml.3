Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaKEIov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:44:51 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47767 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaKEIou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:44:50 -0500
Message-ID: <5459E343.6030907@linaro.org>
Date: Wed, 05 Nov 2014 09:43:47 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Liu <john.liuli@huawei.com>, Peter Maydell <peter.maydell@linaro.org>
CC: Joel Schopp <joel.schopp@amd.com>,
        Yingshiuan Pan <yingshiuan.pan@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, remy.gauguey@cea.fr,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>,
        QEMU Developers <qemu-devel@nongnu.org>, peter.huangpeng@huawei.com,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Qemu-devel] [RFC PATCH 0/2] virtio-mmio: add irqfd support for
 vhost-net based on virtio-mmio
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>	<CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com> <544E2B18.8010702@huawei.com>
In-Reply-To: <544E2B18.8010702@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 12:23 PM, Li Liu wrote:
> 
> 
> On 2014/10/27 17:37, Peter Maydell wrote:
>> On 25 October 2014 09:24, john.liuli <john.liuli@huawei.com> wrote:
>>> To get the interrupt reason to support such VIRTIO_NET_F_STATUS
>>> features I add a new register offset VIRTIO_MMIO_ISRMEM which
>>> will help to establish a shared memory region between qemu and
>>> virtio-mmio device. Then the interrupt reason can be accessed by
>>> guest driver through this region. At the same time, the virtio-mmio
>>> dirver check this region to see irqfd is supported or not during
>>> the irq handler registration, and different handler will be assigned.
>>
>> If you want to add a new register you should probably propose
>> an update to the virtio spec. However, it seems to me it would
>> be better to get generic PCI/PCIe working on the ARM virt
>> board instead; then we can let virtio-mmio quietly fade away.
>> This has been on the todo list for ages (and there have been
>> RFC patches posted for plain PCI), it's just nobody's had time
>> to work on it.
>>
>> thanks
>> -- PMM
>>
> 
> So you mean virtio-mmio will be replaced by PCI/PCIe on ARM at last?
> If so, let this patch go with the wind:). Thx.

Hi,

As a fix of current situation where ISR is only partially updated when
vhost-irqfd handles standard IRQ and waiting for PCI emuluation,
wouldn't it make sense to store ISR content on vhost driver side and
introduce ioctls to read/write it. When using vhost BE, virtio QEMU
device would use those ioctl to read/update the ISR content. On top of
that we would update the ISR in vhost before triggering the irqfd. If I
do not miss anything this would at least make things functional with irqfd.

As a second step, we could try to introduce in-kernel emulation of
ISR/ACK to fix the performance issue related to going to user-side each
time ISR/ACK accesses are done.

Do you think it is worth investigating this direction?

Thank you in advance

Best Regards

Eric


> 
> Li.
>> .
>>
> 
> 

