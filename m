Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaKEIA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:00:58 -0500
Received: from [119.145.14.65] ([119.145.14.65]:40665 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKEIA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:00:57 -0500
Message-ID: <5459D8E8.6060709@huawei.com>
Date: Wed, 5 Nov 2014 15:59:36 +0800
From: Shannon Zhao <zhaoshenglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <mst@redhat.com>, <peter.maydell@linaro.org>, <john.liuli@huawei.com>,
        <joel.schopp@amd.com>, <remy.gauguey@cea.fr>, <qemu-devel@nongnu.org>,
        <n.nikolaev@virtualopensystems.com>,
        <virtualization@lists.linux-foundation.org>,
        <peter.huangpeng@huawei.com>, <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
In-Reply-To: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.16.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/11/4 17:35, Shannon Zhao wrote:
> As the current virtio-mmio only support single irq,
> so some advanced features such as vhost-net with irqfd
> are not supported. And the net performance is not
> the best without vhost-net and irqfd supporting.
> 
Hi Joel, Peter, Mst,

Some virtio-net with virtio-mmio performance data on ARM added as followed:

Type of backend         bandwith(GBytes/sec)
virtio-net              0.66
vhost-net               1.49
vhost-net with irqfd    2.01

Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60

>From this test data, irqfd has great improvement (about 30%) on performance.
So maybe it's necessary to enable multiple irq support to make vhost-net
with virtio-mmio on ARM be able to use irqfd.

How do you guys think? Look forward for your feedback.

Thanks,
Shannon

> This patch support virtio-mmio to request multiple
> irqs like virtio-pci. With this patch and qemu assigning
> multiple irqs for virtio-mmio device, it's ok to use
> vhost-net with irqfd on arm/arm64.
> 
