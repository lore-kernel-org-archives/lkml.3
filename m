Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3HJRtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:49:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35980 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3HJRtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:49:00 -0400
Date: Sat, 10 Aug 2013 10:48:32 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 0/7]: Enable 'perf mem' command for Power
Message-ID: <20130810174831.GA15551@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081017-3620-0000-0000-000003E3DAB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/7]: Enable 'perf mem' command for Power

'perf mem' command enables analyzing the memory operations of an
application. It needs the kernel to export the memory hierarcy
level from which a load instruction was satisfied.

It also needs the Power kernel to make the 'mem-loads' and 'mem-stores'
generic events available in sysfs. While there, we also export the
other Power8 generic events in sysfs.

Thanks to input from Stephane Eranian and Michael Ellerman.

P.S. The patchset builds on several configurations including pmac32_defconfig.
     But I am unable to verify the build on few other configs due to a problem
     unrleated to this patchset. That is being discussed in a separate thread.
     I would like some feedback on this patchset in the meanwhile.

Sukadev Bhattiprolu (7):
  powerpc/perf: Rename Power8 macros to start with PME
  powerpc/perf: Export Power8 generic events in sysfs
  powerpc/perf: Create mem-loads/mem-stores events for Power8
  powerpc/perf: Create mem-loads/mem-stores events for Power7
  powerpc/perf: Define big-endian version of perf_mem_data_src
  powerpc/perf: Export Power8 memory hierarchy info to user space.
  powerpc/perf: Export Power7 memory hierarchy info to user space.

 arch/powerpc/include/asm/perf_event_server.h |    2 +
 arch/powerpc/perf/core-book3s.c              |   11 +++
 arch/powerpc/perf/power7-pmu.c               |   81 ++++++++++++++++++++
 arch/powerpc/perf/power8-pmu.c               |  106 +++++++++++++++++++++++---
 include/uapi/linux/perf_event.h              |   55 +++++++++++++
 5 files changed, 243 insertions(+), 12 deletions(-)

