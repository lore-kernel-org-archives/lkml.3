Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3LXGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 01:09:26 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64155 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LXGJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 01:09:24 -0500
MIME-Version: 1.0
In-Reply-To: <52B9051A.3090701@huawei.com>
References: <52B7F53C.5020001@huawei.com>
	<20131223133402.GA4487@pd.tnic>
	<52B8DEAE.2040100@huawei.com>
	<CAE9FiQWUfu6kNvpeN+e_Gp7L2NxddYnvG2oy9YB7CpqbeMgp-Q@mail.gmail.com>
	<52B9051A.3090701@huawei.com>
Date: Mon, 23 Dec 2013 22:09:24 -0800
X-Google-Sender-Auth: HxJpOcmiIGJ6s9wWqdVPNgpTqhU
Message-ID: <CAE9FiQV401-fC=aTAfvkz3e3nUmJtXTTLGjnwR9innXwU13TmA@mail.gmail.com>
Subject: Re: [PATCH v2][TRIVIAL] x86/smpboot: fix cpu bootup message
From: Yinghai Lu <yinghai@kernel.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 7:52 PM, Xie XiuQi <xiexiuqi@huawei.com> wrote:
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
> [    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x63fffffff]
> [    0.000000] SRAT: Node 1 PXM 1 [mem 0x640000000-0xc3fffffff]
...
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x22] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x32] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x34] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x12] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x14] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x23] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x33] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x35] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x13] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x15] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)

Amazing!

Your BIOS engineers really have different idea about building MADT.

Yinghai
