Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3H2RQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:16:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18673 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3H2RQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:16:48 -0400
Message-ID: <1377796510.10300.868.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] Unify CPU hotplug lock interface
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Date: Thu, 29 Aug 2013 11:15:10 -0600
In-Reply-To: <1449558.tneKXFMIWE@vostro.rjw.lan>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
	 <1449558.tneKXFMIWE@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-18 at 03:02 +0200, Rafael J. Wysocki wrote:
> On Saturday, August 17, 2013 01:46:55 PM Toshi Kani wrote:
> > lock_device_hotplug() was recently introduced to serialize CPU & Memory
> > online/offline and hotplug operations, along with sysfs online interface
> > restructure (commit 4f3549d7).  With this new locking scheme,
> > cpu_hotplug_driver_lock() is redundant and is no longer necessary.
> > 
> > This patchset makes sure that lock_device_hotplug() covers all CPU online/
> > offline interfaces, and then removes cpu_hotplug_driver_lock().
> > 
> > The patchset is based on Linus's tree, 3.11.0-rc5.
> 
> Nice series, thanks a lot for taking care of this!

Hi Rafael,

Per the recent your changes in lock_device_hotplug(), do you think it
makes sense to integrate this patchset into your tree?  I am also
considering to add one more patch to use lock_device_hotplug_sysfs() in
cpu_probe_store().  I will rebase to your tree and send them today if it
makes sense to you.

Thanks,
-Toshi


> 
> Rafael
> 
> 
> > ---
> > Toshi Kani (4):
> >   hotplug, x86: Fix online state in cpu0 debug interface
> >   hotplug, x86: Add hotplug lock to missing places
> >   hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
> >   hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
> > 
> > ---
> >  arch/powerpc/kernel/smp.c              | 12 ----------
> >  arch/powerpc/platforms/pseries/dlpar.c | 40 +++++++++++++---------------------
> >  arch/x86/Kconfig                       |  4 ----
> >  arch/x86/kernel/smpboot.c              | 21 ------------------
> >  arch/x86/kernel/topology.c             | 11 ++++++----
> >  drivers/base/cpu.c                     | 26 ++++++++++++----------
> >  include/linux/cpu.h                    | 13 -----------
> >  7 files changed, 37 insertions(+), 90 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


