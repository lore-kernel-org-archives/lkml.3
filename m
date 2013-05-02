Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab3EBN7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:59:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54126 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3EBN71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:59:27 -0400
Date: Thu, 2 May 2013 06:59:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / processor: Use common hotplug infrastructure
Message-ID: <20130502135921.GC24095@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <3166726.elbgrUIZ0L@vostro.rjw.lan>
 <4370898.CqFcWEhTiu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4370898.CqFcWEhTiu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:31:51PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Split the ACPI processor driver into two parts, one that is
> non-modular, resides in the ACPI core and handles the enumeration
> and hotplug of processors and one that implements the rest of the
> existing processor driver functionality.
> 
> The non-modular part uses an ACPI scan handler object to enumerate
> processors on the basis of information provided by the ACPI namespace
> and to hook up with the common ACPI hotplug infrastructure.  It also
> populates the ACPI handle of each processor device having a
> corresponding object in the ACPI namespace, which allows the driver
> proper to bind to those devices, and makes the driver bind to them
> if it is readily available (i.e. loaded) when the scan handler's
> .attach() routine is running.
> 
> There are a few reasons to make this change.
> 
> First, switching the ACPI processor driver to using the common ACPI
> hotplug infrastructure reduces code duplication and size considerably,
> even though a new file is created along with a header comment etc.
> 
> Second, since the common hotplug code attempts to offline devices
> before starting the (non-reversible) removal procedure, it will abort
> (and possibly roll back) hot-remove operations involving processors
> if cpu_down() returns an error code for one of them instead of
> continuing them blindly (if /sys/firmware/acpi/hotplug/force_remove
> is unset).  That is a more desirable behavior than what the current
> code does.
> 
> Finally, the separation of the scan/hotplug part from the driver
> proper makes it possible to simplify the driver's .remove() routine,
> because it doesn't need to worry about the possible cleanup related
> to processor removal any more (the scan/hotplug part is responsible
> for that now) and can handle device removal and driver removal
> symmetricaly (i.e. as appropriate).
> 
> Some user-visible changes in sysfs are made (for example, the
> 'sysdev' link from the ACPI device node to the processor device's
> directory is gone and a 'physical_node' link is present instead,
> a 'firmware_node' link is present in the processor device's
> directory, the processor driver is now visible under
> /sys/bus/cpu/drivers/ and bound to the processor device), but
> that shouldn't affect the functionality that users care about
> (frequency scaling, C-states and thermal management).
> 
> Tested on my venerable Toshiba Portege R500.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

For the driver core part:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
