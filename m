Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427Ab3E1OtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:49:06 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48736 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934327Ab3E1OtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:49:04 -0400
Message-ID: <51A4C3D9.7070402@gmail.com>
Date: Tue, 28 May 2013 22:48:57 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Donald Dutile <ddutile@redhat.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v3, part1 09/10] PCI, IOV: simplify IOV implementation
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-10-git-send-email-jiang.liu@huawei.com> <CAE9FiQX-3=U7YpEnRsL46Kn0Dyvk_+A1NC7UYijHe91KWjrKDA@mail.gmail.com>
In-Reply-To: <CAE9FiQX-3=U7YpEnRsL46Kn0Dyvk_+A1NC7UYijHe91KWjrKDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28 May 2013 10:00:26 AM CST, Yinghai Lu wrote:
> On Sat, May 25, 2013 at 6:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Trivial changes to IOV:
....
>> @@ -136,7 +123,8 @@ failed1:
>>         pci_dev_put(dev);
>>         mutex_lock(&iov->dev->sriov->lock);
>>         pci_stop_and_remove_bus_device(virtfn);
>> -       virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
>> +       virtfn_remove_bus(dev->bus, bus);
>> +failed0:
>
> need to swap above two lines. otherwise virtual bus could not be removed.
Hi Yinghai,
      Good catch, will merge following patch in next version.

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 3e33499..bf0a32e 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -123,8 +123,9 @@ failed1:
        pci_dev_put(dev);
        mutex_lock(&iov->dev->sriov->lock);
        pci_stop_and_remove_bus_device(virtfn);
-       virtfn_remove_bus(dev->bus, bus);
 failed0:
+       if (bus)
+               virtfn_remove_bus(dev->bus, bus);
        mutex_unlock(&iov->dev->sriov->lock);

        return rc;
