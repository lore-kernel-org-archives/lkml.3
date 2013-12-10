Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3LJPYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:24:55 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:48758 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab3LJPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:24:54 -0500
Date: Tue, 10 Dec 2013 15:24:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: rcu: Avoid irq disable in rcu_cpu_kthread
In-Reply-To: <20131210000521.GH4208@linux.vnet.ibm.com>
Message-ID: <00000142dd1c5d5c-e95b9eb8-e27a-4de7-b301-becee6402c4e-000000@email.amazonses.com>
References: <00000142c495b75b-c1878909-baf9-42a8-9ba7-62d216d806a7-000000@email.amazonses.com> <20131210000521.GH4208@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Paul E. McKenney wrote:

> On Thu, Dec 05, 2013 at 09:06:55PM +0000, Christoph Lameter wrote:
> > Once we have the per cpu patchset merged we could do the following [it
> > even works without that patchset but the __this_cpu ops will not do
> > preemption checks]. Would this work?
>
> Looks plausible at first glance.  But are you really seeing performance
> issues with this code?  It is only compiled into the kernel when you build
> with CONFIG_RCU_BOOST=y -- are you actually using that for your workloads?

I have not done any benchmarking. Just looking for more use cases for the
this_cpu ops. There is a lot of use of per cpu operations in the rcu code
which seems to be areas in which these operations can help.

