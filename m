Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab3BGTxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:53:04 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38804 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3BGTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:53:03 -0500
Date: Thu, 7 Feb 2013 20:52:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130207195257.GA29985@gmail.com>
References: <20130207094650.76302f47@riff.lan>
 <20130207185608.GA25223@gmail.com>
 <20130207191345.GA28960@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207191345.GA28960@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > Yeah, that looks pretty good.
> > 
> > I'll give it some testing.
> 
> Found one build error so far, applied the fix below.

Another one was in NOMMU mode (fixed below) - a hidden sched.h 
include file dependency in mm/nommu.c.

It's looking good otherwise!

Thanks,

	Ingo

--------->
diff --git a/mm/nommu.c b/mm/nommu.c
index 79c3cac..b20db4e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -29,6 +29,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
