Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaBGPyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:54:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:57780 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaBGPyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:54:35 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20140207090248.GB26811@lst.de>
Date: Fri, 7 Feb 2014 09:51:16 -0600
Cc: Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <87C29DBB-41E7-4B6C-9089-3C7756FBAE07@kernel.crashing.org>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <1391717992.6733.232.camel@snotra.buserror.net> <20140207090248.GB26811@lst.de>
To: Torsten Duwe <duwe@lst.de>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7, 2014, at 3:02 AM, Torsten Duwe <duwe@lst.de> wrote:

> On Thu, Feb 06, 2014 at 02:19:52PM -0600, Scott Wood wrote:
>> On Thu, 2014-02-06 at 18:37 +0100, Torsten Duwe wrote:
>>> On Thu, Feb 06, 2014 at 05:38:37PM +0100, Peter Zijlstra wrote:
>> 
>>>> Can you pair lwarx with sthcx ? I couldn't immediately find the answer
>>>> in the PowerISA doc. If so I think you can do better by being able to
>>>> atomically load both tickets but only storing the head without affecting
>>>> the tail.
> 
> Can I simply write the half word, without a reservation, or will the HW caches
> mess up the other half? Will it ruin the cache coherency on some (sub)architectures?

The coherency should be fine, I just can’t remember if you’ll lose the reservation by doing this.

>> Plus, sthcx doesn't exist on all PPC chips.
> 
> Which ones are lacking it? Do all have at least a simple 16-bit store?

Everything implements a simple 16-bit store, just not everything implements the store conditional of 16-bit data.

- k