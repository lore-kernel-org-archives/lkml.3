Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865Ab3HSOzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:55:11 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24971 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3HSOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:55:10 -0400
Message-ID: <1376924024.10300.450.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/4] hotplug, x86: Add hotplug lock to missing places
From: Toshi Kani <toshi.kani@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com
Date: Mon, 19 Aug 2013 08:53:44 -0600
In-Reply-To: <20130817231552.GA20169@kroah.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
	 <1376768819-28975-3-git-send-email-toshi.kani@hp.com>
	 <20130817231552.GA20169@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-17 at 16:15 -0700, Greg KH wrote:
> On Sat, Aug 17, 2013 at 01:46:57PM -0600, Toshi Kani wrote:
> > lock_device_hotplug() serializes CPU & Memory online/offline and hotplug
> > operations.  However, this lock is not held in the debug interfaces below
> > that initiate CPU online/offline operations.
> > 
> >  - _debug_hotplug_cpu(), cpu0 hotplug test interface enabled by
> >    CONFIG_DEBUG_HOTPLUG_CPU0.
> >  - cpu_probe_store() and cpu_release_store(), cpu hotplug test interface
> >    enabled by CONFIG_ARCH_CPU_PROBE_RELEASE.
> > 
> > This patch changes the above interfaces to hold lock_device_hotplug().
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  arch/x86/kernel/topology.c |    2 ++
> >  drivers/base/cpu.c         |   16 ++++++++++++++--
> >  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks Greg!
-Toshi



