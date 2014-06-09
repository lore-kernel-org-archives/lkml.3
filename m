Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaFIU2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:28:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:46587 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaFIU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:28:11 -0400
Message-Id: <20140609201118.387571774@linutronix.de>
User-Agent: quilt/0.63-1
Date: Mon, 09 Jun 2014 20:28:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch V3 0/7] rtmutex: Code clarification and optimization
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another round of clarification and optimization patches for
the rtmutex code.

When I looked last week into the dead lock detector I spent some time
to figure out how the various arguments and local variables are
protected and whats the scope of the various protection algorithms, so
I added documentation for this as well.

I also changed the last patch which avoids the requeueing in case of
the deadlock detection only chain walk. Instead of adding tons of
conditional to the boost/deboost code path I simply have a separate
code path for it.

Thanks,

	tglx

