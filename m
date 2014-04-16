Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161652AbaDPPII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:08:08 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:41489 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161466AbaDPPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:08:06 -0400
Date: Wed, 16 Apr 2014 10:08:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
In-Reply-To: <20140415221755.GA27188@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
References: <20140415221755.GA27188@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Paul E. McKenney wrote:

> Hello, Christoph,
>
> I have a patch that currently uses __this_cpu_inc_return() to increment a
> per-CPU variable, but without preemption disabled.  Of course, given that
> preemption is enabled, it might well end up picking up one CPU's counter,
> adding one to it, then storing the result into some other CPU's counter.
> But this is OK, the test can be probabilistic.  And when I run this
> against v3.14 and earlier, it works fine.

We introduced raw_cpu_inc_return to squish these warnings.

> This is arguably better than the original __this_cpu_read() because it
> avoids overflow, but I thought I should check to see if there was some
> better way to do this.

If this is supposed to be totally race safe then you must disable
preemption.

