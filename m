Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3CPBW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:22:27 -0400
Received: from fifo99.com ([67.223.236.141]:47559 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab3CPBW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:22:26 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Mar 2013 21:22:26 EDT
Date: Fri, 15 Mar 2013 18:15:09 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: ptracing a task from core_pattern pipe
Message-ID: <20130316011508.GA11010@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was writing an application to ptrace a process which is dumping core
from inside the pipe application for core_pattern.

So for example you make core pattern equal to something like
"|/bin/corepipe_app" then the kernel runs that app prior to actually
killing the process that failed.

Before the pipe application runs it puts SIGKILL on the pending signal
list for the failed application. However the application can't run.

This commit,

9899d11f654474d2d54ea52ceaa2a1f4db3abd68

seems to put a damper on ptracing the application at this point.

So I wanted to see what you think of all this.. Can we add an exception
to this which would allow operations on a task which is dumping core,
but still has SIGKILL pending. The other way would be to not add SIGKILL
till after the pipe app runs.

As of right now I can PTRACE_ATTACH, but the operations all fail with
-ESRCH .

Daniel

