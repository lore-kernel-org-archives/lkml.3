Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaJ0Jhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:37:32 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:59029 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJ0Jhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:37:31 -0400
MIME-Version: 1.0
In-Reply-To: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2014 09:37:09 +0000
Message-ID: <CAFEAcA9o8ZsbUvZb7Yp9JeO__bRLOrYcyfj4Ug4Se_rDF0y4TA@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC PATCH 0/2] virtio-mmio: add irqfd support for
 vhost-net based on virtio-mmio
To: "john.liuli" <john.liuli@huawei.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Schopp <joel.schopp@amd.com>,
        Yingshiuan Pan <yingshiuan.pan@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, remy.gauguey@cea.fr,
        Rusty Russell <rusty@rustcorp.com.au>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        peter.huangpeng@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2014 09:24, john.liuli <john.liuli@huawei.com> wrote:
> To get the interrupt reason to support such VIRTIO_NET_F_STATUS
> features I add a new register offset VIRTIO_MMIO_ISRMEM which
> will help to establish a shared memory region between qemu and
> virtio-mmio device. Then the interrupt reason can be accessed by
> guest driver through this region. At the same time, the virtio-mmio
> dirver check this region to see irqfd is supported or not during
> the irq handler registration, and different handler will be assigned.

If you want to add a new register you should probably propose
an update to the virtio spec. However, it seems to me it would
be better to get generic PCI/PCIe working on the ARM virt
board instead; then we can let virtio-mmio quietly fade away.
This has been on the todo list for ages (and there have been
RFC patches posted for plain PCI), it's just nobody's had time
to work on it.

thanks
-- PMM
