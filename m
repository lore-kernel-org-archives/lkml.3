Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3FYDPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:15:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:42074 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3FYDPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:15:07 -0400
Message-ID: <1372130007.3944.185.camel@pasglop>
Subject: Re: [PATCH 40/45] powerpc, irq: Use GFP_ATOMIC allocations in
 atomic context
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ian Munsie <imunsie@au1.ibm.com>
Date: Tue, 25 Jun 2013 13:13:27 +1000
In-Reply-To: <20130625025858.GE14051@concordia>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
	 <20130623134657.19094.93687.stgit@srivatsabhat.in.ibm.com>
	 <20130625020842.GD14051@concordia> <1372126384.3944.177.camel@pasglop>
	 <20130625025858.GE14051@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 12:58 +1000, Michael Ellerman wrote:
> On Tue, Jun 25, 2013 at 12:13:04PM +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2013-06-25 at 12:08 +1000, Michael Ellerman wrote:
> > > We're not checking for allocation failure, which we should be.
> > > 
> > > But this code is only used on powermac and 85xx, so it should probably
> > > just be a TODO to fix this up to handle the failure.
> > 
> > And what can we do if they fail ?
> 
> Fail up the chain and not unplug the CPU presumably.

BTW. Isn't Srivatsa series removing the need to stop_machine() for
unplug ? That should mean we should be able to use GFP_KERNEL no ?

Cheers,
Ben.


