Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaKCV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:26:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:60047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKCV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:26:17 -0500
Date: Mon, 3 Nov 2014 22:26:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: arapov@gmail.com, poros@redhat.com
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        matt@console-pimps.org
Subject: FW/BIOS Bug category for oops.kernel.org
Message-ID: <20141103212610.GA10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi oops.kernel.org folks,

I'm wanting to collect information on FW/BIOS bugs, and I figured that
we could use the oops.kernel.org infrastructure to do this.

Now, I'd prefer to not use the regular BUG/WARN because it might confuse
users and the stacktrace is entirely pointless -- we know were/why we
generate the msgs.

Is everything between:

        pr_warn("------------[ cut here ]------------\n");
and:
        pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);

sucked in automagically, or do we need more magic?

I was thinking of adding a body like:

	FW/BIOS fail: $msg
	Hardware name: $dump_stack_arc_desc_str
	CPU model name: $cpuinfo_x86->x86_model_id

Which would allow us to index on both CPU and Hardware.


Can we make this happen?
