Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3FEHPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:15:44 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42813 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3FEHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:15:43 -0400
Date: Wed, 5 Jun 2013 00:15:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ben Greear <greearb@candelatech.com>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
Message-ID: <20130605071539.GA3429@mtj.dyndns.org>
References: <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com>
 <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com>
 <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com>
 <51ACBD6A.1030304@candelatech.com>
 <51ACC60B.8090504@candelatech.com>
 <87d2s2to4z.fsf@rustcorp.com.au>
 <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
 <51AE1B81.20900@candelatech.com>
 <51AE27D5.7050202@candelatech.com>
 <87sj0xry1k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj0xry1k.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 05, 2013 at 01:47:43PM +0930, Rusty Russell wrote:
> > I have some printk debugging in (see bottom of email) and was using a serial console, so things
> > were probably running a bit slower than on most systems.  Here is trace
> > from my kernel with local patches and not so much debugging enabled
> > (this is NOT a clean upstream kernel, though I reproduced the same thing
> > with a clean upstream 3.9.4 kernel plus your module unlink patch yesterday).
> 
> Tejun CC'd.  We can't be running two stop machines in parallel, since
> there's a mutex (and there's also one in the module code).
>
> > __stop_machine, num-threads: 4, fn: __try_stop_module  data: ffff8801c6ae7f28
> > cpu: 0 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
> > cpu: 1 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
> > cpu: 2 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 3
> > cpu: 3 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 2
> > __stop_machine, num-threads: 4, fn: __unlink_module  data: ffffffffa0aeeab0
> > cpu: 0 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
> > cpu: 1 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
> > cpu: 3 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 3
> > ath: wiphy0: Failed to stop TX DMA, queues=0x005!
> > cpu: 2 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 2

A bit confused.  I looked at the code again and it still seems
properly interlocked.  Can't see how the above scenario could happen.
Actually, I'm not even sure, what I'm looking at.  Is the above from
the lockup?  It'd be helpful if we can get more traces from the locked
up state.  Shouldn't be hard to detect.  Dumb timeout based detection
should work fine.  How easily can you reproduce the issue?

Thanks.

-- 
tejun
