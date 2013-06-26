Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FZPds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:33:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3FZPdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:33:46 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=k2iftdwf7gsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lolsShB3EWcA:10 a=kAh2p6pyvV7biOKB-DgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372260823.18733.263.camel@gandalf.local.home>
Subject: Re: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to
 prevent CPU offline
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, David Laight <David.Laight@ACULAB.COM>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        walken@google.com, mingo@kernel.org, linux-arch@vger.kernel.org,
        vincent.guittot@linaro.org, xiaoguangrong@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, namhyung@kernel.org,
        tglx@linutronix.de, laijs@cn.fujitsu.com, zhong@linux.vnet.ibm.com,
        netdev@vger.kernel.org, oleg@redhat.com, sbw@mit.edu,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 26 Jun 2013 11:33:43 -0400
In-Reply-To: <20130626152148.GA4405@mtj.dyndns.org>
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com>
	 <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com>
	 <20130625220026.GG3828@linux.vnet.ibm.com>
	 <51CAF624.6060004@linux.vnet.ibm.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
	 <20130626143424.GN3828@linux.vnet.ibm.com>
	 <1372258271.18733.256.camel@gandalf.local.home>
	 <20130626152148.GA4405@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 08:21 -0700, Tejun Heo wrote:
> On Wed, Jun 26, 2013 at 10:51:11AM -0400, Steven Rostedt wrote:
> > > It would also increase the latency of CPU-hotunplug operations.
> > 
> > Is that a big deal?
> 
> I thought that was the whole deal with this patchset - making cpu
> hotunplugs lighter and faster mostly for powersaving.  That said, just
> removing stop_machine call would be a pretty good deal and I don't
> know how meaningful reducing CPU hotunplug latency is.  Srivatsa?

I thought the whole deal with this patchset was to remove stop_machine
from CPU hotplug. Why halt all CPUs just to remove one? stomp_machine()
is extremely intrusive for the entire system, where as one CPU making
sure all CPUs schedule isn't very intrusive at all.

I didn't think the idea of this patch set was to make CPU hotplug
faster, just less intrusive to the system.

-- Steve


