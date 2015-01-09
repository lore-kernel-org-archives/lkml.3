Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbbAIM7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:59:18 -0500
Received: from smtp26.services.sfr.fr ([93.17.128.163]:30624 "EHLO
	smtp26.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbbAIM7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:59:16 -0500
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20150109125911961.176A41C00B418@msfrf2603.sfr.fr
Message-ID: <54AFD09E.1010806@free.fr>
Date: Fri, 09 Jan 2015 13:59:10 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101
	Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Linux ARM <linux-arm-kernel@lists.infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: ioremap vs remap_pfn_range, VMSPLIT, etc
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Yesterday, I used /dev/mem to mmap 2 GB and (to my surprise) it worked.
Specifically, I opened /dev/mem O_RDWR | O_SYNC
then called
  mmap(NULL, 1U<<31, PROT_WRITE, MAP_SHARED, fd, 0x80000000);

And mmap returned a valid pointer.

I was expecting it to fail.

- the kernel is configured with VMSPLIT_3G (3G/1G user/kernel)
- the kernel manages 256 MB RAM
- there is roughly 750 MB of VMALLOC space, no highmem

I know /dev/mem's mmap calls remap_pfn_range, but I was expecting
the VMALLOC space to impose a limit on the size of the mapping.
Obviously this was incorrect?

If I requested the same mapping *within the kernel* using ioremap,
would that fail because of limited VMALLOC space?

Moving to arch-specific questions (namely ARM Cortex-A9).
If I understand correctly (which is very possibly NOT the case)
the CPU has two registers pointing to page tables, one for
the current process, one for the kernel. And the CPU automatically
picks the correct one, based on the active context?
It would seem possible to have a full 4G for process, and a full 4G
for the kernel, using that method, no? (Like Ingo's old 4G/4G split).
Without the performance overhead of fiddling with the page tables.
What am I missing?

Regards.
