Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaHYKMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:12:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:58154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaHYKMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:12:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,396,1406617200"; 
   d="scan'208";a="563025104"
Date: Mon, 25 Aug 2014 13:12:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, Kumar P Mahesh <mahesh.kumar.p@intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] intel_idle: add idle values for Cherrytrail/Braswell
Message-ID: <20140825101200.GH1660@lahna.fi.intel.com>
References: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com>
 <53F74E5D.2040108@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F74E5D.2040108@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:06:21PM +0800, Li, Aubrey wrote:
> On 2014/8/22 19:39, Mika Westerberg wrote:
> > From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
> > 
> > Cherrytrail/Braswell is a successor of Intel Baytrail but has slighly
> > different CPU idle values and latencies.
> > 
> > Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > I learned from Mahesh that C1e, C4 and S0i2 states are deprecated so those
> > are now removed.
> 
> If the platform has ACPI supported, I believe Len wants to see what
> C-states number exported by ACPI.
> 
> Please boot the machine with "intel_idle.max_cstate=0" to disable
> intel_idle, then post the output of the following commands

OK, here goes:

> dmesg | grep idle

[    0.523624] cpuidle: using governor ladder
[    0.528215] cpuidle: using governor menu
[   16.649461] intel_idle: disabled
[   16.736481] ACPI: acpi_idle registered with cpuidle

> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/residency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/residency:2
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:1255076
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:763
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc:ACPI FFH INTEL MWAIT 0x58
/sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency:500
/sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state2/residency:1000
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:1694866
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage:639
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:ACPI FFH INTEL MWAIT 0x64
/sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:5000
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state3/residency:10000
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:380547473
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:744
