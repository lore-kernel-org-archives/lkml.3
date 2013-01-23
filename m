Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3AWGWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:22:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51287 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3AWGWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:22:12 -0500
Date: Tue, 22 Jan 2013 22:22:02 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/6][v4]: perf: Make POWER7 events available in sysfs
Message-ID: <20130123062201.GA13720@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012306-7408-0000-0000-00000C22FEA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/6][v4]: perf: Make POWER7 events available in sysfs

Make the generic and some POWER7-specific perf events available in sysfs.
These changes mainly extend similar functionality implemented in x86 to
work on POWER architecture as well.

Thanks to input from Stephane Eranian, Robert Richter, Peter Ziljstra
and Jiri Olsa.

Changelog[v4]:
	[Jiri Olsa]: Document that multiple event= like terms can be specified
	in the 'events' file.
	[Jiri Olsa]: Remove the documentation for the 'config format' file
	as it is already documented in 'Documentation/ABI/testing/'
	[Jiri Olsa]: Move the ABI documentaion from 'stable/' to 'testing/'.

Changelog[v3]:
	[Jiri Olsa]: No need to define EVENT_ID, PMU_EVENT_PTR() if used only
	once
	[Greg KH]: Document the new sysfs interfaces in Documenation/ABI

Changelog[v2]:
	[Jiri Olsa] Use PMU_FORMAT_ATTR() rather than duplicating code.

Sukadev Bhattiprolu (6):
  perf/Power7: Use macros to identify perf events
  perf: Make EVENT_ATTR global
  perf/POWER7: Make generic event translations available in sysfs
  perf/POWER7: Make some POWER7 events available in sysfs
  perf: Create a sysfs entry for Power event format
  perf: Document the ABI of perf sysfs entries

 .../testing/sysfs-bus-event_source-devices-events  |   62 +++++++++++++++
 arch/powerpc/include/asm/perf_event_server.h       |   32 ++++++++
 arch/powerpc/perf/core-book3s.c                    |   24 ++++++
 arch/powerpc/perf/power7-pmu.c                     |   81 ++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event.c                   |   13 +---
 include/linux/perf_event.h                         |   11 +++
 6 files changed, 205 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-events

