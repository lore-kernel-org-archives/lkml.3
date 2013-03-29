Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3C2V1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:27:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47000 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab3C2V1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:27:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [Update][PATCH] PCI / ACPI: Always resume devices on ACPI wakeup notifications
Date: Fri, 29 Mar 2013 22:34:53 +0100
Message-ID: <2094285.pXOAcW8yQk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5155ADD2.3090005@fold.natur.cuni.cz>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <2699206.HmPyNvCpNR@vostro.rjw.lan> <5155ADD2.3090005@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 29, 2013 04:05:54 PM Martin Mokrejs wrote:
> Hi,
>   I applied this patches over 3.8.3 hoping it will fix my issue under
> thread: "Re: 3.8.2: xhci port is dead until pcieport PME# goes to disabled"
> but unfortunately, it is even worse! Now, although lsusb -v nor lsusb -vv do
> wakeup the XHCI port but it falls asleep immediately, more quickly than I am
> able to plug a device into the socket. To get a device working in the USB3 socket
> I need to plug it in, run lsusb -vv and then it is recognized.
> 
> Without the patch, the 'lsusb -vv' woke up the port (PME# disabled happened
> on both 1c.4 and 0b:00.0) and I had unlimited time to find some USB device
> around and to plug it into the slot.

Well, using lsusb to work around problems in the PCI subsystem isn't even
*supposed* to work as far as I can tell.

First off, do you use laptop-mode (or something equivalent) to enable runtime
PM for all PCI devices in your system?  If you do, please test things without
it and see if they work then.

Second, do things work after you echo "on" to the xHCI controller's
/sys/devices/.../power/control file?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
