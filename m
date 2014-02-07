Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaBGFTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:19:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGFTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:19:52 -0500
Date: Thu, 06 Feb 2014 21:19:50 -0800 (PST)
Message-Id: <20140206.211950.143290861607860665.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, roy.qing.li@gmail.com,
        sasha.levin@oracle.com, cmetcalf@tilera.com, netdev@vger.kernel.org
Subject: Re: [PATCH 50/51] net/core/flow.c: Fix CPU hotplug callback
 registration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140206.203921.888218847049631688.davem@davemloft.net>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	<20140205221345.19080.20784.stgit@srivatsabhat.in.ibm.com>
	<20140206.203921.888218847049631688.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 06 Feb 2014 20:39:21 -0800 (PST)

> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Thu, 06 Feb 2014 03:43:46 +0530
> 
>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>> initialization for the CPUs that are already online, often do it as shown
>> below:
>  ...
>> This is wrong, since it is prone to ABBA deadlocks involving the
>> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
>> with CPU hotplug operations).
>> 
>> Instead, the correct and race-free way of performing the callback
>> registration is:
>  ...
>> Fix the code in net/core/flow.c by using this latter form of callback
>> registration.
>> 
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Li RongQing <roy.qing.li@gmail.com>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Applied.

I just realized that this has a dependency not in the 'net'
tree, so I reverted and assume you will merge this with the
patch that provides the necessary interface(s).

Signed-off-by: David S. Miller <davem@davemloft.net>
