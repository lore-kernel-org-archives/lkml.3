Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3H2J16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:27:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53680 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3H2J14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:27:56 -0400
Subject: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
To: ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Date: Thu, 29 Aug 2013 18:27:53 +0900
Message-ID: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch series to address the issue that kdump 2nd kernel
now fails to wake up multiple CPUs.

This is based on 3.11-rc7.

I tested this patch series on x86. I used 2 cpus by specifying
nr_cpus=2 for the 2nd kernel. I checked both ACPI MADT and MP table
case; the former is default on my system and for the latter I did
acpi=off. I crashed the system both on BSP and AP by taskset -c {0,1}
sh -c "echo c > /proc/sysrq-trigger".

---

HATAYAMA Daisuke (2):
      x86, apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP
      x86, apic: Disable BSP if boot cpu is AP


 arch/x86/include/asm/mpspec.h |    5 ++++-
 arch/x86/kernel/acpi/boot.c   |   11 ++++++++++-
 arch/x86/kernel/apic/apic.c   |   32 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/devicetree.c  |    1 +
 arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
 arch/x86/kernel/setup.c       |    2 ++
 arch/x86/platform/sfi/sfi.c   |    2 +-
 7 files changed, 62 insertions(+), 6 deletions(-)

-- 
Thanks.
HATAYAMA, Daisuke
