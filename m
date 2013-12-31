Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3LaSpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:45:49 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62275 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab3LaSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:45:47 -0500
MIME-Version: 1.0
In-Reply-To: <31566676.sHXhScpSQ6@vostro.rjw.lan>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan>
	<CAE9FiQXCzRNGbUpXDv3c9RDV4quV2b3gkrpjpPpxYzBH-p35jw@mail.gmail.com>
	<1460504.iemmv1nFbi@vostro.rjw.lan>
	<31566676.sHXhScpSQ6@vostro.rjw.lan>
Date: Tue, 31 Dec 2013 10:45:46 -0800
X-Google-Sender-Auth: zQFPP0xjPIoiTIJ8vE689v2vSW4
Message-ID: <CAE9FiQVEqnWm1j0GckuNsD_FTPxWahZpCnF79sNgKN-JnCDT+w@mail.gmail.com>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to
 avoid sysfs warnings
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 5:15 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, December 30, 2013 01:51:28 PM Rafael J. Wysocki wrote:
>> > We have patches that need to stop ioapic and iommu between
>> > pci_stop_root_bus and pci_remove_root_bus.
>
> BTW, what *exactly* do they need to be stopped between?  After these two patches:

need to stop regular pci drivers before stop "driver" for ioapic/dmar.

>
>> > Please check if the problem still happen after
>> >
>> > http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/patch/?id=c4a0a5d964e90b93eb4101c3927b788e083e530f
>> >
>> > http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/patch/?id=e3b439e1d315aff59c1b4f0fc43c5cd2d82b4138
>
> pci_stop_root_bus() is just a walk over devices on the root bus stopping
> them and pci_remove_root_bus() starts with the removal of those devices.
>
> Surely, those two list walks can be combined into one?

maybe ok, but we have to problem to make sure stop pci drivers before
"driver" for ioapic/dmar.

also stop all first and remove all make it much cleaner.

and add path is two steps too. Add them all, and then attach driver for all.

Thanks

Yinghai
