Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3A1WOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:14:36 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62913 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab3A1WOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:14:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-5-git-send-email-jiang.liu@huawei.com> <3500982.MUDp6kKU3R@vostro.rjw.lan>
 <CAErSpo4fbNzFaBxH+eKD+BKVgghyCJEYLDMzc6_gdxABAPe3QQ@mail.gmail.com>
 <CAE9FiQVM4+Wirpb3_D0Zxi4r1p9SAMi4ZrNYr=-eas-C6pKJYA@mail.gmail.com>
 <CAErSpo7WbbzZ8cKfLvuE331ofWir2vswUnYaxVLBBYGFowedXQ@mail.gmail.com> <CAE9FiQXkrYubkgbbOXmrEXvGZBZXMZ6sh8kGTpF1_=tD3OMPJw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 15:14:11 -0700
Message-ID: <CAErSpo7vHXdh=ogvfZnxx9gqgiifWGa=XzS+ZKjXFFOPue4TTw@mail.gmail.com>
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

On Mon, Jan 28, 2013 at 3:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 28, 2013 at 1:52 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Jan 28, 2013 at 2:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> ...
>>> If bios have messed up slot name or idx, we will get strange 1-1....
>>> other crazy name.
>>>
>>> if you really need to put it as built-in, may need to some command
>>> line that user could switch it off.
>>
>> It would save us all a lot of time if you gave an example and worked
>> through the scenario where this is a problem.
>>
>> We already have the choice of having pci_slot built-in, so if there's
>> a bug in that config, we already have the bug.  This patch merely
>> removes a config where the bug might be covered up.
>
>
> for distribution, current it is with module, so user could blacklist
> in module.conf
>
> Now with built-in or not, distribution will have it built-in, and user
> have no chance to
> disable it.

CONFIG_ACPI_PCI_SLOT=y in RHEL6, so evidently they have this problem.

Asking users to edit module.conf by hand is not a solution, just like
asking users to boot with a command line option is not a solution.
That sort of stuff is fine for a hobbyist OS intended only for techie
geeks.  It's not fine for Linux.

If you would give a concrete example of the ACPI namespace info and
device config, hotplug sequence, etc., required to show the problem,
we could have a useful discussion about ways to fix it.  But if all
you have is FUD about "this might break and users won't have the
ability to edit modules.conf," that doesn't help me see why this patch
is a bad idea.

>> I don't know why "adding a command line switch" appeals to you as the
>> solution to every problem.  As far as I'm concerned that's not a
>> solution to ANY problem.  It might be a band-aid to enable users to
>> limp along while we figure out a correct solution, but it's certainly
>> not a resolution.
>
> Looks like you want to remove command line support, right ?
>
> Yinghai
