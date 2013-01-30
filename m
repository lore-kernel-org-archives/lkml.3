Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3A3VTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:19:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:52977 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3A3VTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:19:40 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: [RFC] Consider CPU idle state while choosing a new CPU
Date: Wed, 30 Jan 2013 22:19:15 +0100
Message-Id: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler does not consider the power states CPUs while selecting
an idle one. So it might happen, that it puts load on a cpu which is
in a deeper power state than another idle one, which has higher
latency and power costs than pushing the load to the core which is not
in a deep power saving state.

This patch series implements infrastructure which allows to consider
the power state in the selection process of an idle cpu. The decision
function is default off and can be enabled via a sysctl.

This is just the basic infrastructure. Further modifications are
necessary to hand in proper state information from the various idle
implementation. Its has been tested with a static testcase plugged
into the cpuidle core.

Sebastian
