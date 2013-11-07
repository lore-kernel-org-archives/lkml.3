Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3KGXbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:31:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37275 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753899Ab3KGXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:31:44 -0500
Date: Thu, 7 Nov 2013 18:31:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed
 on any cpu
Message-ID: <20131107183142.4ae4345e@gandalf.local.home>
In-Reply-To: <20131107230111.GF2054@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-3-git-send-email-jack@suse.cz>
	<CAFTL4hxLXb3hZacx_EdHeKZVfrpuyGoNqpGbX997XJx0UJSwyg@mail.gmail.com>
	<20131107221904.GB2054@quack.suse.cz>
	<20131107222311.GA28130@localhost.localdomain>
	<20131107225034.GD2054@quack.suse.cz>
	<20131107225408.GD28130@localhost.localdomain>
	<20131107230111.GF2054@quack.suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013 00:01:11 +0100
Jan Kara <jack@suse.cz> wrote:

> On Thu 07-11-13 23:54:10, Frederic Weisbecker wrote:

> > So if the current CPU can handle it, what is the problem?
>   I hope this gets cleared out in my other email. But to make sure: If
> other CPUs are idle (i.e. not appending to the printk buffer), we can well
> handle the printing on the current CPU (with some breaks to allow
> interrupts to be served etc.). If other CPUs are also appending to printk
> buffer, that's where we really want to push the work to other CPUs.

I guess the question is, how does it migrate? I guess that's not so
clear. Or do you just hope that the timer tick on another CPU will come
in first and finish the job for you? As the list is global and all CPUs
get to see it.

-- Steve
