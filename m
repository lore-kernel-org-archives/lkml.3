Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947258Ab3BHWf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:35:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59497 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3BHWfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5PX--N5vuOm7X2u7LDZ4tfHE7OHjfCUFwMRDAFkvTA_Q@mail.gmail.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-27-git-send-email-yinghai@kernel.org>
	<CAErSpo5PX--N5vuOm7X2u7LDZ4tfHE7OHjfCUFwMRDAFkvTA_Q@mail.gmail.com>
Date: Fri, 8 Feb 2013 14:35:54 -0800
X-Google-Sender-Auth: 0bXLfh71njKmshK7oDnoyZmQshc
Message-ID: <CAE9FiQVhmH_TGqEwxGPusKNn-6Q7QkS3UTitEriV3dX8sPbzFA@mail.gmail.com>
Subject: Re: [PATCH v2 26/26] PCI, x86, ACPI: Add ioapic hotplug support with
 acpi host bridge.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 1:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Feb 8, 2013 at 12:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> We need to have ioapic setup before normal pci drivers.
>> otherwise other pci driver can not setup irq.
>>
>> Make ioapic built-in, so can call add/remove during host-bridge add/remove
>> the same as the booting path.
>>
>> Also need to make it depends on X86_IO_APIC.
>
> There are a lot of different things happening in this patch.  I'd
> prefer if they were split out so we can see what's happening.  For
> example, the Kconfig changes could be their own patch.  The removal of
> the PCI device table is worthy of mention and its own patch (if
> possible), since it's a pretty major change to how the driver binds to
> devices.

ok, will try to split it small patches..

also I'd like to leave you and Rafael to decide if we need to move that file to
drivers/acpi/pci_ioapic.c or something else.

Thanks

Yinghai
