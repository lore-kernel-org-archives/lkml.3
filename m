Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3KFPXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:23:46 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44117 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KFPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:23:45 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: x86: Enhance perf checksum profiling and x86 implementation
Date: Wed,  6 Nov 2013 10:23:17 -0500
Message-Id: <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	Sorry for the delay here, but it took me a bit to get the perf bits
working to my satisfaction.  As Ingo requested I added do_csum to the perf
benchmarking utility (as part of the mem suite, since it didn't seem right to
create its own suite).  I've also revamped the do_csum routine to do some smart
prefetching, as it yielded slightly better performance over simple prefetching
at a fixed stride:

Without prefetch:
[root@rdma-dev-02 perf]# ./perf bench mem csum -r x86-64-csum -l 1500B -s 512MB
-i 1000000 -c
# Running mem/csum benchmark...
# Copying 1500B Bytes ...

       0.955977 Cycle/Byte

With prefetch:
[root@rdma-dev-02 perf]# ./perf bench mem csum -r x86-64-csum -l 1500B -s 512MB
-i 1000000 -c
# Running mem/csum benchmark...
# Copying 1500B Bytes ...

       0.922540 Cycle/Byte


About a 3% improvement.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: sebastien.dugue@bull.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org

