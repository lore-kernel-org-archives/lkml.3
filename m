Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3F0TFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:05:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56294 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3F0TFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 27 Jun 2013 12:05:02 -0700
X-Google-Sender-Auth: pFvdnxQiXqjJ6C937qGaXjUYHcQ
Message-ID: <CAE9FiQVt4gCiz20SmJVP6d7tXOior5Ehg+-c_fG7wFsDUj7H4Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] PCI: acpiphp: check for new devices on enabled host
From: Yinghai Lu <yinghai@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        John Ronciak <john.ronciak@intel.com>,
        Miles J Penner <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:22 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Current acpiphp_check_bridge() implementation is pretty dumb:
>  - it enables the slot if it's not enabled and the slot status is
>    ACPI_STA_ALL;
>  - it disables the slot if it's enabled and slot is not in ACPI_STA_ALL
>    state.
>
> This behavior is not enough to handle Thunderbolt chaining case
> properly. We need to actually rescan for new devices even if a device
> has already in the slot.
>
> The new implementation disables and stops the slot if it's not in
> ACPI_STA_ALL state.
>
> For ACPI_STA_ALL state we first trim devices which don't respond and
> look for the ones after that. We do that even if slot already enabled
> (SLOT_ENABLED).

that is not right, some time BUS_CHECK is even sent root bus.
in that case, stop all devices in slots and load driver again.

like you put one card in one slots, but all devices in other slots get stop
and enable again.

Thanks

Yinghai
