Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3EXOXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab3EXOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:23:47 -0400
Date: Fri, 24 May 2013 10:23:38 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: rcu_read_lock() used illegally while idle!
Message-ID: <20130524142338.GB3106@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
 <20130522093624.GZ3578@linux.vnet.ibm.com>
 <1369226958.6828.175.camel@gandalf.local.home>
 <20130523164004.GJ16419@redhat.com>
 <1369403180.6828.223.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369403180.6828.223.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 09:46:20AM -0400, Steven Rostedt wrote:

 > >  > This looks to be the caused by the same issue that this patch fixes:
 > >  > 
 > >  > https://lkml.org/lkml/2013/5/10/537
 > >  > 
 > >  > The schedule_user() was traced, and the preempt_enable_no_trace() that
 > >  > the function tracer does caused for a schedule to occur. As the
 > >  > scheduler uses rcu, and it was called before schedule_user() could tell
 > >  > the kernel that the context is changing from user to kernel.
 > > 
 > > That patch doesn't help unfortunatly.
 > > 
 > 
 > Dave,
 > 
 > Can you send me your full .config, and also what you did to trigger
 > this? As I see ftrace_call is there, I'm assuming you have function
 > tracing enabled somewhere. Probably via perf, as ftrace_ops_control_func
 > is used by perf.
 > 
 > Also, if you added anything special on the kernel command line, that
 > info will be useful too.

.config: http://paste.fedoraproject.org/14281/94052971/raw/

trace shows the problem process was 'cc1', so I was likely building a kernel
at the time.  There was also a trinity run going on in the background.

cmdline: nothing special..

BOOT_IMAGE=/vmlinuz-3.10.0-rc2+ root=UUID=bee21cd9-1852-4d1d-9e9d-2e44332b8df1 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 audit=0

	Dave

