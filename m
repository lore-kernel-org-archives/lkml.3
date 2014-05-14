Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaENU7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:59:55 -0400
Received: from relais.videotron.ca ([24.201.245.36]:62660 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaENU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:59:54 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 0/6] sched: expel confusing usage of the term "power"
Date: Wed, 14 May 2014 16:57:04 -0400
Message-id: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Power" is a very bad term in the scheduler context.  There are so many
meanings that can be attached to it.  And with the upcoming "power
aware" scheduler work confusion is sure to happen.

The definition of "power" is typically the rate at which work is performed,
energy is converted or electric energy is transferred.  The notion of
"compute capacity" is rather at odds with "power" to the point many
comments in the code have to make it explicit that "capacity" is the
actual intended meaning.

So let's make it clear what we man by using "capacity" in place of "power"
directly in the code.  That will make the introduction of actual "power
consumption" concepts much clearer later on.

This is based on the latest tip tree where scheduler changes are already
queued.

Note: The diffstat is not completely symetric wrt added/removed lines as
some comments were reflowed.


 arch/arm/kernel/topology.c |  54 +++----
 include/linux/sched.h      |   8 +-
 kernel/sched/core.c        |  89 ++++++-----
 kernel/sched/fair.c        | 322 ++++++++++++++++++++-------------------
 kernel/sched/sched.h       |  18 +--
 5 files changed, 246 insertions(+), 245 deletions(-)


Nicolas
