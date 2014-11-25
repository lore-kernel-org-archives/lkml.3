Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaKYXRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:17:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:55823 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaKYXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:17:30 -0500
Message-ID: <1416957328.5089.17.camel@kernel.crashing.org>
Subject: Re: [PATCH v5 2/4] arch: Add lightweight memory barriers dma_rmb()
 and dma_wmb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        peterz@infradead.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Wed, 26 Nov 2014 10:15:28 +1100
In-Reply-To: <20141119012400.9563.21117.stgit@ahduyck-server>
References: <20141119012205.9563.95544.stgit@ahduyck-server>
	 <20141119012400.9563.21117.stgit@ahduyck-server>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 17:24 -0800, Alexander Duyck wrote:
> There are a number of situations where the mandatory barriers rmb() and
> wmb() are used to order memory/memory operations in the device drivers
> and those barriers are much heavier than they actually need to be.  For
> example in the case of PowerPC wmb() calls the heavy-weight sync
> instruction when for coherent memory operations all that is really needed
> is an lsync or eieio instruction.
>  .../...

For powerpc:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>



