Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3H3CpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:45:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34381 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3H3CpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:45:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <522006F6.2060206@jp.fujitsu.com>
Date: Fri, 30 Aug 2013 11:44:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <mingo@redhat.com>, <hpa@linux.intel.com>,
        <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <benh@kernel.crashing.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <nfont@linux.vnet.ibm.com>,
        <fenghua.yu@intel.com>, <bp@suse.de>,
        <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/4] Unify CPU hotplug lock interface
References: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/30 9:22), Toshi Kani wrote:
> lock_device_hotplug() was recently introduced to serialize CPU & Memory
> online/offline and hotplug operations, along with sysfs online interface
> restructure (commit 4f3549d7).  With this new locking scheme,
> cpu_hotplug_driver_lock() is redundant and is no longer necessary.
> 
> This patchset makes sure that lock_device_hotplug() covers all CPU online/
> offline interfaces, and then removes cpu_hotplug_driver_lock().
> 
> v2:
>   - Rebased to the pm tree, bleeding-edge.
>   - Changed patch 2/4 to use lock_device_hotplug_sysfs().
> 
> ---
> Toshi Kani (4):
>    hotplug, x86: Fix online state in cpu0 debug interface
>    hotplug, x86: Add hotplug lock to missing places
>    hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
>    hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
> 
> ---
The patch-set looks good to me.

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu


>   arch/powerpc/kernel/smp.c              | 12 ----------
>   arch/powerpc/platforms/pseries/dlpar.c | 40 +++++++++++++---------------------
>   arch/x86/Kconfig                       |  4 ----
>   arch/x86/kernel/smpboot.c              | 21 ------------------
>   arch/x86/kernel/topology.c             | 11 ++++++----
>   drivers/base/cpu.c                     | 34 +++++++++++++++++++----------
>   include/linux/cpu.h                    | 13 -----------
>   7 files changed, 45 insertions(+), 90 deletions(-)
> 


