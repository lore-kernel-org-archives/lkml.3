Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3HQXOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 19:14:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3HQXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 19:14:09 -0400
Date: Sat, 17 Aug 2013 16:15:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 2/4] hotplug, x86: Add hotplug lock to missing places
Message-ID: <20130817231552.GA20169@kroah.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
 <1376768819-28975-3-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376768819-28975-3-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 01:46:57PM -0600, Toshi Kani wrote:
> lock_device_hotplug() serializes CPU & Memory online/offline and hotplug
> operations.  However, this lock is not held in the debug interfaces below
> that initiate CPU online/offline operations.
> 
>  - _debug_hotplug_cpu(), cpu0 hotplug test interface enabled by
>    CONFIG_DEBUG_HOTPLUG_CPU0.
>  - cpu_probe_store() and cpu_release_store(), cpu hotplug test interface
>    enabled by CONFIG_ARCH_CPU_PROBE_RELEASE.
> 
> This patch changes the above interfaces to hold lock_device_hotplug().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  arch/x86/kernel/topology.c |    2 ++
>  drivers/base/cpu.c         |   16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
