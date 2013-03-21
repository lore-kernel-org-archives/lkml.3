Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3CUSo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:44:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3CUSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:44:26 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=g1up7QdnZ3oA:10 a=355AVLq4GGmKcRNXP6MA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363891462.6345.52.camel@gandalf.local.home>
Subject: Re: [PATCH] nohz1: Documentation
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Date: Thu, 21 Mar 2013 14:44:22 -0400
In-Reply-To: <20130321171518.GW3637@linux.vnet.ibm.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	 <1363636794.15703.32@driftwood>
	 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	 <20130318222548.GG3656@linux.vnet.ibm.com>
	 <1363822338.6345.33.camel@gandalf.local.home>
	 <20130320235545.GL3637@linux.vnet.ibm.com>
	 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	 <20130321171518.GW3637@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 10:15 -0700, Paul E. McKenney wrote:

> > The OS always has some sched other tasks around that become runnable after
> > a while (like for example the vm statistics update, or the notorious slab
> > scanning). As long as SCHED_FIFO is active and there is no process in the
> > same scheduling class then tick needs to be off. Also wish that this would
> > work with SCHED_OTHER if there is only a single task with a certain renice
> > value (-10?) and the rest is runnable at lower priorities. Maybe in that
> > case stop the tick for a longer period and then give the lower priority
> > tasks a chance to run but then switch off the tick again.
> 
> These sound to me like good future enhancements.

Exactly. Please, this is a complex enough change to something that is
critical to the entire system (similar to RCU itself). Lets take baby
steps here and get it right each step of the way.

For now, no, if more than one process is scheduled on the CPU, we fall
out of dynamic tick mode. In the future, we can add SCHED_FIFO task
scheduled in to trigger it. But lets conquer that after we successfully
conquer the current changes.

-- Steve


