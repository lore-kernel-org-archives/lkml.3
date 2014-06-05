Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaFEP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:28:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:49928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaFEP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:28:35 -0400
Message-Id: <20140605152544.641846795@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 15:28:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch 0/2] rtmutex: Sanitze deadlock detection and chain walk
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad found a flaw in the dead lock detection logic when the lock chain
changes during the chain walk and tried to fixup the deadlock detector
itself.

The following patches address this issue in a different way. Instead
of guessing about the chain change, simply detect it.

Thanks,

	tglx

