Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3DPN2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:28:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:34966 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3DPN2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:28:14 -0400
Date: Tue, 16 Apr 2013 15:28:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Luck <tony.luck@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, magnus.damm@gmail.com
Subject: Re: [tip:smp/hotplug] idle: Implement generic idle function
In-Reply-To: <CA+8MBbLqTVSGpgCKFH79xDvW2brP6Gen7GiSRYW6EY8iDZE3yQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1304161527120.21884@ionos>
References: <20130321215233.646635455@linutronix.de> <tip-d166991234347215dc23fc9dc15a63a83a1a54e1@git.kernel.org> <CA+8MBbLqTVSGpgCKFH79xDvW2brP6Gen7GiSRYW6EY8iDZE3yQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Tony Luck wrote:

> Built next-20130415 and got this on ia64 early in boot:
> 
> WARNING: at kernel/cpu/idle.c:94 cpu_idle_loop+0x360/0x380()

Hmm, is safe_halt() returning with interrupts disabled? If yes, it
lacks a local_irq_enable().

Thanks,

	tglx
