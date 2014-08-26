Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaHZCio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:38:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:30623 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaHZCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,400,1406617200"; 
   d="scan'208";a="563389601"
Message-ID: <53FBF328.1080205@linux.intel.com>
Date: Tue, 26 Aug 2014 10:38:32 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Len Brown <lenb@kernel.org>, Kumar P Mahesh <mahesh.kumar.p@intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] intel_idle: add idle values for Cherrytrail/Braswell
References: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com> <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com> <53F74E5D.2040108@linux.intel.com> <20140825101200.GH1660@lahna.fi.intel.com>
In-Reply-To: <20140825101200.GH1660@lahna.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/25 18:12, Mika Westerberg wrote:
> On Fri, Aug 22, 2014 at 10:06:21PM +0800, Li, Aubrey wrote:
>> On 2014/8/22 19:39, Mika Westerberg wrote:
>>> From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
>>>
>>> Cherrytrail/Braswell is a successor of Intel Baytrail but has slighly
>>> different CPU idle values and latencies.
>>>
>>> Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> ---
>>> I learned from Mahesh that C1e, C4 and S0i2 states are deprecated so those
>>> are now removed.
>>
>> If the platform has ACPI supported, I believe Len wants to see what
>> C-states number exported by ACPI.
>>
>> Please boot the machine with "intel_idle.max_cstate=0" to disable
>> intel_idle, then post the output of the following commands
> 
> OK, here goes:

ACPI exposes 0x58 as C6 mwait hint while the patch proposes 0x52 for C6.
Can you please remove "intel_idle.max_cstate=0" and run "dmesg | grep
idle" again to see how many C6 supports in CPUID enumeration?

Thanks,
-Aubrey

> 
>> dmesg | grep idle
> 
> [    0.523624] cpuidle: using governor ladder
> [    0.528215] cpuidle: using governor menu
> [   16.649461] intel_idle: disabled
> [   16.736481] ACPI: acpi_idle registered with cpuidle
> 
>> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> 
> /sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
> /sys/devices/system/cpu/cpu0/cpuidle/state0/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
> /sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
> /sys/devices/system/cpu/cpu0/cpuidle/state0/residency:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/time:0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/usage:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/desc:ACPI FFH INTEL MWAIT 0x0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/residency:2
> /sys/devices/system/cpu/cpu0/cpuidle/state1/time:1255076
> /sys/devices/system/cpu/cpu0/cpuidle/state1/usage:763
> /sys/devices/system/cpu/cpu0/cpuidle/state2/desc:ACPI FFH INTEL MWAIT 0x58
> /sys/devices/system/cpu/cpu0/cpuidle/state2/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/latency:500
> /sys/devices/system/cpu/cpu0/cpuidle/state2/name:C2
> /sys/devices/system/cpu/cpu0/cpuidle/state2/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state2/residency:1000
> /sys/devices/system/cpu/cpu0/cpuidle/state2/time:1694866
> /sys/devices/system/cpu/cpu0/cpuidle/state2/usage:639
> /sys/devices/system/cpu/cpu0/cpuidle/state3/desc:ACPI FFH INTEL MWAIT 0x64
> /sys/devices/system/cpu/cpu0/cpuidle/state3/disable:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/latency:5000
> /sys/devices/system/cpu/cpu0/cpuidle/state3/name:C3
> /sys/devices/system/cpu/cpu0/cpuidle/state3/power:0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/residency:10000
> /sys/devices/system/cpu/cpu0/cpuidle/state3/time:380547473
> /sys/devices/system/cpu/cpu0/cpuidle/state3/usage:744
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

