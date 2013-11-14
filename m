Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3KNXdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:33:44 -0500
Received: from mail-gg0-f170.google.com ([209.85.161.170]:57216 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3KNXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:33:36 -0500
Date: Thu, 14 Nov 2013 15:33:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D6D644@ORSMSX106.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1311141528180.8370@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com> <3908561D78D1C84285E8C5FCA982C28F31D6D644@ORSMSX106.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013, Luck, Tony wrote:

> > ERROR: "boot_cpu_physical_apicid" [drivers/acpi/acpi_extlog.ko] undefined!
> >
> > The symbol needs to be exported for it to be available.
> 
> Good - but I wonder how many more useless layers there are to this onion :-(
> 
> First I had to add a "#include <asm/cpu.h>"
> Then add the dependency on CONFIG_X86_LOCAL_APIC
> Now we need to export boot_cpu_physical_apicid
> 

asm/cpu.h itself is also indirectly relying on asm/topology.h to include 
asm/mpspec.h to get that declaration of boot_cpu_physical_apicid in the 
first place.

> all for the CONFIG_SMP=n case ... which I think is useless because there
> is no conceivable way anyone would run a uniprocessor kernel on a system
> that supports the extended error log. (Hint: multi-socket server multiplied by
> high-core-count processors multiplied by 2xHyperThread) is a number bigger
> than one).
> 
> Perhaps we should just have:
> 
> 	depends on SMP && X86_MCE
> 
> and stop the madness?
> 

Or do some randconfig testing before patches are proposed :)  I don't have 
any particular dependency on this, so I'm happy with whatever is decided.  
This is the last error I've found related to CONFIG_ACPI_EXTLOG, however.
