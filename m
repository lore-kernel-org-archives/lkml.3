Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaENHnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:43:11 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:48047 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaENHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:43:08 -0400
Date: Wed, 14 May 2014 09:43:00 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140514074300.GA17409@samfundet.no>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
 <20140509183241.GA4491@samfundet.no>
 <20140509204309.GA13467@laptop.programming.kicks-ass.net>
 <20140509205155.GH1429@laptop.programming.kicks-ass.net>
 <20140509211728.GI1429@laptop.programming.kicks-ass.net>
 <20140513204032.GB14023@samfundet.no>
 <20140513205045.GK2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513205045.GK2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 13 May 2014 22:50:45 +0200 or thereabout, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 10:40:32PM +0200, Hans-Christian Egtvedt wrote:
>> Probably found the reason why we want to use sub with the signed 21-bit
>> limit, it uses one less register than the add instruction that can add up to
>> 32-bit values.
>> 
>> Both instructions are 32-bit, to use a 16-bit instruction the immediate is
>> very small; 4 bit.
>> 
>> sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
>> add 32-bit, type II, adds two register values together.
>> 
>> So by simplifying you loose this optimization.
> 
> OK, let me try if I can come up with anything sane for this.
> 
> Re, adding atomic_{or,and,xor}() those should all use the same bits as
> add, right, except for the special case using sub.

OR and XOR (EOR in the manual) instruction will fall into type II or III,
both 32-bit, and (x)ors two registers together, difference is which way they
can do a shift on one of the registers.

So yes, identical as add.

-- 
Hans-Christian Egtvedt
