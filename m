Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3F1QWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:22:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63368 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3F1QWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130628093319.D4DE6E0090@blue.fi.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
	<CAE9FiQVt4gCiz20SmJVP6d7tXOior5Ehg+-c_fG7wFsDUj7H4Q@mail.gmail.com>
	<20130628093319.D4DE6E0090@blue.fi.intel.com>
Date: Fri, 28 Jun 2013 09:22:32 -0700
X-Google-Sender-Auth: sdZQF8vzgWg5hSdPw1zASMaOXFA
Message-ID: <CAE9FiQUQvVbcbWoBnSiNmtF6P_SHTqWYONzfa-WeQUDYPmvHYw@mail.gmail.com>
Subject: Re: [PATCH 4/6] PCI: acpiphp: check for new devices on enabled host
From: Yinghai Lu <yinghai@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        John Ronciak <john.ronciak@intel.com>,
        Miles J Penner <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 2:33 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Yinghai Lu wrote:
>> On Tue, Jun 25, 2013 at 9:22 AM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> >
>> > Current acpiphp_check_bridge() implementation is pretty dumb:
>> >  - it enables the slot if it's not enabled and the slot status is
>> >    ACPI_STA_ALL;
>> >  - it disables the slot if it's enabled and slot is not in ACPI_STA_ALL
>> >    state.
>> >
>> > This behavior is not enough to handle Thunderbolt chaining case
>> > properly. We need to actually rescan for new devices even if a device
>> > has already in the slot.
>> >
>> > The new implementation disables and stops the slot if it's not in
>> > ACPI_STA_ALL state.
>> >
>> > For ACPI_STA_ALL state we first trim devices which don't respond and
>> > look for the ones after that. We do that even if slot already enabled
>> > (SLOT_ENABLED).
>>
>> that is not right, some time BUS_CHECK is even sent root bus.
>> in that case, stop all devices in slots and load driver again.
>>
>> like you put one card in one slots, but all devices in other slots get stop
>> and enable again.
>
> We don't stop enabled devices, we only stop and remove devices which don't
> respond.  See patch 3/6.
>
> I don't see how it's harmful. Do you?

then please check with disable_device to put back pci_dev ref,
also may need to trim corresponding acpi devices.

so this patch is helping: multiple plug-in and remove?

Yinghai
