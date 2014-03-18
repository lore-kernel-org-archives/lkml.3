Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaCRRVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:21:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51983 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbaCRRVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:21:12 -0400
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/2] sysctl: fix incorrect write position handling
Date: Tue, 18 Mar 2014 10:17:58 -0700
Message-Id: <1395163080-6290-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This creates a series of tests designed to examine the behavior of sysctl
write behavior, and corrects some unexpected side-effects of the current
file offset handling when writing sysctls. Namely, short appends don't
work and multiple writes (with incremented file position) rewrite the
sysctl string contents.

-Kees

