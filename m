Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3D2JZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:25:12 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54682 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3D2JZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:25:09 -0400
MIME-Version: 1.0
Date: Mon, 29 Apr 2013 11:25:07 +0200
Message-ID: <CA+xJJ1-2zHMjV3AFiprRjChEff=Bynj4uK_1wL6vKVR=H-T8Bg@mail.gmail.com>
Subject: lttng and full nohz
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been investigating why lttng destroys full nohz mode, and the
root cause is that lttng uses timers for flushing trace buffers. So
I'm planning on moving the timers to the ticking CPU, so that any CPU
using full nohz mode can continue to do so even though they might have
tracepoints.

I can see that kernel/sched/core.c has the function
get_nohz_timer_target() which tries to find an idle CPU to allocate
for a timer that has not specified a CPU to be pinned to.

My question here is: For full nohz mode, should this still be "only"
an idle CPU, or should it be translated to a CPU not running in full
nohz mode? I'd think this could make it a lot easier to allow
applications to make full use of full nohz.

/Mats
