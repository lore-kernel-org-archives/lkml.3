Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaK1Cnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:43:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64740 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaK1Cnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:43:51 -0500
From: Wang Weidong <wangweidong1@huawei.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <wangweidong1@huawei.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 0/2] fix some problems for cpufreq
Date: Fri, 28 Nov 2014 10:43:37 +0800
Message-ID: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael and Viresh

Sorry to trouble you again. As for:
"acpi-cpufreq: get the cur_freq from acpi_processor_performance states"
I do it again, and add the other patch.

patch #1: acpi-cpufreq: make the freq_table store the same freq value

I think it can work. The set of available states which come
from acpi won't change. Just like the power would be remove,
the acpi driver will do that:
call
 ->acpi_processor_ppc_has_changed
 ->cpufreq_update_policy
 ->acpi_ppc_notifier_block.notifier_call
   ->acpi_processor_ppc_notifier
   ->cpufreq_verify_within_limits
The progress will change the policy's min_freq and max_freq
while it won't change the set of states(freq_tables).

patch #2: cpufreq: show the real avail freqs with the freq_table

when the min_freq and max_freq change, we should sync the availble
freqs.

Regards,
Wang

Wang Weidong (2):
  acpi-cpufreq: make the freq_table store the same freq value
  cpufreq: show the real avail freqs with the freq_table

 drivers/cpufreq/acpi-cpufreq.c | 2 +-
 drivers/cpufreq/freq_table.c   | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.12


