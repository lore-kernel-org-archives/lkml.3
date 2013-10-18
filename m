Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3JRQ6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:58:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46055 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688Ab3JRQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:57:59 -0400
Date: Fri, 18 Oct 2013 17:57:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
Message-ID: <20131018165749.GI3296@mudshark.cambridge.arm.com>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
 <20131018111536.GA11132@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018111536.GA11132@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pablo,

On Fri, Oct 18, 2013 at 12:15:36PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2013 at 02:24:33PM +0100, Will Deacon wrote:
> > During kernel stability testing on an SMP ARMv7 system, Yalin Wang
> > reported the following panic from the netfilter code:

[...]

> > This patch adds an smp_wmb() before the assignment to table->private
> > (which is essentially publishing newinfo) to ensure that all writes to
> > newinfo will be observed before plugging it into the table structure.
> > A dependent-read barrier is also added on the consumer side, to ensure
> > the same ordering requirement are also respected there.
> 
> We also need fixes for net/ipv6/netfilter/ip6_tables.c and
> net/ipv4/netfilter/arp_tables.c as well. Could you extend this patch
> and resend?

Sure, I can try, but that's going to require a bit of time to sit down and
look at the shared data, access order, dependencies etc. I'm currently
preparing for Edinburgh, so it might be a while before I get a chance to
extend this.

Will
