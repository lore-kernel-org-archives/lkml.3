Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3A1Vwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:52:38 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:37681 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3A1Vwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-5-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan>
 <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com> <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 14:52:05 -0700
Message-ID: <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 4/8] ACPI, PCI: avoid building pci_slot as module
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
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

On Mon, Jan 28, 2013 at 2:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 28, 2013 at 1:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sun, Jan 20, 2013 at 5:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Saturday, January 19, 2013 12:07:42 AM Jiang Liu wrote:
>>>> As discussed in thread at https://patchwork.kernel.org/patch/1946851/,
>>>> there's no value in supporting CONFIG_ACPI_PCI_SLOT=m any more.
>>>> So change Kconfig and code to only support building pci_slot as
>>>> built-in driver.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> I think we should eventually get rid of acpi_pci_register_driver() and
>> do this initialization directly from acpi_pci_root_add().  But
>> removing the module option here is a good first step.
>>
>> Rafael, do you want to apply this (and [6/8]) via your tree?  If not,
>> I can take it.
>
> If bios have messed up slot name or idx, we will get strange 1-1....
> other crazy name.
>
> if you really need to put it as built-in, may need to some command
> line that user could switch it off.

It would save us all a lot of time if you gave an example and worked
through the scenario where this is a problem.

We already have the choice of having pci_slot built-in, so if there's
a bug in that config, we already have the bug.  This patch merely
removes a config where the bug might be covered up.

I don't know why "adding a command line switch" appeals to you as the
solution to every problem.  As far as I'm concerned that's not a
solution to ANY problem.  It might be a band-aid to enable users to
limp along while we figure out a correct solution, but it's certainly
not a resolution.

Bjorn
