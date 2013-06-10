Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3FJXkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:40:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47346 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FJXkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130609151601.GB2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-6-git-send-email-yinghai@kernel.org>
	<20130609151601.GB2245@breakpoint.cc>
Date: Mon, 10 Jun 2013 16:40:04 -0700
X-Google-Sender-Auth: 9WoloAP99cs7sDc4WUOAFnLArG8
Message-ID: <CAE9FiQV6Qqhky0TDjc6gcW1=_1wCiAckAkCpc=E70iC=Nge2og@mail.gmail.com>
Subject: Re: [PATCH v3 05/27] x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
From: Yinghai Lu <yinghai@kernel.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 8:16 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Fri, Jun 07, 2013 at 03:30:51PM -0700, Yinghai Lu wrote:
>> All others are using "-" instead of "_".
>
> Who are "all others"? According to my grep it is 121 vs 44. So even without
> your two here we still 42 doing it the other way around so it is not all.

I mean in arch/x86

arch/x86/kernel/apic/io_apic.c:struct irq_chip ioapic_chip __read_mostly = {
arch/x86/kernel/apic/io_apic.c- .name                   = "IO-APIC",
--
arch/x86/kernel/apic/io_apic.c:static struct irq_chip lapic_chip
__read_mostly = {
arch/x86/kernel/apic/io_apic.c- .name           = "local-APIC",
--
arch/x86/kernel/apic/io_apic.c:struct irq_chip msi_chip = {
arch/x86/kernel/apic/io_apic.c- .name                   = "PCI-MSI",
--
arch/x86/kernel/apic/io_apic.c:static struct irq_chip dmar_msi_type = {
arch/x86/kernel/apic/io_apic.c- .name                   = "DMAR_MSI",
--
arch/x86/kernel/apic/io_apic.c:struct irq_chip hpet_msi_type = {
arch/x86/kernel/apic/io_apic.c- .name = "HPET_MSI",
--
arch/x86/kernel/apic/io_apic.c:static struct irq_chip ht_irq_chip = {
arch/x86/kernel/apic/io_apic.c- .name                   = "PCI-HT",
--
arch/x86/kernel/i8259.c:struct irq_chip i8259A_chip = {
arch/x86/kernel/i8259.c-        .name           = "XT-PIC",
--
arch/x86/lguest/boot.c:static struct irq_chip lguest_irq_controller = {
arch/x86/lguest/boot.c- .name           = "lguest",
--
arch/x86/platform/uv/uv_irq.c:static struct irq_chip uv_irq_chip = {
arch/x86/platform/uv/uv_irq.c-  .name                   = "UV-CORE",
--
arch/x86/platform/visws/visws_quirks.c:static struct irq_chip
cobalt_irq_type = {
arch/x86/platform/visws/visws_quirks.c- .name           = "Cobalt-APIC",
--
arch/x86/platform/visws/visws_quirks.c:static struct irq_chip
piix4_master_irq_type = {
arch/x86/platform/visws/visws_quirks.c- .name           = "PIIX4-master",
--
arch/x86/platform/visws/visws_quirks.c:static struct irq_chip
piix4_virtual_irq_type = {
arch/x86/platform/visws/visws_quirks.c- .name           = "PIIX4-virtual",
--


>
> However it might make sense to use _ instead of " " within a chip's name and
> - as a delimiter for modes like edge or level. However that is way beyond the
> scope of this patch and I am not sure if anyone finds this usefull at all.
>
> Saying this, I am fine with this patch :)

ok.

Thanks

Yinghai
