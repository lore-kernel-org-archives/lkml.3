Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaGLLgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:36:31 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:30364 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbaGLLga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0KALscwVNXQ56W/2dsb2JhbABZgw6tLAUBAQEBAQEFAW4BnACBDhd1hGAjgRqIfQG0Q5I+hXuJAk4dhC0Fmw6UHYNGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/7] arch/powerpc: convert single variable sscanf to kstrto<type>
Date: Sat, 12 Jul 2014 13:36:13 +0200
Message-Id: <1405164980-9525-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a small untested patchset to use the current string manipulation kstrto<type> functions
instead of sscanf like specified in checkpatch: "Prefer kstrto<type> to single variable sscanf"

autodetect base 0 has been used for both %d, %i, %ld, %lu, %u
and base 16 for %lx

Fabian Frederick (7):
  powerpc: fadump: replace sscanf by kstrtoint
  powerpc/mv64x60_pci: replace sscanf by kstrtou32
  powerpc/powernv: replace sscanf %lx by kstrtoul 16
  powerpc/sysfs: replace sscanf by kstrtol
  hugetlb: replace sscanf by kstrtoul
  powerpc/cell: replace sscanf by kstrtouint
  powerpc/pseries: replace sscanf by kstrtoul

 arch/powerpc/kernel/fadump.c              | 5 +++--
 arch/powerpc/kernel/sysfs.c               | 7 +++----
 arch/powerpc/mm/hugetlbpage.c             | 2 +-
 arch/powerpc/platforms/cell/cbe_thermal.c | 4 ++--
 arch/powerpc/platforms/powernv/subcore.c  | 6 +++---
 arch/powerpc/platforms/pseries/power.c    | 5 ++---
 arch/powerpc/sysdev/mv64x60_pci.c         | 7 +++++--
 7 files changed, 19 insertions(+), 17 deletions(-)

-- 
1.9.1

