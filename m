Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaETKZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:25:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:33144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:25:51 -0400
Date: Tue, 20 May 2014 12:25:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 UPDATEDv3 3/3] CPU hotplug, smp: Flush any pending IPI
 callbacks before CPU offline
Message-ID: <20140520102542.GW2485@laptop.programming.kicks-ass.net>
References: <20140515191938.GB21306@htj.dyndns.org>
 <537514D3.4060308@linux.vnet.ibm.com>
 <20140515193656.GM4570@linux.vnet.ibm.com>
 <537518D6.6030006@linux.vnet.ibm.com>
 <5379F6BD.1090809@linux.vnet.ibm.com>
 <20140519161836.GA30387@redhat.com>
 <537A6060.7070406@linux.vnet.ibm.com>
 <537A6811.50808@linux.vnet.ibm.com>
 <20140520094203.GU2485@laptop.programming.kicks-ass.net>
 <537B29F7.6060104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B29F7.6060104@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:39:59PM +0530, Srivatsa S. Bhat wrote:
> > The multi_cpu_stop() path isn't exclusive to hotplug, so your changelog
> > is wrong or the patch is.
> > 
> 
> Yes, I know that multi_cpu_stop() isn't exclusive to hotplug. That's why
> I have explicitly referred to CPU hotplug in the comment as well as the
> changelog.
> 
> But I totally agree that code-wise this is not the best way to do it since
> this affects (although harmlessly) usecases other than hotplug as well.
> 
> Do you have any other suggestions?

How about making a kernel/smp.c hotplug notifier and stuffing it in the
CPU_DYING list? That's typically after we've already torn down the
interrupts for that cpu, so no chance of any new ones coming in.

Or is that too late?
