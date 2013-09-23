Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3IWTMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:12:52 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:58418 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab3IWTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:12:50 -0400
Message-ID: <000001414c3d0395-084ac372-80cc-47f0-9889-78d7bfb36671-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 23 Sep 2013 19:12:49 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v1 0/4] percpu v1: Implement Preemption checks for __this_cpu operations
X-SES-Outgoing: 2013.09.23-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces preemption checks for __this_cpu operations.

First we add new raw_cpu operations that perform this cpu operations
without preempt checks. Then we convert some uses in the core VM to
raw_cpu ops that would otherwise trigger after we add the preempt
checks.

The last patch then adds the preempt checks by modifying the
__this_cpu macros in include/linux/percpu.h


