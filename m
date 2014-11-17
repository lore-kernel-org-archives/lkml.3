Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaKQUYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:24:13 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54020 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:24:11 -0500
Message-ID: <546A5968.1090201@gmail.com>
Date: Mon, 17 Nov 2014 12:24:08 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>
CC: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        peterz@infradead.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Subject: Re: [PATCH 2/4] arch: Add lightweight memory barriers fast_rmb()
 and fast_wmb()
References: <20141117171005.22333.96544.stgit@ahduyck-server>	 <20141117171812.22333.90395.stgit@ahduyck-server> <1416254687.18381.3.camel@kernel.crashing.org>
In-Reply-To: <1416254687.18381.3.camel@kernel.crashing.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 12:04 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-11-17 at 09:18 -0800, Alexander Duyck wrote:
>> There are a number of situations where the mandatory barriers rmb() and
>> wmb() are used to order memory/memory operations in the device drivers
>> and those barriers are much heavier than they actually need to be.  For
>> example in the case of PowerPC wmb() calls the heavy-weight sync
>> instruction when for memory/memory operations all that is really needed is
>> an lsync or eieio instruction.
> So essentially those are the same as the smp_* variants but not nop'ed
> out on !CONFIG_SMP right ? 
>
> Ben.
>

Yes and no.  So for example on ARM I used the dmb() operation, however I
have to use the barrier at the system level instead of just the inner
shared domain.  However on many other architectures they are just the
same as the smp_* variants.

Basically the resultant code is somewhere between the smp and non-smp
barriers in terms of what they cover.

Thanks,

Alex
