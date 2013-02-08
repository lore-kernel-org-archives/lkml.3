Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3BHFLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:11:16 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59300 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3BHFLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130208050342.GA23362@linux.vnet.ibm.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-2-git-send-email-walken@google.com>
	<20130207223434.GG2545@linux.vnet.ibm.com>
	<1360277809.28557.60.camel@edumazet-glaptop>
	<CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
	<1360281834.28557.73.camel@edumazet-glaptop>
	<20130208004023.GM2545@linux.vnet.ibm.com>
	<CANN689EUBav=9LkC0s4+teQirGhymgvRxaHRcnK7brjwDU28FQ@mail.gmail.com>
	<20130208043643.GN2545@linux.vnet.ibm.com>
	<20130208050342.GA23362@linux.vnet.ibm.com>
Date: Thu, 7 Feb 2013 21:11:14 -0800
Message-ID: <CANN689EMOxriEvsyp=kiA95b3m1gg4fYc0oyMnTtjC1+zunQ7w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Michel Lespinasse <walken@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 9:03 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Right...  For spinlocks that -don't- disable irqs, you need to deal with
> the possibility that a CPU gets interrupted while spinning, and the
> interrupt handler also tries to acquire a queued lock.  One way to deal
> with this is to have a node per CPUxirq.  Of course, if interrupts
> handlers always disable irqs when acquiring a spinlock, then you only
> need CPUx2.

The simple solution would be to do like I proposed in my faster queue
spinlock proposal, have one function for process context lock
acquisitions, another for bh-disabled acquisitions, and just say that
hardirqs can't use the queue spinlocks (I don't expect we have any
locks taken from hardirq context where contention might be an issue ?)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
