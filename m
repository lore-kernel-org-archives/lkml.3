Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaEAOYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:24:20 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50991 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaEAOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:24:18 -0400
Date: Thu, 1 May 2014 10:24:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140501142414.GA31611@htj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398868249-26169-10-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:30:42PM +0200, Jiri Slaby wrote:
> Some threads do not use kthread_should_stop. Before we enable a

Haven't really following kgraft development but is it safe to assume
that all kthread_should_stop() usages are clean side-effect-less
boundaries?  If so, why is that property guaranteed?  Is there any
mechanism for sanity checks?  Maybe I'm just failing to understand how
the whole thing is supposed to work but this looks like it could
devolve into something more broken than the freezer which we haven't
fully recovered from yet.

Thanks.

-- 
tejun
