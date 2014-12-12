Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbaLLD7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:59:24 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33389 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbaLLD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:59:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0i3UhvaAu9JV_BuB0fPFmHAa_NdX+eXYBnAHcsiaVOw9g@mail.gmail.com>
References: <CAJZ5v0i3UhvaAu9JV_BuB0fPFmHAa_NdX+eXYBnAHcsiaVOw9g@mail.gmail.com>
Date: Thu, 11 Dec 2014 19:59:20 -0800
X-Google-Sender-Auth: 5o1-CqCejmtIdzreSMFXCvBuM6A
Message-ID: <CA+55aFx+8gKsDSDKSAxB4+JuL_M22uuHDmzSfsv1qJ=dSZ3-ww@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management updates for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 4:21 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> Also the ACPI core is now going to support the _DEP configuration
> information in a limited way.

Hmm. That seems to be the cause of this annoying new message:

    ...
    ACPI: Using IOAPIC for interrupt routing
    PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:00: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:01: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:02: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:03: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:04: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:05: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:06: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb200)
    acpi LNXCPU:07: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb840)
    acpi device:27: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb840)
    acpi device:3f: Failed to evaluate _DEP.
    ACPI: [Package] has zero elements (ffff88040ccdb8c0)
    acpi LNXVIDEO:00: Failed to evaluate _DEP.
    ACPI: Power Resource [FN00] (off)
    ...

which doesn't seem to hinder anything from working, but is extremely
annoying because it's printed out as some super-important "KERN_ERR
message of Doom!"

I don't see why incomplete ACPI tables would *ever* be "KERN_ERR"
level messages, but I particularly don't see it when it seems to be
our own meaningless fake entries.

                   Linus
