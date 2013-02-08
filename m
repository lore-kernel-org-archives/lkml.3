Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3BHAD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:03:58 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:54784 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3BHAD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:03:57 -0500
Message-ID: <1360281834.28557.73.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: paulmck@linux.vnet.ibm.com, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Date: Thu, 07 Feb 2013 16:03:54 -0800
In-Reply-To: <CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	 <1358896415-28569-2-git-send-email-walken@google.com>
	 <20130207223434.GG2545@linux.vnet.ibm.com>
	 <1360277809.28557.60.camel@edumazet-glaptop>
	 <CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 15:58 -0800, Michel Lespinasse wrote:

> No, I think that's doable. The trick would be that once a thread
> acquires the lock, the only remaining use of the node is to receive
> the 'next' pointer if/when another thread starts contending for the
> lock. So if the lock state would need to distinguish between a lock
> that is currently locked but not contended (the next value would then
> be NULL), and a lock that is currently locked and contended (the
> lock->next value is the node that goes after the current lock owner)
> 

It adds yet another memory write to store the node pointer in the
lock...

I suspect it's going to increase false sharing.


