Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3G0QyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 12:54:25 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:39608 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3G0QyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 12:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo653opkF_ROupSOYoP21LGwm023430Pyj_thbFeDXRq9w@mail.gmail.com>
References: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
	<CAErSpo653opkF_ROupSOYoP21LGwm023430Pyj_thbFeDXRq9w@mail.gmail.com>
Date: Sun, 28 Jul 2013 00:54:20 +0800
Message-ID: <CANVTcTaJdhBXRYDCPJ+UouPQZUzXSity+9mL8QJTCpz=ZugZLA@mail.gmail.com>
Subject: Re: [RFC 0/3] IO Hook: Method for emulating h/w events
From: rui wang <ruiv.wang@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tony Luck <tony.luck@intel.com>, chaohong.guo@intel.com,
        Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <rui.y.wang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This is a cool idea.
>
> I don't know if you want to merge this upstream, or if it's just a "I
> found this useful; here it is in case it's useful to you" sort of
> thing.  So the comments below are only relevant if you want to try to
> merge it upstream.
>

Thanks. If you think it's a cool idea, then I would like to see it
merged upstream.

> I wouldn't really want all the gunk in drivers/pci/access.c.  Most of
> it isn't related to PCI, and some of it is even x86-specific.  It'd be
> nicer if you could factor it out so just the generic PCI-related
> things go in drivers/pci.
>

Sure. I'll keep only the PCI-related things in drivers/pci and move
other things out.

> It appears to be implemented only for x86.  The MMIO & I/O port parts
> are x86-specific, but the PCI config stuff should work on any arch.
>

I had only x86 in mind. But yes it should be made platform neutral.
I'll split it into neutral and arch-specific parts, so that other
archs can be supported easily.

> I don't know whether it's worth supporting as a module.  It seems like
> a development aid where building in statically would probably be fine.
>  If it didn't have to work as a module, you wouldn't have to export
> any symbols.
>

Yes building it statically in the kernel would be cleaner and easier
to use. I'll roll out a new version for you to review.

Thanks
Rui

>> I tested the performance by repeatedly running lspci, which calls into
>> the
>> pci access functions. There's no added overhead observed.
>>
>> Regards,
>> Rui Wang
>> Intel Open Source Technology Center
>>
>> Rui Wang (3):
>>   IO Hook: core functions and Register Override
>>   IO Hook: kernel interface to manage the hook
>>   IO Hook: sysfs interface to emulate h/w events
>>
>>  Documentation/PCI/iohook.txt      |  290 +++++++++++++++++
>>  arch/x86/Kconfig                  |    7 +
>>  arch/x86/boot/compressed/Makefile |    1 +
>>  arch/x86/include/asm/io.h         |   58 ++++-
>>  arch/x86/vdso/Makefile            |    2 +
>>  drivers/misc/Kconfig              |    1 +
>>  drivers/misc/Makefile             |    1 +
>>  drivers/misc/iohook/Kconfig       |    5 +
>>  drivers/misc/iohook/Makefile      |    1 +
>>  drivers/misc/iohook/iohook.c      |  503 +++++++++++++++++++++++++++++
>>  drivers/pci/access.c              |  630
>> +++++++++++++++++++++++++++++++++++++
>>  include/linux/reg_ovrd.h          |   55 ++++
>>  12 files changed, 1552 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/PCI/iohook.txt
>>  create mode 100644 drivers/misc/iohook/Kconfig
>>  create mode 100644 drivers/misc/iohook/Makefile
>>  create mode 100644 drivers/misc/iohook/iohook.c
>>  create mode 100644 include/linux/reg_ovrd.h
>>
>> --
>> 1.7.5.4
>>
>
