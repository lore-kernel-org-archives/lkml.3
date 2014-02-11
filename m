Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaBKKkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:40:42 -0500
Received: from verein.lst.de ([213.95.11.211]:51815 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaBKKkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:40:35 -0500
Date: Tue, 11 Feb 2014 11:40:30 +0100
From: Torsten Duwe <duwe@lst.de>
To: Raghavendra KT <raghavendra.kt.linux@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] powerpc ticket locks
Message-ID: <20140211104030.GG2107@lst.de>
References: <20140207165801.GC2107@lst.de> <1392001823.3996.21.camel@pasglop> <CAC4Lta2Pssu5QY_QLmy5C3Fm2G3fwpiuc5BNOLBnQTmmRH+W4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC4Lta2Pssu5QY_QLmy5C3Fm2G3fwpiuc5BNOLBnQTmmRH+W4Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:23:51PM +0530, Raghavendra KT wrote:
> How much important to have holder information for PPC? From my
> previous experiment
> on x86, it was lock-waiter preemption which is problematic rather than
> lock-holder preemption.

It's something very special to IBM pSeries: the hypervisor can assign
fractions of physical CPUs to guests. Sometimes a guest with 4 quarter
CPUs will be faster than 1 monoprocessor. (correct me if I'm wrong).

The directed yield resolves the silly situation when holder and waiter
reside on the same physical CPU, as I understand it.

x86 has nothing comparable.

	Torsten

