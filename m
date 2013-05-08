Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3EHMxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:53:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3EHMxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:53:51 -0400
Date: Wed, 8 May 2013 14:54:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
Message-ID: <20130508125414.GB30955@pd.tnic>
References: <20130506125937.GA14036@phenom.dumpdata.com>
 <20130507190024.GA4303@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130507190024.GA4303@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 03:00:24PM -0400, Konrad Rzeszutek Wilk wrote:
> I dug deeper in how QEMU does it and it looks to be actually doing
> the right thing. It triggers the ACPI SCI, the method that figures
> out the CPU online/offline bits kicks off the right OSPM notification
> and everything is going through ACPI (so _STA is on the processor is
> checked, returns 0x2 (ACPI_STA_DEVICE_PRESENT), MADT has now the CPU
> marked as enabled).

AFAIUC, you mean physical hotplug here which is done with ACPI, right?
And, if so, we actually need an x86 machine which supports that to test
it on. Also, is this how physical hotplug is done? Put the number of
max. supported CPUs in MADT and those which are not present are marked
as disabled?

Then, when they're physically hotplugged, ACPI marks them as enabled?
Questions over questions...?

> I am now 99% sure you would be able to reproduce this on baremetal with
> ACPI hotplug where the CPUs at bootup are marked as disabled in MADT.
> (lapic->lapic_flags == 0).
> 
> The comment for calling save_mc_for_early says:

Looks like save_mc_for_early would need another, local mutex to fix that.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
