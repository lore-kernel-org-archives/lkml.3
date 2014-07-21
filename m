Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaGURmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:42:06 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33756 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaGURmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140721172331.GB4156@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
	<20140721172331.GB4156@linux.vnet.ibm.com>
Date: Mon, 21 Jul 2014 10:41:59 -0700
Message-ID: <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
From: Tony Luck <tony.luck@gmail.com>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-hotplug@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:23 AM, Nishanth Aravamudan
<nacc@linux.vnet.ibm.com> wrote:
> It seems like the issue is the order of onlining of resources on a
> specific x86 platform?

Yes. When we online a node the BIOS hits us with some ACPI hotplug events:

First: Here are some new cpus
Next: Here is some new memory
Last; Here are some new I/O things (PCIe root ports, PCIe devices,
IOAPICs, IOMMUs, ...)

So there is a period where the node is memoryless - although that will generally
be resolved when the memory hot plug event arrives ... that isn't guaranteed to
occur (there might not be any memory on the node, or what memory there is
may have failed self-test and been disabled).

-Tony
