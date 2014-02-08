Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaBHVe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:34:29 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36847 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaBHVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:34:28 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Sat, 08 Feb 2014 22:34:23 +0100
Message-ID: <2773460.zRzOP7I6SW@al>
User-Agent: KMail/4.12.2 (Linux/3.13.2-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <6111963.dPYocWnfhd@vostro.rjw.lan>
References: <52F2CC7B.80406@gmail.com> <8389318.FWd8nDZBjU@al> <6111963.dPYocWnfhd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 February 2014 16:01:36 Rafael J. Wysocki wrote:
> It looks like we fail to resume the device, then, for some reason.
> 
> That may be a PCIe link issue or something similar.
> 
> Is this a regression for you?  If so, what's the last kernel that didn't
> have this problem?  Does 3.13.y (as released by Greg, without and distro
> "improvements") have it too?

It was a regression from 3.11.x to 3.12 (and it is still broken with 3.13).
Due to some mistakes from my side, I have tested more configs:

(based on Arch Linux 3.13.1 x86_64 config)
(a) 3.13.2 with CONFIG_HOTPLUG_PCI=y, but CONFIG_HOTPLUG_PCI_ACPI=n works.
(b) 3.13.2 with CONFIG_HOTPLUG_PCI=y and CONFIG_HOTPLUG_PCI_ACPI=y is broken.
(c) 3.13.2 with CONFIG_HOTPLUG_PCI=n still works.
(my stripped config)
(d) 3.13.2 with CONFIG_HOTPLUG_PCI=y, but CONFIG_HOTPLUG_PCI_ACPI=n works.

With CONFIG_HOTPLUG_PCI_ACPI=y, the only difference in dmesg is:

(during boot)
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
(after resume)
iwlwifi 0000:05:00.0: no hotplug settings from platform
xhci_hcd 0000:02:00.0: no hotplug settings from platform
 (here, NetworkManager complains that a device has gone)
iwlwifi 0000:05:00.0: no hotplug settings from platform

Of course, with config (b), the ethernet adapter vanishes while it is still
present with configs (a), (c) and (d).

Time to do a bisect?

Peter

