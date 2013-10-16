Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374Ab3JPMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:52:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58794 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3JPMwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:52:17 -0400
Subject: [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 16 Oct 2013 21:52:14 +0900
Message-ID: <20131016125104.15573.90313.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
even if 1st kernel crashs on some AP.

Sorry, this patch set have not include in-source documentation
requested by Borislav Petkov yet, but I'll post it later separately,
which would be better to focus on documentation reviewing.

ChangeLog

v2 => v3)

- Change default value of boot_cpu_is_bsp to true.

- Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
  processor family is larger than or equal to 6 in order to avoid
  invalid opcode exception on processors where MSR_IA32_APICBASE is
  not supported.

v1 => v2)

- Rebased on top of v3.12-rc5.

- Fix linking time error of boot_cpu_is_bsp_init() in case of
  CONFIG_LOCAL_APIC disabled by adding empty static inline function
  instead.

- Fix missing feature check by means of cpu_has_apic macro in
  boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).

  NOTE: I've checked local apic-present case only; I don't have any
  x86 processor without local apic.

- Add __init annotation to boot_cpu_is_bsp_init().

Test

- built with and without CONFIG_LOCAL_APIC
- tested x86_64 in case of acpi and MP table

---

HATAYAMA Daisuke (2):
      x86, apic: Add boot_cpu_is_bsp() to check if boot cpu is BSP
      x86, apic: Disable BSP if boot cpu is AP


 arch/x86/include/asm/mpspec.h |    9 ++++++++-
 arch/x86/kernel/acpi/boot.c   |    6 +++++-
 arch/x86/kernel/apic/apic.c   |   35 ++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/devicetree.c  |    1 +
 arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
 arch/x86/kernel/setup.c       |    2 ++
 arch/x86/platform/sfi/sfi.c   |    2 +-
 7 files changed, 64 insertions(+), 6 deletions(-)

-- 

Thanks.
HATAYAMA, Daisuke
