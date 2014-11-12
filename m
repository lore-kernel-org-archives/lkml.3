Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaKLUnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:43:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaKLUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:43:50 -0500
Date: Wed, 12 Nov 2014 15:43:41 -0500 (EST)
Message-Id: <20141112.154341.1705628294274955796.davem@davemloft.net>
To: alexander.h.duyck@redhat.com
Cc: will.deacon@arm.com, alexander.duyck@gmail.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikey@neuling.org, tony.luck@intel.com,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, oleg@redhat.com,
        michael@ellerman.id.au, geert@linux-m68k.org, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, linux@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        mingo@kernel.org
Subject: Re: [PATCH] arch: Introduce read_acquire()
From: David Miller <davem@davemloft.net>
In-Reply-To: <54627BC0.4020705@redhat.com>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
	<20141111194734.GL16265@arm.com>
	<54627BC0.4020705@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 12:43:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@redhat.com>
Date: Tue, 11 Nov 2014 13:12:32 -0800

> The architectures I need to sort out are arm, x86, sparc, ia64, and
> s390 as they are the only ones that tried to make use of the
> smp_load_acquire logic.

On sparc64, you don't have to worry about anything really.

Only mb() does anything.  The cpus execute in a reasonably strict
memory ordering mode, and that's why rmb/wmb and friends are simply
nops with a compiler barrier.
