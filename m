Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaCGDAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:00:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:56467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbaCGC7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:59:33 -0500
Message-ID: <1394161051.26321.71.camel@pasglop>
Subject: Re: [PATCH v2 14/52] powerpc, sysfs: Fix CPU hotplug callback
 registration
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        linuxppc-dev@lists.ozlabs.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2014 13:57:31 +1100
In-Reply-To: <20140214075215.22701.23653.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
	 <20140214075215.22701.23653.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 13:22 +0530, Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	put_online_cpus();

This patch breaks a good half of my test configs with:

/home/benh/linux-powerpc-test/arch/powerpc/kernel/sysfs.c: In function 'topology_init':
/home/benh/linux-powerpc-test/arch/powerpc/kernel/sysfs.c:979:2: error: implicit declaration of function 'cpu_notifier_register_begin' [-Werror=implicit-function-declaration]
/home/benh/linux-powerpc-test/arch/powerpc/kernel/sysfs.c:1004:2: error: implicit declaration of function '__register_cpu_notifier' [-Werror=implicit-function-declaration]
/home/benh/linux-powerpc-test/arch/powerpc/kernel/sysfs.c:1006:2: error: implicit declaration of function 'cpu_notifier_register_done' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/kernel/sysfs.o] Error 1
make[2]: *** Waiting for unfinished jobs....



