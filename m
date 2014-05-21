Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaEUWmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:42:18 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:19618 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaEUWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:42:17 -0400
Message-ID: <1400712127.2770.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH] mutex: Documentation rewrite
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, hpa@zytor.com, waiman.long@hp.com,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 15:42:07 -0700
In-Reply-To: <1400707009.4661.23.camel@j-VirtualBox>
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
	 <1400707009.4661.23.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 14:16 -0700, Jason Low wrote:
> On Wed, 2014-05-21 at 10:41 -0700, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> 
> > +     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
> > +     with the desirable properties of being fair and with each cpu trying
> > +     to acquire the lock spinning on a local variable. It avoids expensive
> > +     cacheline bouncing that common test-and-set spinlock implementations
> > +     incur. An MCS-like lock is specially tailored for optimistic spinning
> > +     for sleeping lock implementation.
> 
> Would it be helpful to also briefly mention the benefit of using the
> specially tailored MCS lock? Maybe something along the lines of: an
> important feature of the customized MCS lock is that it has the extra
> property that spinners are able to exit the MCS spinlock queue when they
> needs to reschedule. This further helps avoid situations where MCS
> spinners that need to reschedule would continue waiting to spin on mutex
> owner, only to go directly to slowpath upon obtaining the MCS lock.

Good idea, will add it. I didn't want to go into too much details about
MCS locks but it is worth mentioning the cancelable properties we now
have in the kernel.

Thanks,
Davidlohr


