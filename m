Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120Ab3DPSZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:25:52 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:50191 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3DPSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:25:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1304161527120.21884@ionos>
References: <20130321215233.646635455@linutronix.de>
	<tip-d166991234347215dc23fc9dc15a63a83a1a54e1@git.kernel.org>
	<CA+8MBbLqTVSGpgCKFH79xDvW2brP6Gen7GiSRYW6EY8iDZE3yQ@mail.gmail.com>
	<alpine.LFD.2.02.1304161527120.21884@ionos>
Date: Tue, 16 Apr 2013 11:25:50 -0700
Message-ID: <CA+8MBbL0Gp3Y7f8SEuOwV-CJB8Hf9OnjrpVp5E7twXXrGpDB_Q@mail.gmail.com>
Subject: Re: [tip:smp/hotplug] idle: Implement generic idle function
From: Tony Luck <tony.luck@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, magnus.damm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 6:28 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Hmm, is safe_halt() returning with interrupts disabled? If yes, it
> lacks a local_irq_enable().

Quite probably. Adding arch_local_irq_enable() to arch_safe_halt()
makes all the problems go away.  I'll send you the one-line patch
from a system that won't mung it like gmail will.

-Tony
