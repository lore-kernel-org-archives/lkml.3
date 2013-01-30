Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3A3PBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:01:39 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:43207 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3PBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:01:37 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Subject: [RFC PATCH v3 0/2] ARM: update cpuinfo to print SoC model name
Date: Wed, 30 Jan 2013 17:01:29 +0200
Message-Id: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches update cpuinfo to print SoC
model name for ARM.
The first patch exactly makes needed changes for ARM
architecture and adds a common approach to show SoC name.
Second patch uses this approach for TI OMAP4 SoCs (as live
example).

Why we need it?

First - the /proc/cpuinfo becomes more informative.
Added new line "SoC name" in the "cpuinfo" output for system
on a chip name. It is placed between CPU information and machine
information, so the file structure looks gracefully
('CPU-SoC-Hardware' instead of 'CPU-Hardware' that we have now)

Second - this information may be used by userspace
for different purposes (as example - OMAP4460 and
OMAP4470 SoCs have different graphics accelerators,
and userspace may want to know what libraries
to use and what module to insert if the graphics
drivers are built as modules)

Looks like there were few attempts to do similar
changes to cpuinfo without any luck (had stuck
on review) so this functionality is still not
in the kernel yet.
In this patch series the update to cpuinfo is very
short (10 lines) and easy.

Comments are welcome as usual

--------------------------------------------------
v3:
Addressed comments from Nishanth (changed 'SoC name'
field for OMAP - now it shows only SoC name without
additional info)

Updated commit messages. Updated this cover letter
with additional information

--------------------------------------------------
v2:
Addressed comments from Russel (changed 'CPU name' > 'SoC name')
Updatet commit messages. Updated cover letter

Ruslan Bilovol (2):
  ARM: kernel: update cpuinfo to print SoC model name
  ARM: OMAP4: setup SoC model name during ID initialisation

 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/setup.c      |    9 +++++++++
 arch/arm/mach-omap2/id.c     |    5 +++++
 3 files changed, 15 insertions(+)

-- 
1.7.9.5

