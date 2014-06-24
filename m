Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaFXGzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:55:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42116 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXGzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:55:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [for-next][PATCH v2 1/3] tracing: Fix syscall_*regfunc() vs copy_process() race
References: <20140620104518.722157733@goodmis.org>
	<20140620104711.140660296@goodmis.org>
Date: Tue, 24 Jun 2014 15:55:41 +0900
In-Reply-To: <20140620104711.140660296@goodmis.org> (Steven Rostedt's message
	of "Fri, 20 Jun 2014 06:45:19 -0400")
Message-ID: <871tue7q4y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Fri, 20 Jun 2014 06:45:19 -0400, Steven Rostedt wrote:
> From: Oleg Nesterov <oleg@redhat.com>
>
> syscall_regfunc() and syscall_unregfunc() should set/clear
> TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> with copy_process() and miss the new child which was not added to
> the process/thread lists yet.
>
> Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> under tasklist.

s/tasklist/tasklist_lock/ ?

Probably I'm too late..

Thanks,
Namhyung
