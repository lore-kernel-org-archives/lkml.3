Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3BDWpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:45:54 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755938Ab3BDWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:45:52 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems 
Date: Mon,  4 Feb 2013 16:45:11 -0600
Message-Id: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am noticing the cpufreq_driver_lock is quite hot.
On an idle 512 system perf shows me most of the system time is spent on this
lock.  This is quite signifigant as top shows 5% of time in system time.
My solution was to first convert the lock to a rwlock and then to the rcu.


Nathan Zimmer (2):
  cpufreq: Convert the cpufreq_driver_lock to a rwlock
  cpufreq: Convert the cpufreq_driver_lock to use the rcu

 drivers/cpufreq/cpufreq.c | 139 ++++++++++++++++++++++++++--------------------
 1 file changed, 79 insertions(+), 60 deletions(-)

-- 
1.8.0.1

