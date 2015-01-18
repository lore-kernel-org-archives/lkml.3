Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbARR30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:29:26 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:52746 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbARR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:29:23 -0500
From: Andreas Thalhammer <3827eeabc49e4509@gmail.com>
X-Google-Original-From: Andreas Thalhammer <andreas.thalhammer@linux.com>
Message-ID: <54BBED3E.7020302@linux.com>
Date: Sun, 18 Jan 2015 18:28:30 +0100
Reply-To: andreas.thalhammer@linux.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: MSI 890FXA-GD70 BIOS 1.90+ stalls kernel with enabled IOMMU (drivers/iommu/amd_iommu_init.c)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have the following problem: my mainboard is an MSI 890FXA-GD70. I use
BIOS revision 1.80 at the moment and the IOMMU is enabled in the BIOS.
The IOMMU is recognized by the kernel and seems to work.

I would like to update my BIOS again to revision 1.15, which is known to
freeze the Linux kernel on startup when the IOMMU is not disabled in the
BIOS (and therefor no longer used by Linux).

How can I make the kernel parameters ivrs_hpet[0]=00:14.0 and
ivrs_ioapic[7]=00:00.1 actually be used, because the vanilla kernel
seems to ignore these overrides:

> AMD-Vi:   DEV_SPECIAL(HPET[0])        devid: 00:14.0
> AMD-Vi: Command-line override present for HPET id 0 - ignoring
> AMD-Vi:   DEV_SPECIAL(IOAPIC[7])        devid: 00:00.1
> AMD-Vi: Command-line override present for IOAPIC id 7 - ignoring

Note that with BIOS 1.80 the kernel detects these setting correctly and
the overrides aren't necessary at all. But flashing BIOS 1.90 and newer
stalls the kernel for an unknown reason, so maybe these overrides could
fix it.

Please also read https://bbs.archlinux.org/viewtopic.php?pid=1278081.

I would like to assist in fixing this issue, since I can flash my BIOS
from a working version (1.80) to a non working version (1.15) and back,
if necessary, although I would like to get it fixed with as little
flashes as possible.

How can I patch drivers/iommu/amd_iommu_init.c to
1) make the overrides work
2) add additional output to check where the kernel stalls (if it still
stalls with the overrides)

Thanks in advance,
Andreas
