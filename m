Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3A2Cua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:50:30 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:59659 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3A2CuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:50:25 -0500
MIME-Version: 1.0
In-Reply-To: <510737B0.40903@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-5-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan>
 <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
 <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
 <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com>
 <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
 <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
 <CAE9FiQU84OSQrQJEGAQTDzVv8kGCi+fmgM8+ycoMXMUfHsNe-g@mail.gmail.com>
 <51072EDA.2000704@huawei.com> <CAE9FiQVeFO5X0cRgty6T8OeLKpVweWw+cSk0eygC8ivJMAPM6A@mail.gmail.com>
 <510737B0.40903@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 19:50:04 -0700
Message-ID: <CAErSpo4cW0Hn5Fqs148ouLewkrwLMt1eRjxy90zGyVHeO-HJvg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <liuj97@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 7:45 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> On 2013-1-29 10:21, Yinghai Lu wrote:
>> On Mon, Jan 28, 2013 at 6:07 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
>>>         Could we use quirk to auto-disable PCIe native hotplug for
>>> problematic platforms?
>>
>> that is some kind of boot command line way?
> We could negotiate between acpiphp and pciehp if those problematic
> platforms/chipsets could be identified by DMI info or PCI device ID.

That's a sub-optimal solution because it requires us to identify all
the affected systems and also may require ongoing maintenance in the
future.  If we could get specifics on the issue, we might be able to
design a better solution that works for everybody.

(BTW, this thread is specifically about pci_slot, which I think is a
slightly different issue than the acpiphp/pciehp conflicts.)
