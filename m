Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161438AbaKNQ54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:57:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:23683 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161318AbaKNQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:57:53 -0500
Date: Fri, 14 Nov 2014 11:57:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Elder <elder@linaro.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Jan Kara <jack@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile
 type
Message-ID: <20141114115749.1514ec0a@gandalf.local.home>
In-Reply-To: <54663046.7050800@linaro.org>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
	<546589A1.9040100@linaro.org>
	<20141113235722.7457f9c7@gandalf.local.home>
	<20141114002436.535a16a9@gandalf.local.home>
	<54663046.7050800@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 10:39:34 -0600
Alex Elder <elder@linaro.org> wrote:
 
> There is only one read of logbuf_cpu:
>         if (unlikely(logbuf_cpu == this_cpu)) {
> This is called only while local interrupts are disabled, so
> if this condition holds it cannot be due to an interrupt--it

Unless an NMI called printk.

> must be due to simple recursion into printk() while inside
> the spinlock-protected critical section.


> QED.  (Well, please correct me where I'm wrong...)
> 

Except for the NMI case, I believe you are correct with the rest of
your analysis.

-- Steve
