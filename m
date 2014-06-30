Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbaF3Q7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:59:49 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53442 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbaF3Q7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:59:46 -0400
From: Stratos Karafotis <stratosk@semaphore.gr>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] cpufreq: ondemand: Eliminate the deadband effect
Date: Mon, 30 Jun 2014 19:59:32 +0300
Message-Id: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patchset changes slightly the calculation of target frequency to
eliminate the deadband effect (explained in patch 2 changelog) that it
seems to slow down the CPU in low and medium loads.

Patch 1 introduces a new relation (RELATION_C) for the next frequency
selection, which chooses the closest frequency to target.

Patch 2 is the actual change to ondemand governor.

You may find graphs with the 'deadband' effect and benchmark results:
https://docs.google.com/spreadsheets/d/16kDBh5lyc6YvBnoS1hUa1t2O38z0xrWvaEj5XtJ8auw/edit#gid=2072493052

Thanks


Stratos Karafotis (2):
  cpufreq: Introduce new relation for freq selection
  cpufreq: ondemand: Eliminate the deadband effect in low loads

 drivers/cpufreq/cpufreq_ondemand.c | 11 +++++++----
 drivers/cpufreq/freq_table.c       | 12 +++++++++++-
 include/linux/cpufreq.h            |  1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

-- 
1.9.3

