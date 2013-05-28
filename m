Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3E1Evp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:51:45 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57610 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3E1Evn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <519C9482.2050504@cn.fujitsu.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
	<519C9482.2050504@cn.fujitsu.com>
Date: Mon, 27 May 2013 21:51:43 -0700
X-Google-Sender-Auth: 0un_1x2R5aWQpPGOdZOv7DPyAUI
Message-ID: <CAE9FiQW0SeAedgv4eqDVxNvSh6OfcZAnygKYBygZuG4KNvBaRA@mail.gmail.com>
Subject: Re: [RFC PATCH v2, part3 00/11] Introduce PCI bus lock and state machine
From: Yinghai Lu <yinghai@kernel.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 2:48 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> On 05/16/2013 11:50 PM, Jiang Liu wrote:
>         We're gladly to see the new patch-set, and I tested all the whole 3 parts
> patch-set on the latest kernel tree. Because of the limitation of our test environment,
> we only use the method *1* to trigger PCI hotplug concurrently, and it works well.
>
> Though I'm not sure whether the way you introduced is the best one to solve these
> race condition issues, but it does fix the concurrent PCI hotplug(via sysfs)
> issues that disturb us.

Not sure what happened, at lease after Jiang's first patch, we should still need
https://patchwork.kernel.org/patch/2562431/
 [1/7] PCI: move back pci_proc_attach_devices calling
https://patchwork.kernel.org/patch/2562461/
 [2/7] PCI: move resources and bus_list releasing to pci_release_dev
https://patchwork.kernel.org/patch/2562451/
 [3/7] PCI: Detach driver in pci_stop_device

they will allow pci_stop_and_remove_bus_device is called two times in the
your case.

this one is not needed.
https://patchwork.kernel.org/patch/2562561/
  [4/7] PCI: Fix racing for pci device removing via sysfs
it should be the same as the two pci_alloc_dev patches.

other three are about sriov one....

Thanks

Yinghai
