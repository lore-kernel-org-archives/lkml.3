Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaDAXp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:45:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:62729 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaDAXp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:45:57 -0400
Date: Tue, 1 Apr 2014 19:46:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Brown, Len" <len.brown@intel.com>
CC: "WYSOCKI, RAFAL" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Message-ID: <20140401234612.GA22782@windriver.com>
References: <533B0288.2020304@windriver.com>
 <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RE: Regression in intel_idle on Avaton/Rangely Mohon Peak board] On 01/04/2014 (Tue 17:59) Brown, Len wrote:

> > I've got an eval board with a 1.7GHz Avaton/C2000 that hangs at boot
> > shortly after the idle driver registration -- typically 1/2 dozen
> > dmesg lines later, around rtc init, or net stack init.
> 
> Paul,
> Please boot the failing board with "intel_idle.max_cstate=0"
> to disable intel_idle entirely, and then show the C-states
> exported by acpi_idle, that predumably, are stable on both boards:
> 
> dmesg | grep idle
> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> 
> Then go back and boot with "intel_idle.max_cstate=N"
> where N is incremented by 1 until when the system fails
> and note the largest N that still works.

OK, I kept the failing board on loan, since I expected a reply that
would contain "can you try this..."  :)   I will be able to do the
above tomorrow (EST).

> 
> > The interesting part is that a nearly identical board, but with
> > different (newer/faster) CPU and newer BIOS doesn't have the hang.
> 
> Possibly an electrical bug in the earlier board.
> Maybe they worked around it by disabling a C-state in ACPI
> and didn't test upstream Linux?
> 
> I'd be interested in the acpi_idle output above for both the
> new and old boards to see if they are exporting different states
> on the two boards.

Could be ; I can probably get access to the newer one again too, if
that will be useful.

> 
> dmidecode isn't useful in this case.  The CPUID in /proc/cpuinfo
> may be useful if the problem turns out to be associated with
> some stepping.

The dmidecode info I'd posted indicated that the steppings were
unnchanged.  I can get the /proc/cpuinfo tomorrow, but I figured
the dmidecode stepping info was accurate.  Is it not reliable?

P.
--

> 
> thanks,
> -Len
> 
