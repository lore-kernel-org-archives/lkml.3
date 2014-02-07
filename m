Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBGEjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:39:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39951 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaBGEjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:39:36 -0500
Date: Thu, 06 Feb 2014 20:39:35 -0800 (PST)
Message-Id: <20140206.203935.23931642792292899.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, ursula.braun@de.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 51/51] net/iucv/iucv.c: Fix CPU hotplug callback
 registration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140205221354.19080.25861.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	<20140205221354.19080.25861.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:43:55 +0530

> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
 ...
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
> 
> Instead, the correct and race-free way of performing the callback
> registration is:
 ...
> Fix the code in net/iucv/iucv.c by using this latter form of callback
> registration. Also, provide helper functions to perform the common memory
> allocations and frees, to condense repetitive code.
> 
> Cc: Ursula Braun <ursula.braun@de.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied.
