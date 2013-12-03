Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3LCRQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:16:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab3LCRQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:16:12 -0500
Subject: [BUG] ftrace: support for SOFT_DISABLE to syscall events caused
 huge slowdown of ftrace startup test
From: Petr Mladek <pmladek@suse.cz>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Dec 2013 18:16:09 +0100
Message-ID: <1386090969.1603.72.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested my ftrace-related patches and enabled also the startup test:

  CONFIG_FTRACE_SELFTEST=y
  CONFIG_FTRACE_STARTUP_TEST=y

On today's kernel/git/tip/tip.git, the boot "freezed" for 1 minute when
doing "Testing event system syscalls".

A bisect pointed finger to the commit d562aff93bfb530b099 (tracing: Add
support for SOFT_DISABLE to syscall events).

It seems that the culprit are the "synchronize_sched" calls added to
"unreg_event_syscall_enter" and "unreg_event_syscall_exit" functions.
They are called 2312 times during the boot here and are responsible for
the delay.

I wonder if it might cause slowdown also at runtime.

I am going to look deeper into the code and eventually come up with a
solution. But it might take some time. I am still newbie in the kernel
development. Any hints or tips are welcome ;-)

Best Regards,
Petr

