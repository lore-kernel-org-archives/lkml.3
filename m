Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaDYIS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:18:58 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45234 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaDYISp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:18:45 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Cpufreq frequency serialization fixes
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 25 Apr 2014 13:47:58 +0530
Message-ID: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042508-9574-0000-0000-00000D3F4CD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
The root-cause of this issue is the extra invocation of the
cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
drivers as well. This patchset fixes the issue in all the 3 drivers.

 Srivatsa S. Bhat (3):
      cpufreq, powernow-k7: Fix double invocation of cpufreq_freq_transition_begin/end
      cpufreq, powernow-k6: Fix double invocation of cpufreq_freq_transition_begin/end
      cpufreq, longhaul: Fix double invocation of cpufreq_freq_transition_begin/end


 drivers/cpufreq/longhaul.c    |   12 ++++++++----
 drivers/cpufreq/powernow-k6.c |   20 +++++++++++---------
 drivers/cpufreq/powernow-k7.c |    4 ----
 3 files changed, 19 insertions(+), 17 deletions(-)


Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

