Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3J3NLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:11:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49565 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752473Ab3J3NLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:11:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / hotplug / PCI: Always rescan the slot for new devices
Date: Wed, 30 Oct 2013 14:23:26 +0100
Message-ID: <8539808.UlspWUkrvu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131030130416.GF3521@intel.com>
References: <1383136836-15306-1-git-send-email-mika.westerberg@linux.intel.com> <1406112.LRdFoqkugQ@vostro.rjw.lan> <20131030130416.GF3521@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 30, 2013 03:04:16 PM Mika Westerberg wrote:
> On Wed, Oct 30, 2013 at 02:01:40PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, October 30, 2013 02:40:36 PM Mika Westerberg wrote:
> > > Commit 2dc4128 (ACPI / hotplug / PCI: Avoid doing too much for spurious
> > > notifies) changed the enable_slot() to check return value of pci_scan_slot()
> > > and if it is zero return early from the function. It means that there were
> > > no new devices in this particular slot.
> > > 
> > > However, if a device appeared deeper in the hierarchy the code now ignores
> > > it causing things like Thunderbolt chaining fail to recognize new devices.
> > > 
> > > The problem with Alex Williamson's machine was solved with commit
> > > a47d8c8 (ACPI / hotplug / PCI: Avoid parent bus rescans on spurious device
> > > checks) and hence we should be able to restore the original functionality
> > > that we always rescan on bus check notification.
> > > 
> > > On a device check notification we still check what acpiphp_rescan_slot()
> > > returns and on zero bail out early.
> > > 
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > So, this is a revert of commit a47d8c8, correct?
> 
> Correct.
> 
> Plain revert didn't work because the code has changed after that commit.

Yeah.

Well, it would be good to know if it affects the Alex' system, but anyway
I added it to the 3.13 queue for now.  We may be able to get it into 3.12
if Alex confirms that it works for him shortly, but if that doesn't happen
we can just ask stable to pick it up later.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
