Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaDAV7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:59:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:6120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbaDAV7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,775,1389772800"; 
   d="scan'208";a="504650338"
From: "Brown, Len" <len.brown@intel.com>
To: "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Topic: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Index: AQHPTdaFVLQYzxSM7EqDlaR4cHXJtZr9TPjA
Date: Tue, 1 Apr 2014 21:59:40 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
References: <533B0288.2020304@windriver.com>
In-Reply-To: <533B0288.2020304@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've got an eval board with a 1.7GHz Avaton/C2000 that hangs at boot
> shortly after the idle driver registration -- typically 1/2 dozen
> dmesg lines later, around rtc init, or net stack init.

Paul,
Please boot the failing board with "intel_idle.max_cstate=0"
to disable intel_idle entirely, and then show the C-states
exported by acpi_idle, that predumably, are stable on both boards:

dmesg | grep idle
grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

Then go back and boot with "intel_idle.max_cstate=N"
where N is incremented by 1 until when the system fails
and note the largest N that still works.

> The interesting part is that a nearly identical board, but with
> different (newer/faster) CPU and newer BIOS doesn't have the hang.

Possibly an electrical bug in the earlier board.
Maybe they worked around it by disabling a C-state in ACPI
and didn't test upstream Linux?

I'd be interested in the acpi_idle output above for both the
new and old boards to see if they are exporting different states
on the two boards.

dmidecode isn't useful in this case.  The CPUID in /proc/cpuinfo
may be useful if the problem turns out to be associated with
some stepping.

thanks,
-Len

