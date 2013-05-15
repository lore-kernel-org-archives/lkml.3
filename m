Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3EOO6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:58:48 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40594 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab3EOO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <51939FB1.20203@gmail.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
	<1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com>
	<5191F53E.4000305@cn.fujitsu.com>
	<51925136.5050302@gmail.com>
	<CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com>
	<51926CF6.1050706@gmail.com>
	<CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com>
	<51939E16.9090105@gmail.com>
	<CAE9FiQUXrOmN0rkvOwE1G_acEGY3-gouzaXjBMT7EE6uAqvuZA@mail.gmail.com>
	<51939FB1.20203@gmail.com>
Date: Wed, 15 May 2013 07:58:44 -0700
X-Google-Sender-Auth: 1e6S0ya4os951sHRvmUR19XiNWA
Message-ID: <CAE9FiQVCSm14S0A1sVWewc7UX-dyOmu9aq1UwqdPZK6qSmbFxQ@mail.gmail.com>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
From: Yinghai Lu <yinghai@kernel.org>
To: Liu Jiang <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, linuxppc-dev@lists.ozlabs.org,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 7:46 AM, Liu Jiang <liuj97@gmail.com> wrote:
> On Wed 15 May 2013 10:43:02 PM CST, Yinghai Lu wrote:
>>
>
>> that is another bug, let of guy handle it.
>>
>> Yinghai
>
> Hi Yinghai,
>       I don't know any OF exports, could you please help to CC
> some OF experts?

powerpc and sparc are using that.

Ben,

in drivers/pci/probe.c::pci_scan_device() there is

        pci_set_of_node(dev);

        if (pci_setup_device(dev)) {
                kfree(dev);
                return NULL;
        }

so if pci_setup_device fails, there is one dev reference is not release.

please check you can just move down pci_set_of_node down after that
failing path, like


        if (pci_setup_device(dev)) {
                kfree(dev);
                return NULL;
        }

        pci_set_of_node(dev);

Yinghai
