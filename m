Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaAWTwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:52:06 -0500
Received: from thoth.sbs.de ([192.35.17.2]:42001 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaAWTwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:52:03 -0500
Message-ID: <52E172B3.7080605@siemens.com>
Date: Thu, 23 Jan 2014 20:51:15 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Huang Ying <ying.huang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
References: <52DE6FCE.2050708@siemens.com> <20140121140113.GL30183@twins.programming.kicks-ass.net> <20140121145105.GE3694@twins.programming.kicks-ass.net> <1390346420.23634.5.camel@yhuang-dev> <20140122184325.GY20765@two.firstfloor.org> <52E164BC.1080302@siemens.com> <20140123192255.GB20765@two.firstfloor.org>
In-Reply-To: <20140123192255.GB20765@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-23 20:22, Andi Kleen wrote:
>> So now I'm looking for consistent locking rules (which type of lock, who
>> is responsible when issuing IPIs?) and a good (ie. also efficient) way
>> to apply them.
> 
> It has to be lockless, the machine checks run as NMIs.
> The whole point of the self nmi is to get back to a lockable state.

"It" is arch_irq_work_raise, or more?

arch_irq_work_raise looks consistent then, and we now know why there is
the trailing wait.

Remains the question if shorthand IPIs are always locked by their
callers. Some do (those in kernel/apic/io_apic.c e.g.), other seem to be
more relaxed with this (e.g. kernel/apic/hw_nmi.c or
native_send_call_func_single_ipi), unless I miss something again.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
