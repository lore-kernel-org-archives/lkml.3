Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab3BHMYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:24:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48036 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3BHMYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:24:53 -0500
Message-ID: <5114EE1C.1040802@linux.vnet.ibm.com>
Date: Fri, 08 Feb 2013 17:52:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: lsf-pc@lists.linux-foundation.org
CC: linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [LSF/MM TOPIC][ATTEND] Linux VM Infrastructure to support Memory
 Power Management
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020812-0260-0000-0000-0000028187EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today, we are increasingly seeing computer systems sporting larger and larger
amounts of RAM, in order to meet workload demands. However, memory consumes a
significant amount of power, potentially upto more than a third of total system
power on server systems. So naturally, memory becomes the next big target for
power management - on embedded systems and smartphones, and all the way upto
large server systems.

Modern memory hardware such as DDR3 support a number of power management
capabilities. And new firmware standards such as ACPI 5.0 have added support
for exposing the power-management capabilities of the underlying memory hardware
to the Operating System. So it is upto the kernel's MM subsystem to make the
best use of these capabilities and manage memory power-efficiently.
It had been demonstrated on a Samsung Exynos board (with 2 GB RAM) that upto
6% of total system power can be saved by making the Linux kernel MM subsystem
power-aware[1]. (More savings can be expected on systems with larger amounts
of memory, and perhaps improved further using better MM designs).

Often this simply translates to having the Linux MM understand the granularity
at which RAM modules can be power-managed, and consolidating the memory
allocations and references to a minimum no. of these power-manageable
"memory regions". It is of particular interest to note that most of these
memory hardware have the intelligence to automatically save power, such as
putting memory banks into (content-preserving) low-power states when not
referenced for a threshold amount of time. All that the kernel has to do, is
avoid wrecking the power-savings logic by scattering its allocations and
references all over the system memory. IOW, the kernel/MM doesn't really need
to keep track of memory DIMMs and perform their power-state transitions - most
often it is automatically handled by the hardware/memory-controller. The MM
has to just co-operate by keeping the references consolidated to a minimum
no. of memory regions.

To that end, I had recently posted patchsets implementing 2 very different MM
designs, namely the "Hierarchy" design[2] (originally developed by Ankita Garg)
and the new "Sorted-buddy" design[3]. The challenge with the latter design is
that it can potentially lead to increased run-time memory allocation overheads.
At the summit, I would like to brainstorm on ideas and designs for reducing the
run-time cost of implementing memory power management, and seek suggestions and
feedback from MM developers on the issues involved.

About myself:
------------
I have been contributing to CPU- and System-wide power management subsystems in
the kernel such as CPU idle and Suspend-to-RAM, in terms of enhancements to their
reliability/scalability. In particular, I have contributed to some of the
core kernel infrastructure that Suspend-to-RAM depends on, such as Freezer and
CPU hotplug, and have been working towards redesigning CPU hotplug to get rid of
some of its pain points.

Recently I have been looking at conserving memory power, and came up with the
"Sorted-buddy" design [3] of the Linux MM, which alters the buddy allocator to
keep memory allocations consolidated to a minimum no. of memory regions. I would
like to discuss this topic with other MM developers at the summit and get
feedback on the best way to take this technology forward.


References:
----------

1. Estimate of potential power savings on Samsung exynos board
   http://article.gmane.org/gmane.linux.kernel.mm/65935

2. "Hierarchy" design for Memory Power Management:
    http://lwn.net/Articles/445045/ (Original posting by Ankita Garg)
    http://lwn.net/Articles/523311/ (Forward-port to 3.7-rc3)

3. "Sorted-buddy" design for Memory Power Management:
    http://article.gmane.org/gmane.linux.power-management.general/28498/


Regards,
Srivatsa S. Bhat

