Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaKEIeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:34:20 -0500
Received: from oxalide-out.extra.cea.fr ([132.168.224.8]:43928 "EHLO
	oxalide-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaKEIeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:34:18 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 03:34:17 EST
From: =?iso-8859-1?Q?GAUGUEY_R=E9my_228890?= <remy.gauguey@cea.fr>
To: Shannon Zhao <zhaoshenglong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mst@redhat.com" <mst@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>
Subject: RE: [RFC PATCH] virtio-mmio: support for multiple irqs
Thread-Topic: [RFC PATCH] virtio-mmio: support for multiple irqs
Thread-Index: AQHP+BLKFRlp/KglOkGzSQqgysPL9ZxRm/gAgAATslA=
Date: Wed, 5 Nov 2014 08:26:35 +0000
Message-ID: <022C7612790E20489F80A6F0D54B849F3B26F4F3@EXDAG0-B1.intra.cea.fr>
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
 <5459D8E8.6060709@huawei.com>
In-Reply-To: <5459D8E8.6060709@huawei.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [132.166.88.104]
x-tm-as-product-ver: SMEX-10.2.0.1135-7.500.1017-20752.007
x-tm-as-result: No--37.130600-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shannon, 

>Type of backend         bandwith(GBytes/sec)
>virtio-net              0.66
>vhost-net               1.49
>vhost-net with irqfd    2.01
>
>Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60

Impressive results !
Could you please detail your setup ? which platform are you using and which GbE controller ?
As a reference, it would be good also to have result with an iperf to the HOST to see how far we are from a native configuration...

Also, I assume a pending Qemu patch is necessary to assign multiple irqs ? I'm correct ? 

Thanks a lot, 
Best regards
Rémy

-----Message d'origine-----
De : Shannon Zhao [mailto:zhaoshenglong@huawei.com] 
Envoyé : mercredi 5 novembre 2014 09:00
À : linux-kernel@vger.kernel.org
Cc : mst@redhat.com; peter.maydell@linaro.org; john.liuli@huawei.com; joel.schopp@amd.com; GAUGUEY Rémy 228890; qemu-devel@nongnu.org; n.nikolaev@virtualopensystems.com; virtualization@lists.linux-foundation.org; peter.huangpeng@huawei.com; hangaohuai@huawei.com
Objet : Re: [RFC PATCH] virtio-mmio: support for multiple irqs


On 2014/11/4 17:35, Shannon Zhao wrote:
> As the current virtio-mmio only support single irq, so some advanced 
> features such as vhost-net with irqfd are not supported. And the net 
> performance is not the best without vhost-net and irqfd supporting.
> 
Hi Joel, Peter, Mst,

Some virtio-net with virtio-mmio performance data on ARM added as followed:

Type of backend         bandwith(GBytes/sec)
virtio-net              0.66
vhost-net               1.49
vhost-net with irqfd    2.01

Test cmd: ./iperf -c 192.168.0.2 -P 1 -i 10 -p 5001 -f G -t 60

>From this test data, irqfd has great improvement (about 30%) on performance.
So maybe it's necessary to enable multiple irq support to make vhost-net with virtio-mmio on ARM be able to use irqfd.

How do you guys think? Look forward for your feedback.

Thanks,
Shannon

> This patch support virtio-mmio to request multiple irqs like 
> virtio-pci. With this patch and qemu assigning multiple irqs for 
> virtio-mmio device, it's ok to use vhost-net with irqfd on arm/arm64.
> 
