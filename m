Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaFSPID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbaFSPH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:07:59 -0400
Date: Thu, 19 Jun 2014 17:06:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Halcrow <mhalcrow@us.ibm.com>,
        Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [trace:ftrace/core 1/3] include/trace/syscall.h:39:6: error:
	'TIF_SYSCALL_TRACEPOINT' undeclared
Message-ID: <20140619150647.GA7803@redhat.com>
References: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com> <20140618211559.76bdea15@gandalf.local.home> <20140619101016.6f6396df@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619101016.6f6396df@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Steven Rostedt wrote:
>
> On Wed, 18 Jun 2014 21:15:59 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Thu, 19 Jun 2014 03:25:46 +0800
> > kbuild test robot <fengguang.wu@intel.com> wrote:
> >
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
> > > head:   72fa1a896d8ef355e81270667803ceb16a3dd13f
> > > commit: 32def52ce8faec72c353b6304ca98176687e18f1 [1/3] tracing: Fix syscall_*regfunc() vs copy_process() race
> > > config: make ARCH=xtensa allyesconfig
>
> I got a bit confused because I just noticed that the patch does include
> thread_info.h. But then I noticed that TIF_SYSCALL_TRACEPOINT is
> defined in arch/x86/include/asm/thread_info.h, and this is generic
> code. and the error here is for ARCH=xtensa. We can not be using this.

Yes, I was confused the same way.

> Crap, I just sent a pull request to Linus, I'll have to tell him not to
> pull it.
>
> I'll look for other solutions.

Sorry. Please see another email I sent, we probably need
CONFIG_HAVE_SYSCALL_TRACEPOINTS.

Oleg.

