Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaAWTMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:12:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42802 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbaAWTL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:11:58 -0500
Date: Thu, 23 Jan 2014 20:11:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
Message-ID: <20140123191140.GV11314@laptop.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 07:51:40PM +0100, Jan Kiszka wrote:
> Next we have x86's arch_irq_work_raise which does wait-write-wait,
> either by chance or in order to work around a missing atomicity of
> wait+write somewhere else. Preemption is off, interrupts remain on.

Note that arch_irq_work_raise() is 'special' in that its used from NMI
context, so no amount of interrupts disabling will serialize things.
