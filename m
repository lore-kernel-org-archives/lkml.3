Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3HRAvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 20:51:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47398 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab3HRAvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 20:51:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 0/4] Unify CPU hotplug lock interface
Date: Sun, 18 Aug 2013 03:02:25 +0200
Message-ID: <1449558.tneKXFMIWE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 17, 2013 01:46:55 PM Toshi Kani wrote:
> lock_device_hotplug() was recently introduced to serialize CPU & Memory
> online/offline and hotplug operations, along with sysfs online interface
> restructure (commit 4f3549d7).  With this new locking scheme,
> cpu_hotplug_driver_lock() is redundant and is no longer necessary.
> 
> This patchset makes sure that lock_device_hotplug() covers all CPU online/
> offline interfaces, and then removes cpu_hotplug_driver_lock().
> 
> The patchset is based on Linus's tree, 3.11.0-rc5.

Nice series, thanks a lot for taking care of this!

Rafael


> ---
> Toshi Kani (4):
>   hotplug, x86: Fix online state in cpu0 debug interface
>   hotplug, x86: Add hotplug lock to missing places
>   hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
>   hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
> 
> ---
>  arch/powerpc/kernel/smp.c              | 12 ----------
>  arch/powerpc/platforms/pseries/dlpar.c | 40 +++++++++++++---------------------
>  arch/x86/Kconfig                       |  4 ----
>  arch/x86/kernel/smpboot.c              | 21 ------------------
>  arch/x86/kernel/topology.c             | 11 ++++++----
>  drivers/base/cpu.c                     | 26 ++++++++++++----------
>  include/linux/cpu.h                    | 13 -----------
>  7 files changed, 37 insertions(+), 90 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
