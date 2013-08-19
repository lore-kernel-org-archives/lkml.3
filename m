Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842Ab3HSPYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:24:46 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39549 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3HSPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:24:46 -0400
Message-ID: <1376925802.10300.452.camel@misato.fc.hp.com>
Subject: Re: [PATCH 4/4] hotplug, powerpc, x86: Remove
 cpu_hotplug_driver_lock()
From: Toshi Kani <toshi.kani@hp.com>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        fenghua.yu@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, isimatu.yasuaki@jp.fujitsu.com,
        srivatsa.bhat@linux.vnet.ibm.com, bp@suse.de,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 19 Aug 2013 09:23:22 -0600
In-Reply-To: <521237A9.8010109@linux.vnet.ibm.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
	 <1376768819-28975-5-git-send-email-toshi.kani@hp.com>
	 <521237A9.8010109@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 10:20 -0500, Nathan Fontenot wrote:
> On 08/17/2013 02:46 PM, Toshi Kani wrote:
> > cpu_hotplug_driver_lock() serializes CPU online/offline operations
> > when ARCH_CPU_PROBE_RELEASE is set.  This lock interface is no longer
> > necessary with the following reason:
> > 
> >  - lock_device_hotplug() now protects CPU online/offline operations,
> >    including the probe & release interfaces enabled by
> >    ARCH_CPU_PROBE_RELEASE.  The use of cpu_hotplug_driver_lock() is
> >    redundant.
> >  - cpu_hotplug_driver_lock() is only valid when ARCH_CPU_PROBE_RELEASE
> >    is defined, which is misleading and is only enabled on powerpc.
> > 
> > This patch removes the cpu_hotplug_driver_lock() interface.  As
> > a result, ARCH_CPU_PROBE_RELEASE only enables / disables the cpu
> > probe & release interface as intended.  There is no functional change
> > in this patch.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Reviewed-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Thanks Nathan!
-Toshi

