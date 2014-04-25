Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaDYCQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:16:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63545 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDYCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:16:51 -0400
From: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
Subject: [RFC]How to improve KVM VM resource assignment and per-vm
 process/thread scheduling.
Thread-Topic: [RFC]How to improve KVM VM resource assignment and per-vm
 process/thread scheduling.
Thread-Index: Ac9gLFxgEsr1alCJTBmq8GApZSbdvg==
Date: Fri, 25 Apr 2014 02:16:28 +0000
Message-ID: <615092B2FD0E7648B6E4B43E029BCFB84D612DC1@SZXEMA503-MBS.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.19.148]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3P2Gwjh002863

Hi, ALL

Currently kvm hypervisor have lots of features depend on linux standard apis, 
like vcpupin/mempin/processpin etc. But in the real production environment,
we need an automated resource assign and/or scheduling, is there any plan to
implement it?

resource assignment requirements like:
cpu eligible by the VMs
  In case it is eligible, whether it is in use
   if it is in use, whether it is dedicated to one VM, or can be shared by many VMs
     In case of Shared CPU
       need to configure oversubscription ratio
       used ratio info

So does memory, I/O device assignment requirements.

per-vm process/thread scheduling requirements like:
On hypervisor side, VMs use vhost-net, virtio-scsi devices have qemu io-thread, vhost-net 
thread, ovs thread, hNIC interrupt context(hirq/softirq), you shoud place there threads on the same
numa node to gain best performance, another important thing, you should balance these
threads' cpuload on all the numa cores to avoid unbalance between vcpu usable resources.

Thanks.

Peter Huang 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
