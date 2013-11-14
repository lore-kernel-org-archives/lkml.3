Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3KNX0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:26:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:39690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab3KNX0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,702,1378882800"; 
   d="scan'208";a="433728396"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
Thread-Topic: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
Thread-Index: AQHO4Y4NBW/b3dchAkqmOAl2WwcKZJolXB6g
Date: Thu, 14 Nov 2013 23:26:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D6D644@ORSMSX106.amr.corp.intel.com>
References: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ERROR: "boot_cpu_physical_apicid" [drivers/acpi/acpi_extlog.ko] undefined!
>
> The symbol needs to be exported for it to be available.

Good - but I wonder how many more useless layers there are to this onion :-(

First I had to add a "#include <asm/cpu.h>"
Then add the dependency on CONFIG_X86_LOCAL_APIC
Now we need to export boot_cpu_physical_apicid

all for the CONFIG_SMP=n case ... which I think is useless because there
is no conceivable way anyone would run a uniprocessor kernel on a system
that supports the extended error log. (Hint: multi-socket server multiplied by
high-core-count processors multiplied by 2xHyperThread) is a number bigger
than one).

Perhaps we should just have:

	depends on SMP && X86_MCE

and stop the madness?

-Tony
