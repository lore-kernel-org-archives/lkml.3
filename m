Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3FZOan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:30:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43562 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751832Ab3FZOal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:30:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent CPU offline
Date: Wed, 26 Jun 2013 15:29:40 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
In-Reply-To: <51CAF624.6060004@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent CPU offline
thread-index: Ac5yd1sZRxulqDseRqegfBpszp6dHAAASeEQ
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com> <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com> <20130625220026.GG3828@linux.vnet.ibm.com> <51CAF624.6060004@linux.vnet.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <paulmck@linux.vnet.ibm.com>
Cc: <peterz@infradead.org>, <fweisbec@gmail.com>,
        <linux-kernel@vger.kernel.org>, <walken@google.com>,
        <mingo@kernel.org>, <linux-arch@vger.kernel.org>,
        <vincent.guittot@linaro.org>, <xiaoguangrong@linux.vnet.ibm.com>,
        <wangyun@linux.vnet.ibm.com>, <nikunj@linux.vnet.ibm.com>,
        <linux-pm@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <rostedt@goodmis.org>, <namhyung@kernel.org>, <tglx@linutronix.de>,
        <laijs@cn.fujitsu.com>, <zhong@linux.vnet.ibm.com>,
        <netdev@vger.kernel.org>, <oleg@redhat.com>, <sbw@mit.edu>,
        <tj@kernel.org>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Once stop_machine() is gone from the CPU offline path, we won't be able
> to depend on disabling preemption to prevent CPUs from going offline
> from under us.

Could you use an rcu-like sequence so that disabling pre-emption
would be enough?

Something like rebuilding the cpu list, then forcing yourself
to run on all the cpu.

That would be far less intrusive.

	David



