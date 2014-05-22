Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaEVDZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:25:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:46225 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaEVDZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:25:27 -0400
Message-Id: <20140522031841.797415507@linutronix.de>
User-Agent: quilt/0.60-1
Date: Thu, 22 May 2014 03:25:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 0/6] rtmutex: Repair deadlock detector and cleanup
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in the series makes the deadlock detector work again.

The second is removing the rtmutex tester as with the current
implementation of the lock chain walk plus the demise of the lock
steal mechanism and the BKL extra logic, we can now build a tester in
userspace via the futex syscall.

The other patches clarify and optimize the deadlock detection logic
and the lock chain walk mechanism.

Thanks,

	Thomas



