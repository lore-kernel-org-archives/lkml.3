Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaDRASa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:18:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42647 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaDRAS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:18:28 -0400
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andrew Shewmaker <agshew@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Jens Axboe <axboe@fb.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH v2 0/4] sysctl: fix incorrect write position handling
Date: Thu, 17 Apr 2014 17:16:19 -0700
Message-Id: <1397780183-24633-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a sysctl string, each write, regardless of VFS position,
began writing the string from the start. This meant the contents of
the last write to the sysctl controlled the string contents instead of
the first.

This misbehavior was featured in an exploit against Chrome OS. While it's
not in itself a vulnerability, it's a weirdness that isn't on the mind
of most auditors: "This filter looks correct, the first line written
would not be meaningful to sysctl" doesn't apply here, since the size
of the write and the contents of the final write are what matter when
writing to procfs.

For the paranoid, introduce CONFIG_PROC_SYSCTL_STRICT_WRITES to
change the behavior to track file position most strictly.

Thanks,

-Kees

