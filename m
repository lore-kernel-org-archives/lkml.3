Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3CZWtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:49:13 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52597 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3CZWtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <2166148.RX0m5V0khX@vostro.rjw.lan>
References: <1673357.1IdxNNvGWX@vostro.rjw.lan> <34989330.IyIZ6Qqfxh@vostro.rjw.lan>
 <CAE9FiQVSZd216JrdHdeLSrr1k0d5xTCmLz9FH151BHDDo8KRAQ@mail.gmail.com> <2166148.RX0m5V0khX@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 26 Mar 2013 16:48:49 -0600
Message-ID: <CAErSpo7obx9Ay+sZZtki5ZBrSpYfJ+dnxxoH0=ReqOOByVkXhA@mail.gmail.com>
Subject: Re: [PATCH] PCI, ACPI: hold acpi_scan_lock during root bus hotplug
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 4:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, March 26, 2013 08:12:30 AM Yinghai Lu wrote:
>> On Tue, Mar 26, 2013 at 6:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Sunday, March 10, 2013 10:05:16 PM Yinghai Lu wrote:
>> >> During merging pci tree with pm/acpi tree, Linus noticed that
>> >> we don't have same lock using patten about acpi pci root as
>> >> acpiphp.
>> >>
>> >> Here apply same lock patten, and we need to change
>> >> acpi_bus_hot_remove_device executing via acpi_os_hotplug_execute()
>> >> as it also hold the lock in acpi_bus_hot_remove_device.
>> >>
>> >> That will make acpi_bus_hot_remove_device calling the same as other
>> >> callers.
>> >>
>> >> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Bjorn, this needs to go in before final 3.9.
>> >
>> > Are you going to handle it, or should I take care of it?
>>
>> It should be better via your pm+acpi tree, as that lock is added via your tree.
>
> OK, I'll take it, then, if Bjorn doesn't object.

Yep, that's fine with me.
