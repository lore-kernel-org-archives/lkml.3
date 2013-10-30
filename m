Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3J3OBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:01:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57988 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754445Ab3J3OBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:01:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / hotplug / PCI: Always rescan the slot for new devices
Date: Wed, 30 Oct 2013 15:13:15 +0100
Message-ID: <2238508.7Zxn6keMnr@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383141466.4097.163.camel@ul30vt.home>
References: <1383136836-15306-1-git-send-email-mika.westerberg@linux.intel.com> <1383141466.4097.163.camel@ul30vt.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 30, 2013 07:57:46 AM Alex Williamson wrote:
> On Wed, 2013-10-30 at 14:40 +0200, Mika Westerberg wrote:
> > Commit 2dc4128 (ACPI / hotplug / PCI: Avoid doing too much for spurious
> > notifies) changed the enable_slot() to check return value of pci_scan_slot()
> > and if it is zero return early from the function. It means that there were
> > no new devices in this particular slot.
> > 
> > However, if a device appeared deeper in the hierarchy the code now ignores
> > it causing things like Thunderbolt chaining fail to recognize new devices.
> > 
> > The problem with Alex Williamson's machine was solved with commit
> > a47d8c8 (ACPI / hotplug / PCI: Avoid parent bus rescans on spurious device
> > checks) and hence we should be able to restore the original functionality
> > that we always rescan on bus check notification.
> > 
> > On a device check notification we still check what acpiphp_rescan_slot()
> > returns and on zero bail out early.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > Alex,
> > 
> > Are you able to check if your machine still works and doesn't slow down
> > during boot after this patch is applied?
> 
> Looks ok to me, no new console output or boot delay.  Thanks,

Great, thanks!

May I add your Tested-by to it, then?

Rafael

