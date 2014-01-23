Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaAWTXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:23:05 -0500
Received: from one.firstfloor.org ([193.170.194.197]:41592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaAWTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:23:03 -0500
Date: Thu, 23 Jan 2014 20:22:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
Message-ID: <20140123192255.GB20765@two.firstfloor.org>
References: <52DE6FCE.2050708@siemens.com>
 <20140121140113.GL30183@twins.programming.kicks-ass.net>
 <20140121145105.GE3694@twins.programming.kicks-ass.net>
 <1390346420.23634.5.camel@yhuang-dev>
 <20140122184325.GY20765@two.firstfloor.org>
 <52E164BC.1080302@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E164BC.1080302@siemens.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So now I'm looking for consistent locking rules (which type of lock, who
> is responsible when issuing IPIs?) and a good (ie. also efficient) way
> to apply them.

It has to be lockless, the machine checks run as NMIs.
The whole point of the self nmi is to get back to a lockable state.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
