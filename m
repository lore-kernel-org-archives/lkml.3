Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302Ab3DHRlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:41:04 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:65040 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935263Ab3DHRlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:41:03 -0400
MIME-Version: 1.0
Date: Mon, 8 Apr 2013 23:41:01 +0600
Message-ID: <CADZ9YHgnss=9NrMGDgo3pO41YHQK17JZyGp=DsAUV2kVz4hSjw@mail.gmail.com>
Subject: [QUESTION] loops_per_jiffy calculation from smp_callin().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo and all,

In function arch/x86/kernel/smpboot.c::smp_callin(), we do a
calibrate_delay(), the reason behind doing this is commented as
follows:

         * Get our bogomips.
         * Update loops_per_jiffy in cpu_data. Previous call to
         * smp_store_cpu_info() stored a value that is close but not as
         * accurate as the value just calculated.

Now, if we look at the init/calibrate.c::calibrate_delay() - a percpu
variable cpu_loops_per_jiffy is used to cache up the loops_per_jiffy
value. If cpu_loop_per_jiffy value is set (which should be after first
run) then it prevents calculating new loops_per_jiffy thus the
accuracy expected from the callsite isn't getable (I'm thinking about
cpu hotpluging for few times). Is it not something that we should care
about? Is lpj value is that important to recalculate (when mostly we
read from tsc)? And, if it's important, how cpu_loop_per_jiffy is
helping?


Thanks,
Rakib.
