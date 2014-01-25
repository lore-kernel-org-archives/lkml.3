Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaAYPbF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 10:31:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaAYPbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 10:31:02 -0500
Date: Sat, 25 Jan 2014 10:30:48 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabled APICs being counted as processors ?
Message-ID: <20140125153048.GA8536@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140123221316.GA23367@redhat.com>
 <20140125074107.GA10565@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125074107.GA10565@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 08:41:07AM +0100, Ingo Molnar wrote:
 > 
 > * Dave Jones <davej@redhat.com> wrote:
 > 
 > > I have a system with 4 cores (configured with CONFIG_NR_CPUS=4) that shows during boot..
 > > 
 > > [    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
 > > 
 > > it looks like this is because..
 > > 
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
 > > [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
 > > 
 > > Should the CPU counting code be ignoring those disabled APICs ?
 > 
 > Hm, so to the kernel it looks like as if those were 'possible CPUs', 
 > in theory hotpluggable. Not sure what they are - disabled cores in an 
 > 8-core system? Or BIOS reporting crap?
 > 
 > But perhaps the boot message could be improved to say something like:
 > 
 > > [    0.000000] smpboot: 8 possible processors exceeds NR_CPUS limit of 4

It's not possible though. It's an i5-4670T, in a single socket board.
It doesn't even have hyperthreading. http://ark.intel.com/products/75050/Intel-Core-i5-4670T-Processor-6M-Cache-up-to-3_30-GHz

	Dave

 
