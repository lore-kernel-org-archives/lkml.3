Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaDVLyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:54:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:46879 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDVLyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:49 -0400
Date: Tue, 22 Apr 2014 13:54:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140422115439.GA20669@linutronix.de>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <534DADF1.6060608@meduna.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stanislav Meduna | 2014-04-16 00:08:49 [+0200]:

>Hmm... how is it in the rt-case guaranteed that the timer interrupt
>does not preempt someone trying to modify the timer? The run_local_timers
>looks to have arrived via hardirq context. The spinlock in the tvec_base
>is a normal one and spin_lock_irqsave does not disable interrupts
>on rt, right?

this is, erm, harmless. We grab the timer lock via trylock in hardirq
context. If the lock is already taken then we fail to get it we go for
plan B. According to lockdep a trylock should not fail on UP. This is
true in general except for this timer case. I was thinking abour
disabling this lockdep check…

Sebastian
