Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaENUDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:03:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:47697 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaENUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:03:13 -0400
Message-Id: <20140514195705.618583609@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 14 May 2014 20:03:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 0/2] rtmutex: Fix the deadlock detector for real
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai pointed out that the chain walk is incomplete aside of not
detecting even the simple AA deadlock.

The following series contains:

1) The fix for this, which replaces the hot fix I send out earlier

2) An optimization to avoid pointless de/enqueue operations in the
   deadlock chain walk

Thanks,

	tglx

