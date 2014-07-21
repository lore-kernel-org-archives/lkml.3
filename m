Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaGUUGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:06:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGUUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:06:32 -0400
Date: Mon, 21 Jul 2014 22:06:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-hotplug@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140721200625.GR3935@laptop>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <20140721172331.GB4156@linux.vnet.ibm.com>
 <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:41:59AM -0700, Tony Luck wrote:
> On Mon, Jul 21, 2014 at 10:23 AM, Nishanth Aravamudan
> <nacc@linux.vnet.ibm.com> wrote:
> > It seems like the issue is the order of onlining of resources on a
> > specific x86 platform?
> 
> Yes. When we online a node the BIOS hits us with some ACPI hotplug events:
> 
> First: Here are some new cpus
> Next: Here is some new memory
> Last; Here are some new I/O things (PCIe root ports, PCIe devices,
> IOAPICs, IOMMUs, ...)
> 
> So there is a period where the node is memoryless - although that will generally
> be resolved when the memory hot plug event arrives ... that isn't guaranteed to
> occur (there might not be any memory on the node, or what memory there is
> may have failed self-test and been disabled).

Right, but we could 'easily' capture that in arch code and make it look
like it was done in a 'sane' order. No need to wreck the rest of the
kernel to support this particular BIOS fuckup.
