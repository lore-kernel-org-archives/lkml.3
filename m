Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaAYQmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 11:42:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56528 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaAYQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 11:42:38 -0500
X-Sasl-enc: 9uMEU0IkPQ1HKS+0saXuDDdJyzIjkt0sGAExX10JL6cM 1390668157
Date: Sat, 25 Jan 2014 14:42:35 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabled APICs being counted as processors ?
Message-ID: <20140125164235.GD25531@khazad-dum.debian.net>
References: <20140123221316.GA23367@redhat.com>
 <20140125074107.GA10565@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125074107.GA10565@gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Ingo Molnar wrote:
> * Dave Jones <davej@redhat.com> wrote:
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

It is sort of a standard practice for the BIOS to report ACPI tables listing
all possible cores for the largest possible processor the motherboard
(sometimes several motherboards that share the same BIOS) could handle.
Really easy to find that quirk in anything by SuperMicro, for example.

The kernel things these extra CPU cores will show up eventually, and lists
them (and reserves resources to handle them) as hotpluggable CPUs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
