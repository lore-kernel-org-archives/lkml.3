Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3BKJzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:55:07 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60908 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3BKJzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:55:05 -0500
Date: Mon, 11 Feb 2013 10:54:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130211095457.GF23932@gmail.com>
References: <20130207094650.76302f47@riff.lan>
 <20130207185608.GA25223@gmail.com>
 <20130207191345.GA28960@gmail.com>
 <20130207195257.GA29985@gmail.com>
 <20130207150838.02226207@riff.lan>
 <20130208141841.GB30334@gmail.com>
 <20130208085828.02e61518@riff.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208085828.02e61518@riff.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> I figured that was coming. :)

;-)

> I'll look at it again and see about pulling the 
> autogroup/cgroup stuff into it's own header. After that it's 
> probably going to require some serious changes.
> 
> Any suggestions?

I'd suggest doing it as finegrained as possible - potentially 
one concept at a time. I wouldn't mind a dozen small files in 
include/linux/sched/ - possibly more.

In the end sched.h would include core wakeup/sleep methods that 
tons of drivers rely on, and it would include the 'struct 
task_struct' data type definition (and all its prereqs), which 
we rely on in tons of drivers as well.

Not much else should remain in sched.h - in theory :-)

In terms of build coverage: just build an x86 defconfig with 
perhaps the specific sub-feature (such as autogroups/cgroups) 
turned off/on - I'd suggest for you to not even do allmodconfig 
testing (which is really slow unless you have a cluster of build 
machines), I can test all that and more and fix the fallout 
before applying it.

Thanks,

	Ingo
