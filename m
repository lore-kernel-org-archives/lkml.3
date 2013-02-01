Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3BASYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:24:17 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43432 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab3BASYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:24:11 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [Resend][PATCH] ACPI / PM: Do not power manage devices in unknown initial states
Date: Fri, 01 Feb 2013 19:23:52 +0100
Message-ID: <2135454.ENo8eA9AXp@al>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5-git-162-g34213ff+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3676077.i6vcpp7Nrn@vostro.rjw.lan>
References: <3676077.i6vcpp7Nrn@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2013 23:32:40 Rafael J. Wysocki wrote:
> In general, for ACPI device power management to work, the initial
> power states of devices must be known (otherwise, we wouldn't be able
> to keep track of power resources, for example).  Hence, if it is
> impossible to determine the initial ACPI power states of some
> devices, they can't be regarded as power-manageable using ACPI.
> 
> For this reason, modify acpi_bus_get_power_flags() to clear the
> power_manageable flag if acpi_bus_init_power() fails and add some
> extra fallback code to acpi_bus_init_power() to cover broken
> BIOSes that provide _PS0/_PS3 without _PSC for some devices.
> 
> Verified to work on my HP nx6325 that has this problem.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Tested-by: Peter Wu <lekensteyn@gmail.com>

I applied it on top of branch linux-next of repo linux-pm.

Fixes the issue I had with bbswitch in Linux 3.8. Can a backport patch be made 
available for 3.8?

Regards,
Peter
