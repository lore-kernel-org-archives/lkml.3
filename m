Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3KAMhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:37:38 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36560 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3KAMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:37:37 -0400
MIME-Version: 1.0
Date: Fri, 1 Nov 2013 13:37:36 +0100
Message-ID: <CA+MoWDqoBxuFhBsf_rVBT1C8=mwj02hXgPfuWnjY4yeVa-84cA@mail.gmail.com>
Subject: VT-d and x2apic: broken resume after suspend to ram
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have one notebook that is failing to resume after suspend to ram.
I've filled a bug report back on the 2.6.41 days:

https://bugzilla.redhat.com/show_bug.cgi?id=787299

The issue is that trying to resume after suspending to ram freezes the
computer. The resume starts well, but then it hangs.

Yesterday I found that this may be related to VT-d / x2apic. If I
disable VT-d on the BIOS, suspend / resume works fine. If I enable
VT-d and pass nox2apic as boot parameter to Kernel suspend and resume
works fine. I would like some pointers to fix this issue. Can you help
me?

Only when I have VT-d enabled, dmesg gives me additional output:
[    0.023913] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.024080] Enabled IRQ remapping in x2apic mode
[    0.024081] Enabling x2apic
[    0.024082] Enabled x2apic
[    0.024087] Switched APIC routing to cluster x2apic.

The notebook is Toshiba R830-10p with i7-2620M.

Thanks!
-- 
Peter
