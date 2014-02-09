Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBIVbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:31:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57570 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751687AbaBIVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:31:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Sun, 09 Feb 2014 22:46:05 +0100
Message-ID: <2150349.jTafhT0LGH@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2773460.zRzOP7I6SW@al>
References: <52F2CC7B.80406@gmail.com> <6111963.dPYocWnfhd@vostro.rjw.lan> <2773460.zRzOP7I6SW@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 08, 2014 10:34:23 PM Peter Wu wrote:
> On Saturday 08 February 2014 16:01:36 Rafael J. Wysocki wrote:
> > It looks like we fail to resume the device, then, for some reason.
> > 
> > That may be a PCIe link issue or something similar.
> > 
> > Is this a regression for you?  If so, what's the last kernel that didn't
> > have this problem?  Does 3.13.y (as released by Greg, without and distro
> > "improvements") have it too?
> 
> It was a regression from 3.11.x to 3.12 (and it is still broken with 3.13).
> Due to some mistakes from my side, I have tested more configs:
> 
> (based on Arch Linux 3.13.1 x86_64 config)
> (a) 3.13.2 with CONFIG_HOTPLUG_PCI=y, but CONFIG_HOTPLUG_PCI_ACPI=n works.
> (b) 3.13.2 with CONFIG_HOTPLUG_PCI=y and CONFIG_HOTPLUG_PCI_ACPI=y is broken.
> (c) 3.13.2 with CONFIG_HOTPLUG_PCI=n still works.
> (my stripped config)
> (d) 3.13.2 with CONFIG_HOTPLUG_PCI=y, but CONFIG_HOTPLUG_PCI_ACPI=n works.
> 
> With CONFIG_HOTPLUG_PCI_ACPI=y, the only difference in dmesg is:
> 
> (during boot)
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> (after resume)
> iwlwifi 0000:05:00.0: no hotplug settings from platform
> xhci_hcd 0000:02:00.0: no hotplug settings from platform
>  (here, NetworkManager complains that a device has gone)
> iwlwifi 0000:05:00.0: no hotplug settings from platform
> 
> Of course, with config (b), the ethernet adapter vanishes while it is still
> present with configs (a), (c) and (d).
> 
> Time to do a bisect?

That most likely would single out one of the ACPIPHP commits without giving us
much clue about what's going on.

I fail to see what the connection between those changes and system resume is,
however.

Please replace all pr_debug() calls in hotplug_notify() with pr_info() and
see if you get any events from there.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
