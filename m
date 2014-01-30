Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaA3OJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:09:26 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59058 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaA3OJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:09:23 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: nicolas.pitre@linaro.org, peterz@infradead.org, mingo@redhat.com,
        tglx@linutronix.de, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC PATCH 0/3] cpuidle/sched: move main idle function in the idle.c
Date: Thu, 30 Jan 2014 15:09:19 +0100
Message-Id: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset relies on the "setting the table for integration of cpuidle with
the scheduler" from Nicolas Pitre where the idle.c file has been moved into the
sched directory.

It encapsulate the cpuidle main code into three exported functions which are
used by the cpuidle_idle_call function. This one is then moved into the idle.c
file.

The third patch shows an example on how integrating cpuidle information in the
scheduler is easier.

Daniel Lezcano (3):
  cpuidle: split cpuidle_idle_call main function into functions
  cpuidle: move the cpuidle_idle_call function to idle.c
  idle: store the idle state index in the struct rq

 drivers/cpuidle/cpuidle.c |   80 +++++++++++++++++++++++++--------------------
 include/linux/cpuidle.h   |    9 +++--
 kernel/sched/idle.c       |   53 ++++++++++++++++++++++++++++++
 kernel/sched/sched.h      |    3 ++
 4 files changed, 108 insertions(+), 37 deletions(-)

-- 
1.7.9.5

