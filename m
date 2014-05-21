Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaEUVQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:16:53 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:14730 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaEUVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:16:52 -0400
Message-ID: <1400707009.4661.23.camel@j-VirtualBox>
Subject: Re: [RFC PATCH] mutex: Documentation rewrite
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, hpa@zytor.com, waiman.long@hp.com,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 14:16:49 -0700
In-Reply-To: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 10:41 -0700, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>

> +     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
> +     with the desirable properties of being fair and with each cpu trying
> +     to acquire the lock spinning on a local variable. It avoids expensive
> +     cacheline bouncing that common test-and-set spinlock implementations
> +     incur. An MCS-like lock is specially tailored for optimistic spinning
> +     for sleeping lock implementation.

Would it be helpful to also briefly mention the benefit of using the
specially tailored MCS lock? Maybe something along the lines of: an
important feature of the customized MCS lock is that it has the extra
property that spinners are able to exit the MCS spinlock queue when they
needs to reschedule. This further helps avoid situations where MCS
spinners that need to reschedule would continue waiting to spin on mutex
owner, only to go directly to slowpath upon obtaining the MCS lock.


