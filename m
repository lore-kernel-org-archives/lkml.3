Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3EXWng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:43:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3EXWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:43:35 -0400
Date: Fri, 24 May 2013 18:41:52 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: rcu_read_lock() used illegally while idle!
Message-ID: <20130524224152.GC17786@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
 <20130522093624.GZ3578@linux.vnet.ibm.com>
 <1369226958.6828.175.camel@gandalf.local.home>
 <20130523164004.GJ16419@redhat.com>
 <1369403180.6828.223.camel@gandalf.local.home>
 <20130524142338.GB3106@redhat.com>
 <1369423420.6828.226.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369423420.6828.226.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 03:23:40PM -0400, Steven Rostedt wrote:
 > On Fri, 2013-05-24 at 10:23 -0400, Dave Jones wrote:
 > 
 > > .config: http://paste.fedoraproject.org/14281/94052971/raw/
 > > 
 > > trace shows the problem process was 'cc1', so I was likely building a kernel
 > > at the time.  There was also a trinity run going on in the background.
 > > 
 > > cmdline: nothing special..
 > > 
 > > BOOT_IMAGE=/vmlinuz-3.10.0-rc2+ root=UUID=bee21cd9-1852-4d1d-9e9d-2e44332b8df1 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 audit=0
 > > 
 > 
 > OK, I'm able to reproduce this. Looks like the same issue happens from
 > other ways from userspace into the kernel (the next way was tracing
 > system calls).
 > 
 > Forget the other patch. Here's a new patch that is more specific to
 > tracing and context tracking.
 > 
 > Can you try this one out, please.

It's looking good so far.

	Dave

