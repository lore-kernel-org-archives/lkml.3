Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaKRAnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:43:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:55028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaKRAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:43:12 -0500
Message-ID: <1416271305.18381.19.camel@kernel.crashing.org>
Subject: Re: [PATCH 2/4] arch: Add lightweight memory barriers fast_rmb()
 and fast_wmb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        donald.c.skidmore@intel.com, matthew.vick@intel.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, nic_swsd@realtek.com,
        Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Tony Luck <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>
Date: Tue, 18 Nov 2014 11:41:45 +1100
In-Reply-To: <CA+55aFxZ9dhB074p3OAQLyQ53TuRjVOo33h6OOda1soh-9xxnQ@mail.gmail.com>
References: <20141117171005.22333.96544.stgit@ahduyck-server>
	 <20141117171812.22333.90395.stgit@ahduyck-server>
	 <CA+55aFxZ9dhB074p3OAQLyQ53TuRjVOo33h6OOda1soh-9xxnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 12:52 -0800, Linus Torvalds wrote:

> Maybe "dma_*mb()" would be acceptable, and ends up having the same
> naming convention as "smb_*mb()", and explains what it's about.

Yes, that was what I was about to suggest as well.

> And yes, in the same spirit, it would probably be good to try to
> eventually get rid of the plain "*mb()" functions, and perhaps call
> them "mmio_*mb()" to clarify that they are about ordering memory wrt
> mmio.

It will always be somewhat unclear to users who don't read the doc
anyway :)

IE. the dma_* ones do only DMA vs DMA (or vs other processors) but the 
mmio_* one do anything vs anything. Not a huge deal tho. I still like
dma_* for Alexander's new stuff but I wouldn't bother with changing the
existing ones.

Ben.


