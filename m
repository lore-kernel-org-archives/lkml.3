Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaAYHlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:41:12 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59843 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAYHlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:41:10 -0500
Date: Sat, 25 Jan 2014 08:41:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabled APICs being counted as processors ?
Message-ID: <20140125074107.GA10565@gmail.com>
References: <20140123221316.GA23367@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123221316.GA23367@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> I have a system with 4 cores (configured with CONFIG_NR_CPUS=4) that shows during boot..
> 
> [    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
> 
> it looks like this is because..
> 
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
> 
> Should the CPU counting code be ignoring those disabled APICs ?

Hm, so to the kernel it looks like as if those were 'possible CPUs', 
in theory hotpluggable. Not sure what they are - disabled cores in an 
8-core system? Or BIOS reporting crap?

But perhaps the boot message could be improved to say something like:

> [    0.000000] smpboot: 8 possible processors exceeds NR_CPUS limit of 4

?

Thanks,

	Ingo
