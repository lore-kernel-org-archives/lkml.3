Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaKRBnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:43:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:40464 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaKRBnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:43:12 -0500
Message-ID: <1416271167.18381.16.camel@kernel.crashing.org>
Subject: Re: [PATCH 2/4] arch: Add lightweight memory barriers fast_rmb()
 and fast_wmb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        heiko.carstens@de.ibm.com, mingo@kernel.org, mikey@neuling.org,
        linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Tue, 18 Nov 2014 11:39:27 +1100
In-Reply-To: <546A5968.1090201@gmail.com>
References: <20141117171005.22333.96544.stgit@ahduyck-server>
	 <20141117171812.22333.90395.stgit@ahduyck-server>
	 <1416254687.18381.3.camel@kernel.crashing.org> <546A5968.1090201@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 12:24 -0800, Alexander Duyck wrote:
> Yes and no.  So for example on ARM I used the dmb() operation, however
> I
> have to use the barrier at the system level instead of just the inner
> shared domain.  However on many other architectures they are just the
> same as the smp_* variants.
> 
> Basically the resultant code is somewhere between the smp and non-smp
> barriers in terms of what they cover.

There I don't quite follow you. You need to explain better especially in
the documentation because otherwise people will get it wrong...

If it's ordering in the coherent domain, I fail to see how a DMA agent
is different than another processor when it comes to barriers, so I fail
to see the difference with smp_*

I understand the MMIO vs. memory issue, we do have the same on powerpc,
but that other aspect eludes me.

Ben.


