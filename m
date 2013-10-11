Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3JKMO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:14:59 -0400
Received: from science.horizon.com ([71.41.210.146]:59526 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751225Ab3JKMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:14:58 -0400
Date: 11 Oct 2013 08:14:57 -0400
Message-ID: <20131011121457.25042.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: rostedt@goodmis.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's places in the kernel that does for_each_cpu() that I'm sure you
> don't want to disable preemption for. Especially when you start having
> 4096 CPU machines!

Er... why not?

Seriously.  If I have 4096 processors, and preemption is disabled on
*one* of them for a long time, can't an urgent task just find a different
processor to preempt?

This seems like a non-problem.  Or am I misunderstanding something about
processor affinity?
