Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab3ENS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:56:25 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45600 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3ENS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Date: Tue, 14 May 2013 11:56:23 -0700
X-Google-Sender-Auth: 3E3diqc3yWlWlvEo-cxj62u6tWo
Message-ID: <CAE9FiQU89jOx_-EFZnKsETEDDbmEmDctmYraNENAwt14FkCvXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2, part 2 01/18] PCI: introduce hotplug-safe PCI bus iterators
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:51 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Introduce hotplug-safe PCI bus iterators as below, which hold a
> reference on the returned PCI bus object.
> bool pci_bus_exists(int domain, int busnr);
> struct pci_bus *pci_get_bus(int domain, int busnr);
> struct pci_bus *pci_get_next_bus(struct pci_bus *from);
> struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
> #define for_each_pci_bus(b) for (b = NULL; (b = pci_get_next_bus(b)); )
> #define for_each_pci_root_bus(b)  \
>                 for (b = NULL; (b = pci_get_next_root_bus(b)); )
>
> The long-term goal is to remove hotplug-unsafe pci_find_bus(),
> pci_find_next_bus() and the global pci_root_buses list.
>
> These new interfaces may be a littler slower than existing interfaces,
> but it should be acceptable because they are not used on hot paths.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Yinghai Lu <yinghai@kernel.org>
