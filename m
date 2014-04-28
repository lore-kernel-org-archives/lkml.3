Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaD1TZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:25:00 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35733 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbaD1TY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:24:57 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 0/5] Cpufreq frequency serialization fixes
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 Apr 2014 00:23:54 +0530
Message-ID: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-1396-0000-0000-000004C0BC3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
The root-cause of this issue is the extra invocation of the
cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
drivers as well. This patchset fixes the issue in all the 3 drivers and also
adds a debug infrastructure to catch such issues easily.

Patches 1-4 fix the regression in longhaul, powernow-k6 and powernow-k7
drivers. (Patch 2 fixes a different bug in powernow-k6, and it is kept as a
separate patch instead of merging it with patch 3, because I felt that it was
a bit subtle and needed attention in a separate patch).

Patch 5 adds a debug infrastructure to the cpufreq core to catch such problems
more easily in the future.


Changes in v2:
--------------

* Modified patch 1 to take error returns into account, as pointed out by
  Viresh.
* Added patch 2 to fix the existing issue in the powernow-k6 driver, pointed
  out by Viresh.
* Added patch 5 to introduce a debug infrastructure to catch such issues
  easily.


 Srivatsa S. Bhat (5):
      cpufreq, longhaul: Fix double invocation of cpufreq_freq_transition_begin/end
      cpufreq, powernow-k6: Fix incorrect comparison with max_multipler
      cpufreq, powernow-k6: Fix double invocation of cpufreq_freq_transition_begin/end
      cpufreq, powernow-k7: Fix double invocation of cpufreq_freq_transition_begin/end
      cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end


 drivers/cpufreq/cpufreq.c     |   12 ++++++++++++
 drivers/cpufreq/longhaul.c    |   36 ++++++++++++++++++++++++------------
 drivers/cpufreq/powernow-k6.c |   23 +++++++++++++----------
 drivers/cpufreq/powernow-k7.c |    4 ----
 include/linux/cpufreq.h       |    1 +
 5 files changed, 50 insertions(+), 26 deletions(-)


Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

