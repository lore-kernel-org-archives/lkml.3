Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3H3OfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:35:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33650 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3H3OfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:35:07 -0400
Message-ID: <1377873212.10300.877.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 0/4] Unify CPU hotplug lock interface
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nfont@linux.vnet.ibm.com, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 30 Aug 2013 08:33:32 -0600
In-Reply-To: <522006F6.2060206@jp.fujitsu.com>
References: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
	 <522006F6.2060206@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 11:44 +0900, Yasuaki Ishimatsu wrote:
> (2013/08/30 9:22), Toshi Kani wrote:
> > lock_device_hotplug() was recently introduced to serialize CPU & Memory
> > online/offline and hotplug operations, along with sysfs online interface
> > restructure (commit 4f3549d7).  With this new locking scheme,
> > cpu_hotplug_driver_lock() is redundant and is no longer necessary.
> > 
> > This patchset makes sure that lock_device_hotplug() covers all CPU online/
> > offline interfaces, and then removes cpu_hotplug_driver_lock().
> > 
> > v2:
> >   - Rebased to the pm tree, bleeding-edge.
> >   - Changed patch 2/4 to use lock_device_hotplug_sysfs().
> > 
> > ---
> > Toshi Kani (4):
> >    hotplug, x86: Fix online state in cpu0 debug interface
> >    hotplug, x86: Add hotplug lock to missing places
> >    hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
> >    hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
> > 
> > ---
> The patch-set looks good to me.
> 
> Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki!
-Toshi


